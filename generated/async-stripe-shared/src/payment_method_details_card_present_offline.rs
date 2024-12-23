#[derive(Copy, Clone, Debug)]
#[cfg_attr(feature = "serialize", derive(serde::Serialize))]
#[cfg_attr(feature = "deserialize", derive(serde::Deserialize))]
pub struct PaymentMethodDetailsCardPresentOffline {
    /// Time at which the payment was collected while offline
    pub stored_at: Option<stripe_types::Timestamp>,
}
#[doc(hidden)]
pub struct PaymentMethodDetailsCardPresentOfflineBuilder {
    stored_at: Option<Option<stripe_types::Timestamp>>,
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

    impl Deserialize for PaymentMethodDetailsCardPresentOffline {
        fn begin(out: &mut Option<Self>) -> &mut dyn Visitor {
            Place::new(out)
        }
    }

    struct Builder<'a> {
        out: &'a mut Option<PaymentMethodDetailsCardPresentOffline>,
        builder: PaymentMethodDetailsCardPresentOfflineBuilder,
    }

    impl Visitor for Place<PaymentMethodDetailsCardPresentOffline> {
        fn map(&mut self) -> Result<Box<dyn Map + '_>> {
            Ok(Box::new(Builder {
                out: &mut self.out,
                builder: PaymentMethodDetailsCardPresentOfflineBuilder::deser_default(),
            }))
        }
    }

    impl MapBuilder for PaymentMethodDetailsCardPresentOfflineBuilder {
        type Out = PaymentMethodDetailsCardPresentOffline;
        fn key(&mut self, k: &str) -> Result<&mut dyn Visitor> {
            Ok(match k {
                "stored_at" => Deserialize::begin(&mut self.stored_at),

                _ => <dyn Visitor>::ignore(),
            })
        }

        fn deser_default() -> Self {
            Self { stored_at: Deserialize::default() }
        }

        fn take_out(&mut self) -> Option<Self::Out> {
            let (Some(stored_at),) = (self.stored_at,) else {
                return None;
            };
            Some(Self::Out { stored_at })
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

    impl ObjectDeser for PaymentMethodDetailsCardPresentOffline {
        type Builder = PaymentMethodDetailsCardPresentOfflineBuilder;
    }

    impl FromValueOpt for PaymentMethodDetailsCardPresentOffline {
        fn from_value(v: Value) -> Option<Self> {
            let Value::Object(obj) = v else {
                return None;
            };
            let mut b = PaymentMethodDetailsCardPresentOfflineBuilder::deser_default();
            for (k, v) in obj {
                match k.as_str() {
                    "stored_at" => b.stored_at = FromValueOpt::from_value(v),

                    _ => {}
                }
            }
            b.take_out()
        }
    }
};
