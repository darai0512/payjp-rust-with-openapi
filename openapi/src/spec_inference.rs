use std::borrow::Borrow;
use std::fmt::Write;

use anyhow::bail;
use heck::ToSnakeCase;
use openapiv3::{
    AdditionalProperties, IntegerFormat, ObjectType, ReferenceOr, Schema, SchemaKind, StringType,
    Type, VariantOrUnknownOrEmpty
};

use crate::rust_object::{
    EnumVariant, FieldlessVariant, ObjectMetadata, RustObject, Struct, StructField, Visibility,
};
use crate::rust_type::{ExtType, IntType, RustType, SimpleType};
use crate::spec::{as_data_array_item, as_object_enum_name, as_object_type, is_enum_with_just_empty_string};
use crate::types::{ComponentPath, RustIdent};
use crate::args;

#[derive(Copy, Clone, Debug)]
pub struct Inference<'a> {
    can_borrow: bool,
    id_path: Option<&'a ComponentPath>,
    curr_ident: &'a RustIdent,
    field_name: Option<&'a str>,
    description: Option<&'a str>,
    title: Option<&'a str>,
    required: bool,
    is_openapi_v31: bool,
}

impl<'a> Inference<'a> {
    pub fn new(ident: &'a RustIdent) -> Self {
        Self {
            can_borrow: false,
            field_name: None,
            description: None,
            required: false,
            curr_ident: ident,
            id_path: None,
            title: None,
            is_openapi_v31: false,
        }
    }

    pub fn can_borrow(mut self, can_borrow: bool) -> Self {
        self.can_borrow = can_borrow;
        self
    }

    pub fn is_openapi_v31(mut self, v31: bool) -> Self {
        self.is_openapi_v31 = v31;
        self
    }

    pub fn field_name(mut self, name: &'a str) -> Self {
        self.field_name = Some(name);
        self
    }

    pub fn maybe_description(mut self, desc: Option<&'a str>) -> Self {
        self.description = desc;
        self
    }

    pub fn id_path(mut self, path: &'a ComponentPath) -> Self {
        self.id_path = Some(path);
        self
    }

    pub fn title(mut self, title: Option<&'a str>) -> Self {
        self.title = title;
        self
    }

    pub fn curr_ident(mut self, ident: &'a RustIdent) -> Self {
        self.curr_ident = ident;
        self
    }

    pub fn required(mut self, is_required: bool) -> Self {
        self.required = is_required;
        self
    }

    fn next_ident(&self) -> RustIdent {
        if let Some(field_name) = self.field_name {
            RustIdent::joined(self.curr_ident, field_name)
        } else {
            self.curr_ident.clone()
        }
    }

    fn build_object_type(self, data: RustObject) -> RustType {
        let next_ident = self.next_ident();
        RustType::Object(
            data,
            ObjectMetadata {
                ident: next_ident,
                doc: self.description.map(|d| d.to_string()),
                title: self.title.map(|t| t.to_string()),
                field_name: self.field_name.map(|t| t.to_string()),
                parent: Some(self.curr_ident.clone()),
            },
        )
    }

    pub fn infer_schema_type(&self, schema: &Schema) -> RustType {
        let base_type = self.title(schema.schema_data.title.as_deref()).infer_base_type(schema);
        let is_nullable = schema.schema_data.nullable;
        if !self.required || is_nullable {
            base_type.into_nullable()
        } else {
            base_type
        }
    }

    fn should_infer_as_id_type(&self) -> bool {
        let Some(desc) = self.description else {
            return false;
        };
        if desc.starts_with("A cursor for use in pagination")
            || desc.starts_with("An object ID cursor")
        {
            return true;
        }
        if self.field_name == Some("id")
            && (desc.starts_with("Unique identifier")
                || desc.starts_with("The ID of the")
                || desc.starts_with("The identifier for the")
                || desc.starts_with("The [ID of the"))
        {
            return true;
        }

        false
    }

    fn infer_bool_type(&self) -> RustType {
        // NB: actually includes an `enum` field with only `true` as a more reliable
        // way to detect this case, but that is not exposed by the `openapi` crate
        let Some(desc) = self.description else {
            return RustType::bool();
        };
        if desc.contains("Always true for") {
            return RustType::ext(ExtType::AlwaysTrue);
        }
        RustType::bool()
    }

