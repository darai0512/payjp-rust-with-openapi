/// This object represents a customer of your business.
/// Use it to create recurring charges and track payments that belong to the same customer.
///
/// Related guide: [Save a card during payment](https://stripe.com/docs/payments/save-during-payment)
///
/// For more details see <<https://stripe.com/docs/api/customers/object>>.
#[derive(Clone, Debug)]
#[cfg_attr(feature = "deserialize", derive(serde::Deserialize))]
pub struct Customer {
    /// Time at which the object was created. Measured in seconds since the Unix epoch.
    pub created: stripe_types::Timestamp,
    /// Three-letter [ISO code for the currency](https://stripe.com/docs/currencies) the customer can be charged in for recurring billing purposes.
    pub currency: Option<stripe_types::Currency>,
    /// An arbitrary string attached to the object. Often useful for displaying to users.
    pub description: Option<String>,
    /// The customer's email address.
    pub email: Option<String>,
    /// Unique identifier for the object.
    pub id: stripe_shared::CustomerId,
    /// The current multi-currency balances, if any, that's stored on the customer.
    /// If positive in a currency, the customer has a credit to apply to their next invoice denominated in that currency.
    /// If negative, the customer has an amount owed that's added to their next invoice denominated in that currency.
    /// These balances don't apply to unpaid invoices.
    /// They solely track amounts that Stripe hasn't successfully applied to any invoice.
    /// Stripe only applies a balance in a specific currency to an invoice after that invoice (which is in the same currency) finalizes.
    pub default_card: Option<String>,
    /// Has the value `true` if the object exists in live mode or the value `false` if the object exists in test mode.
    pub livemode: bool,
    /// Set of [key-value pairs](https://stripe.com/docs/api/metadata) that you can attach to an object.
    /// This can be useful for storing additional information about the object in a structured format.
    pub metadata: Option<std::collections::HashMap<String, String>>,
    /// The customer's current subscriptions, if any.
    pub subscriptions: Option<stripe_types::List<stripe_shared::Subscription>>,

    pub cards: Option<stripe_types::List<stripe_shared::Subscription>>,
    // pub preferred_locales: Option<Vec<String>>,
    // pub invoice_credit_balance: Option<std::collections::HashMap<String, i64>>,
}
#[doc(hidden)]
pub struct CustomerBuilder {
    created: Option<stripe_types::Timestamp>,
    currency: Option<Option<stripe_types::Currency>>,
    description: Option<Option<String>>,
    email: Option<Option<String>>,
    id: Option<stripe_shared::CustomerId>,
    default_card: Option<Option<String>>,
    livemode: Option<bool>,
    metadata: Option<Option<std::collections::HashMap<String, String>>>,
    subscriptions: Option<Option<stripe_types::List<stripe_shared::Subscription>>>,
    cards: Option<Option<stripe_types::List<stripe_shared::Subscription>>>,
}

