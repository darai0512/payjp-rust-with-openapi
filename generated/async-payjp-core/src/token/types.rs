/// For more details see <<https://stripe.com/docs/api/tokens/object>>.
#[derive(Clone,Debug,)]#[cfg_attr(feature = "serialize", derive(serde::Serialize))]
#[cfg_attr(feature = "deserialize", derive(serde::Deserialize))]
pub struct Token {
    /// tok_で始まる一意なオブジェクトを示す文字列
pub id: String,
    /// クレジットカードの情報を表すcardオブジェクト
pub card: TokenCard,
    /// このトークン作成時のタイムスタンプ
pub created: i64,
    /// 本番環境かどうか
pub livemode: bool,
    /// \"token\"の固定文字列
pub object: String,
    /// このトークンが使用済みかどうか
pub used: bool,

}
#[doc(hidden)]
pub struct TokenBuilder {
    id: Option<String>,
card: Option<TokenCard>,
created: Option<i64>,
livemode: Option<bool>,
object: Option<String>,
used: Option<bool>,

}

#[allow(unused_variables, irrefutable_let_patterns, clippy::let_unit_value, clippy::match_single_binding, clippy::single_match)]
const _: () = {
    use miniserde::de::{Map, Visitor};
    use miniserde::json::Value;
    use miniserde::{make_place, Deserialize, Result};
    use stripe_types::{MapBuilder, ObjectDeser};
    use stripe_types::miniserde_helpers::FromValueOpt;

    make_place!(Place);

    impl Deserialize for Token {
    fn begin(out: &mut Option<Self>) -> &mut dyn Visitor {
       Place::new(out)
    }
}

struct Builder<'a> {
    out: &'a mut Option<Token>,
    builder: TokenBuilder,
}

impl Visitor for Place<Token> {
    fn map(&mut self) -> Result<Box<dyn Map + '_>> {
        Ok(Box::new(Builder {
            out: &mut self.out,
            builder: TokenBuilder::deser_default(),
        }))
    }
}

impl MapBuilder for TokenBuilder {
    type Out = Token;
    fn key(&mut self, k: &str) -> Result<&mut dyn Visitor> {
        Ok(match k {
            "id" => Deserialize::begin(&mut self.id),
"card" => Deserialize::begin(&mut self.card),
"created" => Deserialize::begin(&mut self.created),
"livemode" => Deserialize::begin(&mut self.livemode),
"object" => Deserialize::begin(&mut self.object),
"used" => Deserialize::begin(&mut self.used),

            _ => <dyn Visitor>::ignore(),
        })
    }

    fn deser_default() -> Self {
        Self {
            id: Deserialize::default(),
card: Deserialize::default(),
created: Deserialize::default(),
livemode: Deserialize::default(),
object: Deserialize::default(),
used: Deserialize::default(),

        }
    }

    fn take_out(&mut self) -> Option<Self::Out> {
        let (Some(id),
Some(card),
Some(created),
Some(livemode),
Some(object),
Some(used),
) = (self.id.take(),
self.card.take(),
self.created,
self.livemode,
self.object.take(),
self.used,
) else {
            return None;
        };
        Some(Self::Out { id,card,created,livemode,object,used })
    }
}

impl<'a> Map for Builder<'a> {
    fn key(&mut self, k: &str) -> Result<&mut dyn Visitor> {
        self.builder.key(k)
    }

    fn finish(&mut self) -> Result<()> {
        *self.out = self.builder.take_out();
        Ok(())
    }
}

impl ObjectDeser for Token {
    type Builder = TokenBuilder;
}