    fn infer_base_type(&self, field: &Schema) -> RustType {
        match &field.schema_kind {
            SchemaKind::Type(Type::Boolean(_)) => self.infer_bool_type(),
            SchemaKind::Type(Type::Number(_)) => RustType::float(),
            SchemaKind::Type(Type::Integer(format)) => self.infer_integer_type(&format.format),
            SchemaKind::Type(Type::String(typ)) => self.infer_string_typ(typ),
            SchemaKind::Type(Type::Array(typ)) => {
                let element = typ.items.as_ref().expect("Array type had no items field");
                let element_type = self.required(true).infer_schema_or_ref_type(element);
                if self.can_borrow {
                    RustType::slice(element_type)
                } else {
                    RustType::vec(element_type)
                }
            }
            SchemaKind::Type(Type::Object(typ)) => self.infer_object_typ(typ, field),
            SchemaKind::AnyOf { any_of: fields } | SchemaKind::OneOf { one_of: fields } => {
                self.infer_any_or_one_of(fields)
            }
            SchemaKind::AllOf { all_of: fields }  => {
                let a = fields[1].as_item().unwrap();
                let b = match &a.schema_kind {
                    SchemaKind::Type(Type::Object(obj)) => obj,
                    SchemaKind::Any(any) => {
                        let d = &ObjectType {
                            properties: any.properties.clone(),
                            additional_properties: any.additional_properties.clone(),
                            required: any.required.clone(),
                            min_properties: any.min_properties.clone(),
                            max_properties: any.max_properties.clone(),
                        };
                        let dd = as_data_array_item(d).unwrap();
                        let element_type = self.infer_schema_or_ref_type(dd);

                        &ObjectType {
                            properties: any.properties.clone(),
                            additional_properties: any.additional_properties.clone(),
                            required: any.required.clone(),
                            min_properties: any.min_properties.clone(),
                            max_properties: any.max_properties.clone(),
                        }
                    },
                    _ => {
                        panic!("unhandled field type");
                    }
                };
                let a = fields[0].as_item().unwrap();
                let b = match &a.schema_kind {
                    SchemaKind::Type(Type::Object(obj)) => obj,
                    SchemaKind::Any(any) => {
                        let b2 = match any.properties.get("data").unwrap() {
                            ReferenceOr::Reference { reference } => reference,
                            ReferenceOr::Item(item) => {
                                let a = &**item;
                                let bbb = match &a.schema_kind {
                                    SchemaKind::Type(Type::Array(typ)) => {
                                        let element = typ.items.as_ref().expect("Array type had no items field");
                                        let c = element.as_item();
                                        c
                                    },
                                    _ => {todo!()}
                                };
                                // let ccc = self.infer_base_type(bbb);
                                "Hoge"
                            }
                        };
                        // let b3 = any.properties.get("data").unwrap().as_item();
                        let d = &ObjectType {
                            properties: any.properties.clone(),
                            additional_properties: any.additional_properties.clone(),
                            required: any.required.clone(),
                            min_properties: any.min_properties.clone(),
                            max_properties: any.max_properties.clone(),
                        };
                        let dd = as_data_array_item(d).unwrap();
                        let element_type = self.infer_schema_or_ref_type(dd); //SchemaKind::Any(any)でpanicさせない工夫

                        &ObjectType {
                            properties: any.properties.clone(),
                            additional_properties: any.additional_properties.clone(),
                            required: any.required.clone(),
                            min_properties: any.min_properties.clone(),
                            max_properties: any.max_properties.clone(),
                        }
                    },
                    _ => {
                        panic!("unhandled field type");
                    }
                };
                // AllOf -> type::list で十分？他の
                self.infer_object_typ(b, field)
            }
            SchemaKind::Any(any) => {
                if !self.is_openapi_v31 || (any.properties.is_empty() && any.additional_properties.is_none() &&
                    self.field_name != Some("data")) {
                    panic!("unhandled field type");
                } else {
                    self.infer_object_typ(&ObjectType {
                        properties: any.properties.clone(),
                        additional_properties: any.additional_properties.clone(),
                        required: any.required.clone(),
                        min_properties: any.min_properties.clone(),
                        max_properties: any.max_properties.clone(),
                    }, field)
                }
            }
            _ => {
                panic!("unhandled field type");
            }
        }
    }

    fn infer_string_typ(&self, typ: &StringType) -> RustType {
        let variants = build_enum_variants(&typ.enumeration);

        if !variants.is_empty() {
            return self.build_object_type(RustObject::FieldlessEnum(variants));
        }
        /*
        if let Some(f_name) = self.field_name {
            if f_name == "currency" || f_name.ends_with("_currency") {
                return RustType::ext(ExtType::Currency);
            }
        }
         */

        if self.should_infer_as_id_type() {
            if let Some(id_path) = self.id_path {
                return RustType::object_id(id_path.clone(), self.can_borrow);
            }
        }

        if self.can_borrow {
            RustType::Simple(SimpleType::Str)
        } else {
            RustType::string()
        }
    }