#[allow(
    unused_variables,
    irrefutable_let_patterns,
    clippy::let_unit_value,
    clippy::match_single_binding,
    clippy::single_match
)]
const _: () = {
    use miniserde::de::{Map, Visitor};
    use miniserde::json::Value;
    use miniserde::{make_place, Deserialize, Result};
    use stripe_types::miniserde_helpers::FromValueOpt;
    use stripe_types::{MapBuilder, ObjectDeser};

    make_place!(Place);

    impl Deserialize for Customer {
        fn begin(out: &mut Option<Self>) -> &mut dyn Visitor {
            Place::new(out)
        }
    }

    struct Builder<'a> {
        out: &'a mut Option<Customer>,
        builder: CustomerBuilder,
    }

    impl Visitor for Place<Customer> {
        fn map(&mut self) -> Result<Box<dyn Map + '_>> {
            Ok(Box::new(Builder { out: &mut self.out, builder: CustomerBuilder::deser_default() }))
        }
    }

    impl MapBuilder for CustomerBuilder {
        type Out = Customer;
        fn key(&mut self, k: &str) -> Result<&mut dyn Visitor> {
            Ok(match k {
                "created" => Deserialize::begin(&mut self.created),
                "currency" => Deserialize::begin(&mut self.currency),
                "description" => Deserialize::begin(&mut self.description),
                "email" => Deserialize::begin(&mut self.email),
                "id" => Deserialize::begin(&mut self.id),
                "default_card" => Deserialize::begin(&mut self.default_card),
                "livemode" => Deserialize::begin(&mut self.livemode),
                "metadata" => Deserialize::begin(&mut self.metadata),
                "subscriptions" => Deserialize::begin(&mut self.subscriptions),
                "cards" => Deserialize::begin(&mut self.cards),

                _ => <dyn Visitor>::ignore(),
            })
        }

        fn deser_default() -> Self {
            Self {
                created: Deserialize::default(),
                currency: Deserialize::default(),
                description: Deserialize::default(),
                email: Deserialize::default(),
                id: Deserialize::default(),
                default_card: Deserialize::default(),
                livemode: Deserialize::default(),
                metadata: Deserialize::default(),
                subscriptions: Deserialize::default(),
                cards: Deserialize::default(),
            }
        }

        fn take_out(&mut self) -> Option<Self::Out> {
            let (
                Some(created),
                Some(currency),
                Some(description),
                Some(email),
                Some(id),
                Some(default_card),
                Some(livemode),
                Some(metadata),
                Some(subscriptions),
                Some(cards),
            ) = (
                self.created,
                self.currency,
                self.description.take(),
                self.email.take(),
                self.id.take(),
                self.default_card.take(),
                self.livemode,
                self.metadata.take(),
                self.subscriptions.take(),
                self.cards.take(),
            )
            else {
                return None;
            };
            Some(Self::Out {
                created,
                currency,
                description,
                email,
                id,
                default_card,
                livemode,
                metadata,
                subscriptions,
                cards,
            })
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

    impl ObjectDeser for Customer {
        type Builder = CustomerBuilder;
    }

    impl FromValueOpt for Customer {
        fn from_value(v: Value) -> Option<Self> {
            let Value::Object(obj) = v else {
                return None;
            };
            let mut b = CustomerBuilder::deser_default();
            for (k, v) in obj {
                match k.as_str() {
                    "created" => b.created = FromValueOpt::from_value(v),
                    "currency" => b.currency = FromValueOpt::from_value(v),
                    "description" => b.description = FromValueOpt::from_value(v),
                    "email" => b.email = FromValueOpt::from_value(v),
                    "id" => b.id = FromValueOpt::from_value(v),
                    "default_card" => b.default_card = FromValueOpt::from_value(v),
                    "livemode" => b.livemode = FromValueOpt::from_value(v),
                    "metadata" => b.metadata = FromValueOpt::from_value(v),
                    "subscriptions" => b.subscriptions = FromValueOpt::from_value(v),
                    "cards" => b.cards = FromValueOpt::from_value(v),

                    _ => {}
                }
            }
            b.take_out()
        }
    }
};
#[cfg(feature = "serialize")]
impl serde::Serialize for Customer {
    fn serialize<S: serde::Serializer>(&self, s: S) -> Result<S::Ok, S::Error> {
        use serde::ser::SerializeStruct;
        let mut s = s.serialize_struct("Customer", 28)?;
        s.serialize_field("currency", &self.currency)?;
        s.serialize_field("description", &self.description)?;
        s.serialize_field("email", &self.email)?;
        s.serialize_field("id", &self.id)?;
        s.serialize_field("default_card", &self.default_card)?;
        s.serialize_field("livemode", &self.livemode)?;
        s.serialize_field("metadata", &self.metadata)?;
        s.serialize_field("subscriptions", &self.subscriptions)?;
        s.serialize_field("cards", &self.cards)?;

        s.serialize_field("object", "customer")?;
        s.end()
    }
}
impl stripe_types::Object for Customer {
    type Id = stripe_shared::CustomerId;
    fn id(&self) -> &Self::Id {
        &self.id
    }

    fn into_id(self) -> Self::Id {
        self.id
    }
}
stripe_types::def_id!(CustomerId);
#[derive(Copy, Clone, Eq, PartialEq)]
pub enum CustomerTaxExempt {
    Exempt,
    None,
    Reverse,
}
impl CustomerTaxExempt {
    pub fn as_str(self) -> &'static str {
        use CustomerTaxExempt::*;
        match self {
            Exempt => "exempt",
            None => "none",
            Reverse => "reverse",
        }
    }
}

impl std::str::FromStr for CustomerTaxExempt {
    type Err = stripe_types::StripeParseError;
    fn from_str(s: &str) -> Result<Self, Self::Err> {
        use CustomerTaxExempt::*;
        match s {
            "exempt" => Ok(Exempt),
            "none" => Ok(None),
            "reverse" => Ok(Reverse),
            _ => Err(stripe_types::StripeParseError),
        }
    }
}
impl std::fmt::Display for CustomerTaxExempt {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        f.write_str(self.as_str())
    }
}

impl std::fmt::Debug for CustomerTaxExempt {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        f.write_str(self.as_str())
    }
}
impl serde::Serialize for CustomerTaxExempt {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: serde::Serializer,
    {
        serializer.serialize_str(self.as_str())
    }
}
impl miniserde::Deserialize for CustomerTaxExempt {
    fn begin(out: &mut Option<Self>) -> &mut dyn miniserde::de::Visitor {
        crate::Place::new(out)
    }
}

impl miniserde::de::Visitor for crate::Place<CustomerTaxExempt> {
    fn string(&mut self, s: &str) -> miniserde::Result<()> {
        use std::str::FromStr;
        self.out = Some(CustomerTaxExempt::from_str(s).map_err(|_| miniserde::Error)?);
        Ok(())
    }
}

stripe_types::impl_from_val_with_from_str!(CustomerTaxExempt);
#[cfg(feature = "deserialize")]
impl<'de> serde::Deserialize<'de> for CustomerTaxExempt {
    fn deserialize<D: serde::Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
        use std::str::FromStr;
        let s: std::borrow::Cow<'de, str> = serde::Deserialize::deserialize(deserializer)?;
        Self::from_str(&s)
            .map_err(|_| serde::de::Error::custom("Unknown value for CustomerTaxExempt"))
    }
}
