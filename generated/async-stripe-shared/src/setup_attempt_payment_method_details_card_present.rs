#[derive(Clone, Debug)]
#[cfg_attr(feature = "serialize", derive(serde::Serialize))]
#[cfg_attr(feature = "deserialize", derive(serde::Deserialize))]
pub struct SetupAttemptPaymentMethodDetailsCardPresent {
    /// The ID of the Card PaymentMethod which was generated by this SetupAttempt.
    pub generated_card: Option<stripe_types::Expandable<stripe_shared::PaymentMethod>>,
    /// Details about payments collected offline.
    pub offline: Option<stripe_shared::PaymentMethodDetailsCardPresentOffline>,
}
#[doc(hidden)]
pub struct SetupAttemptPaymentMethodDetailsCardPresentBuilder {
    generated_card: Option<Option<stripe_types::Expandable<stripe_shared::PaymentMethod>>>,
    offline: Option<Option<stripe_shared::PaymentMethodDetailsCardPresentOffline>>,
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

    impl Deserialize for SetupAttemptPaymentMethodDetailsCardPresent {
        fn begin(out: &mut Option<Self>) -> &mut dyn Visitor {
            Place::new(out)
        }
    }

    struct Builder<'a> {
        out: &'a mut Option<SetupAttemptPaymentMethodDetailsCardPresent>,
        builder: SetupAttemptPaymentMethodDetailsCardPresentBuilder,
    }

    impl Visitor for Place<SetupAttemptPaymentMethodDetailsCardPresent> {
        fn map(&mut self) -> Result<Box<dyn Map + '_>> {
            Ok(Box::new(Builder {
                out: &mut self.out,
                builder: SetupAttemptPaymentMethodDetailsCardPresentBuilder::deser_default(),
            }))
        }
    }

    impl MapBuilder for SetupAttemptPaymentMethodDetailsCardPresentBuilder {
        type Out = SetupAttemptPaymentMethodDetailsCardPresent;
        fn key(&mut self, k: &str) -> Result<&mut dyn Visitor> {
            Ok(match k {
                "generated_card" => Deserialize::begin(&mut self.generated_card),
                "offline" => Deserialize::begin(&mut self.offline),

                _ => <dyn Visitor>::ignore(),
            })
        }

        fn deser_default() -> Self {
            Self { generated_card: Deserialize::default(), offline: Deserialize::default() }
        }

        fn take_out(&mut self) -> Option<Self::Out> {
            let (Some(generated_card), Some(offline)) = (self.generated_card.take(), self.offline)
            else {
                return None;
            };
            Some(Self::Out { generated_card, offline })
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

    impl ObjectDeser for SetupAttemptPaymentMethodDetailsCardPresent {
        type Builder = SetupAttemptPaymentMethodDetailsCardPresentBuilder;
    }

    impl FromValueOpt for SetupAttemptPaymentMethodDetailsCardPresent {
        fn from_value(v: Value) -> Option<Self> {
            let Value::Object(obj) = v else {
                return None;
            };
            let mut b = SetupAttemptPaymentMethodDetailsCardPresentBuilder::deser_default();
            for (k, v) in obj {
                match k.as_str() {
                    "generated_card" => b.generated_card = FromValueOpt::from_value(v),
                    "offline" => b.offline = FromValueOpt::from_value(v),

                    _ => {}
                }
            }
            b.take_out()
        }
    }
};