    fn infer_object_typ(&self, typ: &ObjectType, field: &Schema) -> RustType {
        let obj_enum_name = as_object_enum_name(field);
        if Some("list") == obj_enum_name.as_deref() {
            let element = as_data_array_item(typ).unwrap_or_else(|| {
                panic!("Expected to find array item but found {:?}", field.schema_kind)
            });
            let element_type = self.required(true).infer_schema_or_ref_type(element);
            return RustType::list(element_type)
        }

        if let Some(AdditionalProperties::Schema(additional)) = &typ.additional_properties {
            let map_value_typ =
                self.required(true).can_borrow(false).infer_schema_or_ref_type(additional);
            return RustType::str_map(map_value_typ, self.can_borrow);
        }

        // NB: There is some inconsistency between usage of properties: {} and not including
        // the properties key in the OpenAPI spec where not including properties: {} seems
        // to imply that any object might be valid (or too complex for the OpenAPI spec). Since
        // we cannot distinguish between the 2 cases, we always default to serde_json::Value
        // when there is no specification of object shape.

        // FIXME: The unfortunate `field_name.is_some()` is used to avoid substituting
        // an arbitrary JSON value for a top level component type (see for example mandate_us_bank_account)
        if typ.properties.is_empty() && self.field_name.is_some() {
            return RustType::json_value();
        }

        // Generate the struct type
        let mut fields = vec![];
        let next_ident = self.next_ident();
        for (prop_field_name, field_spec) in &typ.properties {
            let is_required = typ.required.contains(prop_field_name);
            let field_desc =
                field_spec.as_item().and_then(|i| i.schema_data.description.as_deref());
            fields.push(
                self.required(is_required)
                    .curr_ident(&next_ident)
                    .maybe_description(field_desc)
                    .build_struct_field(prop_field_name, field_spec),
            );
        }
        self.build_object_type(RustObject::Struct(Struct::new(fields)))
    }

    fn infer_any_or_one_of(&self, fields: &[ReferenceOr<Schema>]) -> RustType {
        let fields = fields
            .iter()
            .filter(|field| !is_enum_with_just_empty_string(field))
            .collect::<Vec<_>>();
        if fields.len() == 1 {
            self.infer_schema_or_ref_type(fields[0])
        } else if fields[0].as_item().and_then(|s| s.schema_data.title.as_deref())
            == Some("range_query_specs")
        {
            RustType::ext(ExtType::RangeQueryTs)
        } else {
            let enum_ = self.build_enum_variants(fields).expect("Could not build enum with fields");
            self.build_object_type(RustObject::Enum(enum_))
        }
    }

    pub fn infer_schema_or_ref_type<T: Borrow<Schema>>(&self, field: &ReferenceOr<T>) -> RustType {
        match field {
            ReferenceOr::Reference { reference } => {
                let path = ComponentPath::from_reference(reference);
                // Must box `ApiErrors`, otherwise we end up with an infinitely
                // sized type
                let should_box = path.as_ref() == "api_errors";
                let mut typ = RustType::component_path(path);

                if should_box {
                    typ = RustType::boxed(typ);
                }
                if !self.required {
                    typ = typ.into_nullable();
                }
                typ
            }
            ReferenceOr::Item(schema) => {
                let schema = schema.borrow();
                self.infer_schema_type(schema)
            }
        }
    }

    pub fn build_struct_field<T: Borrow<Schema>>(
        &self,
        field_name: &str,
        field: &ReferenceOr<T>,
    ) -> StructField {
        let rust_type = self.field_name(field_name).infer_schema_or_ref_type(field);
        let mut field_rename = field_name.to_snake_case();
        if field_rename == "type" {
            field_rename = "type_".into();
        }

        // The `deleted` field is only used as a de/ser discriminant, so there is no reason to make it public
        let force_private =
            matches!(rust_type, RustType::Simple(SimpleType::Ext(ExtType::AlwaysTrue)));

        let mut struct_field = StructField::new(&field_rename, rust_type).required(self.required);
        if force_private {
            struct_field = struct_field.vis(Visibility::Private);
        }
        if let Some(doc) = self.description {
            struct_field = struct_field.doc(doc);
        }
        if field_rename != field_name {
            struct_field = struct_field.rename_as(field_name);
        }
        struct_field
    }

