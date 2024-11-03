use indexmap::IndexMap;

use crate::rust_object::{ObjectMetadata, ObjectUsage, RustObject};
use crate::rust_type::{PathToType, RustType};
use crate::visitor::VisitMut;

#[derive(Debug, Clone, Eq, PartialEq)]
pub struct OverrideMetadata {
    pub metadata: ObjectMetadata,
    pub mod_path: String,
}

pub struct Overrides {
    pub overrides: IndexMap<RustObject, OverrideMetadata>,
}

impl Overrides {
    pub fn new() -> anyhow::Result<Self> {
        let overrides = IndexMap::new();
        Ok(Self { overrides })
    }
}

impl VisitMut for Overrides {
    fn visit_typ_mut(&mut self, typ: &mut RustType, usage: ObjectUsage) {
        if let Some((obj, _)) = typ.as_object_mut() {
            if let Some(meta) = self.overrides.get(obj) {
                *typ = RustType::path(PathToType::Shared(meta.metadata.ident.clone()), false);
            }
        }
        typ.visit_mut(self, usage);
    }
}
