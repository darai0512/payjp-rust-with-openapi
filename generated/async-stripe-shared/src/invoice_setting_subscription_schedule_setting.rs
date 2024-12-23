#[derive(Clone, Debug)]
#[cfg_attr(feature = "serialize", derive(serde::Serialize))]
#[cfg_attr(feature = "deserialize", derive(serde::Deserialize))]
pub struct InvoiceSettingSubscriptionScheduleSetting {
    /// The account tax IDs associated with the subscription schedule.
    /// Will be set on invoices generated by the subscription schedule.
    pub account_tax_ids: Option<Vec<stripe_types::Expandable<stripe_shared::TaxId>>>,
    /// Number of days within which a customer must pay invoices generated by this subscription schedule.
    /// This value will be `null` for subscription schedules where `billing=charge_automatically`.
    pub days_until_due: Option<u32>,
    pub issuer: stripe_shared::ConnectAccountReference,
}
#[doc(hidden)]
pub struct InvoiceSettingSubscriptionScheduleSettingBuilder {
    account_tax_ids: Option<Option<Vec<stripe_types::Expandable<stripe_shared::TaxId>>>>,
    days_until_due: Option<Option<u32>>,
    issuer: Option<stripe_shared::ConnectAccountReference>,
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

    impl Deserialize for InvoiceSettingSubscriptionScheduleSetting {
        fn begin(out: &mut Option<Self>) -> &mut dyn Visitor {
            Place::new(out)
        }
    }

    struct Builder<'a> {
        out: &'a mut Option<InvoiceSettingSubscriptionScheduleSetting>,
        builder: InvoiceSettingSubscriptionScheduleSettingBuilder,
    }

    impl Visitor for Place<InvoiceSettingSubscriptionScheduleSetting> {
        fn map(&mut self) -> Result<Box<dyn Map + '_>> {
            Ok(Box::new(Builder {
                out: &mut self.out,
                builder: InvoiceSettingSubscriptionScheduleSettingBuilder::deser_default(),
            }))
        }
    }

    impl MapBuilder for InvoiceSettingSubscriptionScheduleSettingBuilder {
        type Out = InvoiceSettingSubscriptionScheduleSetting;
        fn key(&mut self, k: &str) -> Result<&mut dyn Visitor> {
            Ok(match k {
                "account_tax_ids" => Deserialize::begin(&mut self.account_tax_ids),
                "days_until_due" => Deserialize::begin(&mut self.days_until_due),
                "issuer" => Deserialize::begin(&mut self.issuer),

                _ => <dyn Visitor>::ignore(),
            })
        }

        fn deser_default() -> Self {
            Self {
                account_tax_ids: Deserialize::default(),
                days_until_due: Deserialize::default(),
                issuer: Deserialize::default(),
            }
        }

        fn take_out(&mut self) -> Option<Self::Out> {
            let (Some(account_tax_ids), Some(days_until_due), Some(issuer)) =
                (self.account_tax_ids.take(), self.days_until_due, self.issuer.take())
            else {
                return None;
            };
            Some(Self::Out { account_tax_ids, days_until_due, issuer })
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

    impl ObjectDeser for InvoiceSettingSubscriptionScheduleSetting {
        type Builder = InvoiceSettingSubscriptionScheduleSettingBuilder;
    }

    impl FromValueOpt for InvoiceSettingSubscriptionScheduleSetting {
        fn from_value(v: Value) -> Option<Self> {
            let Value::Object(obj) = v else {
                return None;
            };
            let mut b = InvoiceSettingSubscriptionScheduleSettingBuilder::deser_default();
            for (k, v) in obj {
                match k.as_str() {
                    "account_tax_ids" => b.account_tax_ids = FromValueOpt::from_value(v),
                    "days_until_due" => b.days_until_due = FromValueOpt::from_value(v),
                    "issuer" => b.issuer = FromValueOpt::from_value(v),

                    _ => {}
                }
            }
            b.take_out()
        }
    }
};