    fn build_enum_variants(
        &self,
        fields: Vec<&ReferenceOr<Schema>>,
    ) -> anyhow::Result<Vec<EnumVariant>> {
        let mut variants = Vec::with_capacity(fields.len());
        for option in fields {
            match option {
                ReferenceOr::Reference { reference } => {
                    let schema_path = ComponentPath::from_reference(reference);
                    variants.push(EnumVariant::new(
                        RustIdent::create(&schema_path),
                        RustType::component_path(schema_path),
                    ));
                }
                ReferenceOr::Item(item) => {
                    let mut ctx = self.required(true);
                    let inferred_name = infer_enum_variant_name(item);
                    if let Some(name) = inferred_name {
                        ctx = ctx.field_name(name);
                    }
                    let rust_type = ctx.required(true).infer_schema_type(item);
                    if let Some(RustObject::FieldlessEnum(fieldless_variants)) =
                        rust_type.as_rust_object()
                    {
                        for variant in fieldless_variants {
                            variants.push(EnumVariant::fieldless(variant.variant_name.clone()));
                        }
                    } else {
                        let variant_ident = if let Some(name) = inferred_name {
                            RustIdent::create(name)
                        } else if let RustType::Simple(typ) = &rust_type {
                            RustIdent::create(typ.display_name())
                        } else {
                            bail!(
                                "Could not infer a variant name for {item:?} and type {:?}",
                                rust_type
                            );
                        };
                        variants.push(EnumVariant::new(variant_ident, rust_type));
                    }
                }
            }
        }
        Ok(variants)
    }

    fn infer_integer_type(&self, int_fmt: &VariantOrUnknownOrEmpty<IntegerFormat>) -> RustType {
        if matches!(int_fmt, VariantOrUnknownOrEmpty::Unknown(inner) if inner == "unix-time") {
            return RustType::ext(ExtType::Timestamp);
        }

        // Infer based on field name, otherwise default
        let Some(name) = self.field_name else { return RustType::int(IntType::I64) };

        let name_snake = name.to_snake_case();
        let name_words = name_snake.split('_').collect::<Vec<_>>();
        if name_words.contains(&"date") {
            RustType::ext(ExtType::Timestamp)
        } else if name == "monthly_anchor" {
            RustType::int(IntType::U8)
        } else if name_words.contains(&"days") {
            RustType::int(IntType::U32)
        } else if name_words.contains(&"count")
            || name_words.contains(&"size")
            || name_words.contains(&"quantity")
        {
            RustType::int(IntType::U64)
        } else {
            RustType::int(IntType::I64)
        }
    }
}

fn build_enum_variants(options: &[Option<String>]) -> Vec<FieldlessVariant> {
    let mut enum_variants = vec![];
    for wire_name in options.iter().flatten() {
        if wire_name.trim().is_empty() {
            continue;
        }
        let variant_name = match wire_name.as_str() {
            "*" => RustIdent::create("all"),
            "self" => RustIdent::unchanged("Self_"),
            n => {
                if n.chars().next().unwrap().is_ascii_digit() {
                    RustIdent::unchanged(format!("V{}", n.replace(['-', '.'], "_")))
                } else {
                    // Hit for the case of timezones, e.g. Etc+7 and Etc-7
                    if wire_name.contains(['+', '-']) {
                        let cleaned = wire_name.replace('+', "Plus").replace('-', "Minus");
                        RustIdent::create(&cleaned)
                    } else {
                        RustIdent::create(wire_name)
                    }
                }
            }
        };
        enum_variants.push(FieldlessVariant::new(wire_name.clone(), variant_name));
    }
    enum_variants
}

fn infer_enum_variant_name(schema: &Schema) -> Option<&str> {
    if let Some(title) = &schema.schema_data.title {
        return Some(title);
    }
    if let Some(desc) = &schema.schema_data.description {
        if desc.contains("The ID of") {
            return Some("Id");
        }
    }
    None
}

/// Try to generate the best doc comment we can using the information provided. `doc_url`
/// is the source for more info.
pub fn infer_doc_comment(schema: &Schema) -> String {
    let mut doc_comment = if let Some(descr) = &schema.schema_data.description {
        descr.clone()
    } else if let Some(title) = &schema.schema_data.title {
        format!("The resource representing a Payjp {title}")
    } else {
        // This case is rare, but possible
        String::new()
    };
    let _ = writeln!(doc_comment, "\n\nFor more details see <{}>.", args.api_docs_url);
    doc_comment
}