impl FromValueOpt for Token {
    fn from_value(v: Value) -> Option<Self> {
        let Value::Object(obj) = v else {
            return None;
        };
        let mut b = TokenBuilder::deser_default();
        for (k, v) in obj {
            match k.as_str() {
                "id" => b.id = FromValueOpt::from_value(v),
"card" => b.card = FromValueOpt::from_value(v),
"created" => b.created = FromValueOpt::from_value(v),
"livemode" => b.livemode = FromValueOpt::from_value(v),
"object" => b.object = FromValueOpt::from_value(v),
"used" => b.used = FromValueOpt::from_value(v),

                _ => {}
            }
        }
        b.take_out()
    }
}

};
/// クレジットカードの情報を表すcardオブジェクト
#[derive(Clone,Debug,)]#[cfg_attr(feature = "serialize", derive(serde::Serialize))]
#[cfg_attr(feature = "deserialize", derive(serde::Deserialize))]
pub struct TokenCard {
    /// car_で始まり一意なオブジェクトを示す、最大32桁の文字列
pub id: String,
    /// \"card\"の固定文字列
pub object: Option<String>,
    /// カード作成時のタイムスタンプ
pub created: Option<i64>,
    /// カード保有者名
pub name: Option<String>,
    /// カード番号の下四桁
pub last4: Option<String>,
    /// 有効期限月
pub exp_month: Option<i64>,
    /// 有効期限年
pub exp_year: Option<i64>,
    /// カードブランド名
pub brand: Option<TokenCardBrand>,
    /// CVCコードチェックの結果
pub cvc_check: Option<String>,
    /// 3Dセキュアの実施結果。
    /// 加盟店において3Dセキュアが有効でない等未実施の場合null。
pub three_d_secure_status: Option<String>,
    /// このクレジットカード番号に紐づく値。
        /// 同一番号のカードからは同一の値が生成されることが保証されており、 トークン化の度にトークンIDは変わりますが、この値は変わりません。.
pub fingerprint: Option<String>,
    /// メールアドレス
        /// 2024年8月以降、3Dセキュア認証の際にphoneまたはemailのデータ入力が求められます。.
pub email: Option<String>,
    /// E.164形式の電話番号 (e.g. 090-0123-4567（日本） => "+819001234567")
        /// 2024年8月以降、3Dセキュア認証の際にphoneまたはemailのデータ入力が求められます。.
pub phone: Option<String>,
    /// 都道府県
pub address_state: Option<String>,
    /// 市区町村
pub address_city: Option<String>,
    /// 番地など
pub address_line1: Option<String>,
    /// 建物名など
pub address_line2: Option<String>,
    /// 2桁のISOコード(e.g. JP)
pub country: Option<String>,
    /// 郵便番号
pub address_zip: Option<String>,
    /// 郵便番号存在チェックの結果
pub address_zip_check: Option<String>,
    /// 顧客オブジェクトのID
pub customer: Option<String>,
    /// キーバリューの任意データ
#[cfg_attr(any(feature = "deserialize", feature = "serialize"), serde(with = "stripe_types::with_serde_json_opt"))]
pub metadata: Option<miniserde::json::Value>,

}
#[doc(hidden)]
pub struct TokenCardBuilder {
    id: Option<String>,
object: Option<Option<String>>,
created: Option<Option<i64>>,
name: Option<Option<String>>,
last4: Option<Option<String>>,
exp_month: Option<Option<i64>>,
exp_year: Option<Option<i64>>,
brand: Option<Option<TokenCardBrand>>,
cvc_check: Option<Option<String>>,
three_d_secure_status: Option<Option<String>>,
fingerprint: Option<Option<String>>,
email: Option<Option<String>>,
phone: Option<Option<String>>,
address_state: Option<Option<String>>,
address_city: Option<Option<String>>,
address_line1: Option<Option<String>>,
address_line2: Option<Option<String>>,
country: Option<Option<String>>,
address_zip: Option<Option<String>>,
address_zip_check: Option<Option<String>>,
customer: Option<Option<String>>,
metadata: Option<Option<miniserde::json::Value>>,

}

#[allow(unused_variables, irrefutable_let_patterns, clippy::let_unit_value, clippy::match_single_binding, clippy::single_match)]
const _: () = {
    use miniserde::de::{Map, Visitor};
    use miniserde::json::Value;
    use miniserde::{make_place, Deserialize, Result};
    use stripe_types::{MapBuilder, ObjectDeser};
    use stripe_types::miniserde_helpers::FromValueOpt;

    make_place!(Place);

    impl Deserialize for TokenCard {
    fn begin(out: &mut Option<Self>) -> &mut dyn Visitor {
       Place::new(out)
    }
}

struct Builder<'a> {
    out: &'a mut Option<TokenCard>,
    builder: TokenCardBuilder,
}

impl Visitor for Place<TokenCard> {
    fn map(&mut self) -> Result<Box<dyn Map + '_>> {
        Ok(Box::new(Builder {
            out: &mut self.out,
            builder: TokenCardBuilder::deser_default(),
        }))
    }
}

