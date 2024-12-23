#[derive(Clone, Debug)]
#[cfg_attr(feature = "serialize", derive(serde::Serialize))]
#[cfg_attr(feature = "deserialize", derive(serde::Deserialize))]
pub struct PaymentMethodDetailsPaypal {
    /// Owner's email. Values are provided by PayPal directly
    /// (if supported) at the time of authorization or settlement. They cannot be set or mutated.
    pub payer_email: Option<String>,
    /// PayPal account PayerID. This identifier uniquely identifies the PayPal customer.
    pub payer_id: Option<String>,
    /// Owner's full name. Values provided by PayPal directly
    /// (if supported) at the time of authorization or settlement. They cannot be set or mutated.
    pub payer_name: Option<String>,
    /// The level of protection offered as defined by PayPal Seller Protection for Merchants, for this transaction.
    pub seller_protection: Option<stripe_shared::PaypalSellerProtection>,
    /// A unique ID generated by PayPal for this transaction.
    pub transaction_id: Option<String>,
}
#[doc(hidden)]
pub struct PaymentMethodDetailsPaypalBuilder {
    payer_email: Option<Option<String>>,
    payer_id: Option<Option<String>>,
    payer_name: Option<Option<String>>,
    seller_protection: Option<Option<stripe_shared::PaypalSellerProtection>>,
    transaction_id: Option<Option<String>>,
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

    impl Deserialize for PaymentMethodDetailsPaypal {
        fn begin(out: &mut Option<Self>) -> &mut dyn Visitor {
            Place::new(out)
        }
    }

    struct Builder<'a> {
        out: &'a mut Option<PaymentMethodDetailsPaypal>,
        builder: PaymentMethodDetailsPaypalBuilder,
    }

    impl Visitor for Place<PaymentMethodDetailsPaypal> {
        fn map(&mut self) -> Result<Box<dyn Map + '_>> {
            Ok(Box::new(Builder {
                out: &mut self.out,
                builder: PaymentMethodDetailsPaypalBuilder::deser_default(),
            }))
        }
    }

    impl MapBuilder for PaymentMethodDetailsPaypalBuilder {
        type Out = PaymentMethodDetailsPaypal;
        fn key(&mut self, k: &str) -> Result<&mut dyn Visitor> {
            Ok(match k {
                "payer_email" => Deserialize::begin(&mut self.payer_email),
                "payer_id" => Deserialize::begin(&mut self.payer_id),
                "payer_name" => Deserialize::begin(&mut self.payer_name),
                "seller_protection" => Deserialize::begin(&mut self.seller_protection),
                "transaction_id" => Deserialize::begin(&mut self.transaction_id),

                _ => <dyn Visitor>::ignore(),
            })
        }

        fn deser_default() -> Self {
            Self {
                payer_email: Deserialize::default(),
                payer_id: Deserialize::default(),
                payer_name: Deserialize::default(),
                seller_protection: Deserialize::default(),
                transaction_id: Deserialize::default(),
            }
        }

        fn take_out(&mut self) -> Option<Self::Out> {
            let (
                Some(payer_email),
                Some(payer_id),
                Some(payer_name),
                Some(seller_protection),
                Some(transaction_id),
            ) = (
                self.payer_email.take(),
                self.payer_id.take(),
                self.payer_name.take(),
                self.seller_protection.take(),
                self.transaction_id.take(),
            )
            else {
                return None;
            };
            Some(Self::Out { payer_email, payer_id, payer_name, seller_protection, transaction_id })
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

    impl ObjectDeser for PaymentMethodDetailsPaypal {
        type Builder = PaymentMethodDetailsPaypalBuilder;
    }

    impl FromValueOpt for PaymentMethodDetailsPaypal {
        fn from_value(v: Value) -> Option<Self> {
            let Value::Object(obj) = v else {
                return None;
            };
            let mut b = PaymentMethodDetailsPaypalBuilder::deser_default();
            for (k, v) in obj {
                match k.as_str() {
                    "payer_email" => b.payer_email = FromValueOpt::from_value(v),
                    "payer_id" => b.payer_id = FromValueOpt::from_value(v),
                    "payer_name" => b.payer_name = FromValueOpt::from_value(v),
                    "seller_protection" => b.seller_protection = FromValueOpt::from_value(v),
                    "transaction_id" => b.transaction_id = FromValueOpt::from_value(v),

                    _ => {}
                }
            }
            b.take_out()
        }
    }
};
