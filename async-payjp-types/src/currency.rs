#![allow(missing_docs)]
use serde::Serialize;

#[derive(Copy, Clone, Debug, Eq, Serialize, PartialEq, Hash, Default, miniserde::Deserialize)]
#[cfg_attr(feature = "deserialize", derive(serde::Deserialize))]
pub enum Currency {
    #[serde(rename = "jpy")]
    JPY, // Japanese Yen
    #[serde(rename = "usd")]
    #[default]
    USD, // United States Dollar
}

impl std::fmt::Display for Currency {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", format!("{:?}", self).to_ascii_lowercase())
    }
}

impl std::str::FromStr for Currency {
    type Err = ParseCurrencyError;
    fn from_str(s: &str) -> Result<Self, Self::Err> {
        match s {
            "jpy" => Ok(Currency::JPY),
            "usd" => Ok(Currency::USD),
            _ => Err(ParseCurrencyError(())),
        }
    }
}

#[derive(Debug)]
pub struct ParseCurrencyError(/* private */ ());

impl std::fmt::Display for ParseCurrencyError {
    fn fmt(&self, fmt: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        #[allow(deprecated)]
        fmt.write_str(::std::error::Error::description(self))
    }
}

impl std::error::Error for ParseCurrencyError {
    fn description(&self) -> &str {
        "unknown currency code"
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn debug_currency() {
        assert_eq!(format!("{:?}", Currency::USD), "USD");
    }

    #[test]
    fn display_currency() {
        assert_eq!(format!("{}", Currency::USD), "usd");
    }

    #[test]
    fn serialize_currency() {
        assert_eq!(serde_json::to_string(&Currency::USD).unwrap(), "\"usd\"");
    }

    #[test]
    fn deserialize_currency() {
        assert_eq!(miniserde::json::from_str::<Currency>("\"usd\"").unwrap(), Currency::USD);
    }
}