impl MapBuilder for TokenCardBuilder {
    type Out = TokenCard;
    fn key(&mut self, k: &str) -> Result<&mut dyn Visitor> {
        Ok(match k {
            "id" => Deserialize::begin(&mut self.id),
"object" => Deserialize::begin(&mut self.object),
"created" => Deserialize::begin(&mut self.created),
"name" => Deserialize::begin(&mut self.name),
"last4" => Deserialize::begin(&mut self.last4),
"exp_month" => Deserialize::begin(&mut self.exp_month),
"exp_year" => Deserialize::begin(&mut self.exp_year),
"brand" => Deserialize::begin(&mut self.brand),
"cvc_check" => Deserialize::begin(&mut self.cvc_check),
"three_d_secure_status" => Deserialize::begin(&mut self.three_d_secure_status),
"fingerprint" => Deserialize::begin(&mut self.fingerprint),
"email" => Deserialize::begin(&mut self.email),
"phone" => Deserialize::begin(&mut self.phone),
"address_state" => Deserialize::begin(&mut self.address_state),
"address_city" => Deserialize::begin(&mut self.address_city),
"address_line1" => Deserialize::begin(&mut self.address_line1),
"address_line2" => Deserialize::begin(&mut self.address_line2),
"country" => Deserialize::begin(&mut self.country),
"address_zip" => Deserialize::begin(&mut self.address_zip),
"address_zip_check" => Deserialize::begin(&mut self.address_zip_check),
"customer" => Deserialize::begin(&mut self.customer),
"metadata" => Deserialize::begin(&mut self.metadata),

            _ => <dyn Visitor>::ignore(),
        })
    }

    fn deser_default() -> Self {
        Self {
            id: Deserialize::default(),
object: Deserialize::default(),
created: Deserialize::default(),
name: Deserialize::default(),
last4: Deserialize::default(),
exp_month: Deserialize::default(),
exp_year: Deserialize::default(),
brand: Deserialize::default(),
cvc_check: Deserialize::default(),
three_d_secure_status: Deserialize::default(),
fingerprint: Deserialize::default(),
email: Deserialize::default(),
phone: Deserialize::default(),
address_state: Deserialize::default(),
address_city: Deserialize::default(),
address_line1: Deserialize::default(),
address_line2: Deserialize::default(),
country: Deserialize::default(),
address_zip: Deserialize::default(),
address_zip_check: Deserialize::default(),
customer: Deserialize::default(),
metadata: Deserialize::default(),

        }
    }

    fn take_out(&mut self) -> Option<Self::Out> {
        let (Some(id),
Some(object),
Some(created),
Some(name),
Some(last4),
Some(exp_month),
Some(exp_year),
Some(brand),
Some(cvc_check),
Some(three_d_secure_status),
Some(fingerprint),
Some(email),
Some(phone),
Some(address_state),
Some(address_city),
Some(address_line1),
Some(address_line2),
Some(country),
Some(address_zip),
Some(address_zip_check),
Some(customer),
Some(metadata),
) = (self.id.take(),
self.object.take(),
self.created,
self.name.take(),
self.last4.take(),
self.exp_month,
self.exp_year,
self.brand,
self.cvc_check.take(),
self.three_d_secure_status.take(),
self.fingerprint.take(),
self.email.take(),
self.phone.take(),
self.address_state.take(),
self.address_city.take(),
self.address_line1.take(),
self.address_line2.take(),
self.country.take(),
self.address_zip.take(),
self.address_zip_check.take(),
self.customer.take(),
self.metadata.take(),
) else {
            return None;
        };
        Some(Self::Out { id,object,created,name,last4,exp_month,exp_year,brand,cvc_check,three_d_secure_status,fingerprint,email,phone,address_state,address_city,address_line1,address_line2,country,address_zip,address_zip_check,customer,metadata })
    }
}

impl<'a> Map for Builder<'a> {
    fn key(&mut self, k: &str) -> Result<&mut dyn Visitor> {
        self.builder.key(k)
    }

    fn finish(&mut self) -> Result<()> {
        *self.out = self.builder.take_out();
        Ok(())
    }
}

impl ObjectDeser for TokenCard {
    type Builder = TokenCardBuilder;
}

