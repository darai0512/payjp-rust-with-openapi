use payjp_client_core::{StripeClient, StripeBlockingClient, StripeRequest, RequestBuilder, StripeMethod};

    /// 指定されたIDの集計区間（Termオブジェクト）を取得します。
#[derive(Clone,Debug,)]#[derive(serde::Serialize)]
pub struct RetrieveTerm {
 term: String,

}
impl RetrieveTerm {
    /// Construct a new `RetrieveTerm`.
pub fn new(term:impl Into<String>) -> Self {
    Self {
        term: term.into(),
    }
}

}
    impl RetrieveTerm {
    /// Send the request and return the deserialized response.
    pub async fn send<C: StripeClient>(&self, client: &C) -> Result<<Self as StripeRequest>::Output, C::Err> {
        self.customize().send(client).await
    }

    /// Send the request and return the deserialized response, blocking until completion.
    pub fn send_blocking<C: StripeBlockingClient>(&self, client: &C) -> Result<<Self as StripeRequest>::Output, C::Err> {
        self.customize().send_blocking(client)
    }

    
}

impl StripeRequest for RetrieveTerm {
    type Output = pay::Term;

    fn build(&self) -> RequestBuilder {
    let term = &self.term;
RequestBuilder::new(StripeMethod::Get, format!("/terms/{term}"))
}

}
#[derive(Copy,Clone,Debug,)]#[derive(serde::Serialize)]
 struct ListTermBuilder {
#[serde(skip_serializing_if = "Option::is_none")]
 limit: Option<i64>,
#[serde(skip_serializing_if = "Option::is_none")]
 offset: Option<i64>,
#[serde(skip_serializing_if = "Option::is_none")]
 since_start_at: Option<i64>,
#[serde(skip_serializing_if = "Option::is_none")]
 until_start_at: Option<i64>,

}
impl ListTermBuilder {
     fn new() -> Self {
    Self {
        limit: None,offset: None,since_start_at: None,until_start_at: None,
    }
}

}
        /// 集計区間（Termオブジェクト）のリストを取得します。
#[derive(Clone,Debug,)]#[derive(serde::Serialize)]
pub struct ListTerm {
 inner: ListTermBuilder,

}
impl ListTerm {
    /// Construct a new `ListTerm`.
pub fn new() -> Self {
    Self {
        inner: ListTermBuilder::new()
    }
}
    /// 取得するデータ数の最大値（1〜100）。デフォルトは10。
pub fn limit(mut self, limit: impl Into<i64>) -> Self {
    self.inner.limit = Some(limit.into());
    self
}
    /// データ取得の開始位置。デフォルトは0。
pub fn offset(mut self, offset: impl Into<i64>) -> Self {
    self.inner.offset = Some(offset.into());
    self
}
    /// start_atが指定したタイムスタンプ以降のオブジェクトを取得
pub fn since_start_at(mut self, since_start_at: impl Into<i64>) -> Self {
    self.inner.since_start_at = Some(since_start_at.into());
    self
}
    /// start_atが指定したタイムスタンプ以前のオブジェクトを取得
pub fn until_start_at(mut self, until_start_at: impl Into<i64>) -> Self {
    self.inner.until_start_at = Some(until_start_at.into());
    self
}

}
    impl Default for ListTerm {
    fn default() -> Self {
        Self::new()
    }
}impl ListTerm {
    /// Send the request and return the deserialized response.
    pub async fn send<C: StripeClient>(&self, client: &C) -> Result<<Self as StripeRequest>::Output, C::Err> {
        self.customize().send(client).await
    }

    /// Send the request and return the deserialized response, blocking until completion.
    pub fn send_blocking<C: StripeBlockingClient>(&self, client: &C) -> Result<<Self as StripeRequest>::Output, C::Err> {
        self.customize().send_blocking(client)
    }

    pub fn paginate(&self) -> payjp_client_core::ListPaginator<stripe_types::List<pay::Term>> {
    
    payjp_client_core::ListPaginator::new_list("/terms", &self.inner)
}

}

impl StripeRequest for ListTerm {
    type Output = stripe_types::List<pay::Term>;

    fn build(&self) -> RequestBuilder {
    RequestBuilder::new(StripeMethod::Get, "/terms").query(&self.inner)
}

}

