use payjp_client_core::{StripeClient, StripeBlockingClient, StripeRequest, RequestBuilder, StripeMethod};

    /// Info for a specific token
#[derive(Clone,Debug,)]#[derive(serde::Serialize)]
pub struct RetrieveToken {
 token: String,

}
impl RetrieveToken {
    /// Construct a new `RetrieveToken`.
pub fn new(token:impl Into<String>) -> Self {
    Self {
        token: token.into(),
    }
}

}
    impl RetrieveToken {
    /// Send the request and return the deserialized response.
    pub async fn send<C: StripeClient>(&self, client: &C) -> Result<<Self as StripeRequest>::Output, C::Err> {
        self.customize().send(client).await
    }

    /// Send the request and return the deserialized response, blocking until completion.
    pub fn send_blocking<C: StripeBlockingClient>(&self, client: &C) -> Result<<Self as StripeRequest>::Output, C::Err> {
        self.customize().send_blocking(client)
    }

    
}

impl StripeRequest for RetrieveToken {
    type Output = stripe_core::Token;

    fn build(&self) -> RequestBuilder {
    let token = &self.token;
RequestBuilder::new(StripeMethod::Get, format!("/tokens/{token}"))
}

}
#[derive(Clone,Debug,)]#[derive(serde::Serialize)]
 struct CreateTokenBuilder {
#[serde(rename = "card[number]")]
 card_number: String,
#[serde(rename = "card[exp_month]")]
 card_exp_month: String,
#[serde(rename = "card[exp_year]")]
 card_exp_year: String,
#[serde(rename = "card[cvc]")]
#[serde(skip_serializing_if = "Option::is_none")]
 card_cvc: Option<String>,
#[serde(rename = "card[name]")]
#[serde(skip_serializing_if = "Option::is_none")]
 card_name: Option<String>,

}
impl CreateTokenBuilder {
     fn new(card_number: impl Into<String>,card_exp_month: impl Into<String>,card_exp_year: impl Into<String>,) -> Self {
    Self {
        card_number: card_number.into(),card_exp_month: card_exp_month.into(),card_exp_year: card_exp_year.into(),card_cvc: None,card_name: None,
    }
}

}
        /// Create new token
#[derive(Clone,Debug,)]#[derive(serde::Serialize)]
pub struct CreateToken {
 inner: CreateTokenBuilder,

}
impl CreateToken {
    /// Construct a new `CreateToken`.
pub fn new(card_number:impl Into<String>,card_exp_month:impl Into<String>,card_exp_year:impl Into<String>) -> Self {
    Self {
        inner: CreateTokenBuilder::new(card_number.into(),card_exp_month.into(),card_exp_year.into(),)
    }
}
pub fn card_cvc(mut self, card_cvc: impl Into<String>) -> Self {
    self.inner.card_cvc = Some(card_cvc.into());
    self
}
pub fn card_name(mut self, card_name: impl Into<String>) -> Self {
    self.inner.card_name = Some(card_name.into());
    self
}

}
    impl CreateToken {
    /// Send the request and return the deserialized response.
    pub async fn send<C: StripeClient>(&self, client: &C) -> Result<<Self as StripeRequest>::Output, C::Err> {
        self.customize().send(client).await
    }

    /// Send the request and return the deserialized response, blocking until completion.
    pub fn send_blocking<C: StripeBlockingClient>(&self, client: &C) -> Result<<Self as StripeRequest>::Output, C::Err> {
        self.customize().send_blocking(client)
    }

    
}

impl StripeRequest for CreateToken {
    type Output = stripe_core::Token;

    fn build(&self) -> RequestBuilder {
    RequestBuilder::new(StripeMethod::Post, "/tokens").form(&self.inner)
}

}