impl FromValueOpt for TokenCard {
    fn from_value(v: Value) -> Option<Self> {
        let Value::Object(obj) = v else {
            return None;
        };
        let mut b = TokenCardBuilder::deser_default();
        for (k, v) in obj {
            match k.as_str() {
                "id" => b.id = FromValueOpt::from_value(v),
"object" => b.object = FromValueOpt::from_value(v),
"created" => b.created = FromValueOpt::from_value(v),
"name" => b.name = FromValueOpt::from_value(v),
"last4" => b.last4 = FromValueOpt::from_value(v),
"exp_month" => b.exp_month = FromValueOpt::from_value(v),
"exp_year" => b.exp_year = FromValueOpt::from_value(v),
"brand" => b.brand = FromValueOpt::from_value(v),
"cvc_check" => b.cvc_check = FromValueOpt::from_value(v),
"three_d_secure_status" => b.three_d_secure_status = FromValueOpt::from_value(v),
"fingerprint" => b.fingerprint = FromValueOpt::from_value(v),
"email" => b.email = FromValueOpt::from_value(v),
"phone" => b.phone = FromValueOpt::from_value(v),
"address_state" => b.address_state = FromValueOpt::from_value(v),
"address_city" => b.address_city = FromValueOpt::from_value(v),
"address_line1" => b.address_line1 = FromValueOpt::from_value(v),
"address_line2" => b.address_line2 = FromValueOpt::from_value(v),
"country" => b.country = FromValueOpt::from_value(v),
"address_zip" => b.address_zip = FromValueOpt::from_value(v),
"address_zip_check" => b.address_zip_check = FromValueOpt::from_value(v),
"customer" => b.customer = FromValueOpt::from_value(v),
"metadata" => b.metadata = FromValueOpt::from_value(v),

                _ => {}
            }
        }
        b.take_out()
    }
}

};
/// カードブランド名
#[derive(Copy,Clone,Eq, PartialEq,)]pub enum TokenCardBrand {
Visa,
MasterCard,
Jcb,
AmericanExpress,
DinersClub,
Discover,

}
impl TokenCardBrand {
    pub fn as_str(self) -> &'static str {
        use TokenCardBrand::*;
        match self {
Visa => "Visa",
MasterCard => "MasterCard",
Jcb => "JCB",
AmericanExpress => "American Express",
DinersClub => "Diners Club",
Discover => "Discover",

        }
    }
}

impl std::str::FromStr for TokenCardBrand {
    type Err = stripe_types::StripeParseError;
    fn from_str(s: &str) -> Result<Self, Self::Err> {
        use TokenCardBrand::*;
        match s {
    "Visa" => Ok(Visa),
"MasterCard" => Ok(MasterCard),
"JCB" => Ok(Jcb),
"American Express" => Ok(AmericanExpress),
"Diners Club" => Ok(DinersClub),
"Discover" => Ok(Discover),
_ => Err(stripe_types::StripeParseError)

        }
    }
}
impl std::fmt::Display for TokenCardBrand {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        f.write_str(self.as_str())
    }
}

impl std::fmt::Debug for TokenCardBrand {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        f.write_str(self.as_str())
    }
}
#[cfg(feature = "serialize")]
impl serde::Serialize for TokenCardBrand {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error> where S: serde::Serializer {
        serializer.serialize_str(self.as_str())
    }
}
impl miniserde::Deserialize for TokenCardBrand {
    fn begin(out: &mut Option<Self>) -> &mut dyn miniserde::de::Visitor {
        crate::Place::new(out)
    }
}

impl miniserde::de::Visitor for crate::Place<TokenCardBrand> {
    fn string(&mut self, s: &str) -> miniserde::Result<()> {
        use std::str::FromStr;
        self.out = Some(TokenCardBrand::from_str(s).map_err(|_| miniserde::Error)?);
        Ok(())
    }
}

stripe_types::impl_from_val_with_from_str!(TokenCardBrand);
#[cfg(feature = "deserialize")]
impl<'de> serde::Deserialize<'de> for TokenCardBrand {
    fn deserialize<D: serde::Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
        use std::str::FromStr;
        let s: std::borrow::Cow<'de, str> = serde::Deserialize::deserialize(deserializer)?;
        Self::from_str(&s).map_err(|_| serde::de::Error::custom("Unknown value for TokenCardBrand"))
    }
}
