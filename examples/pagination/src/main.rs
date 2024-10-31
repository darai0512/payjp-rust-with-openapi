// SECRET_KEY=sk_test_09l3shTSTKHYCzzZZsiLl2vA
#[tokio::main]
async fn main() -> Result<(), payjp::StripeError> {
    use futures_util::TryStreamExt;
    use payjp::Client;
    use payjp_core::customer::ListCustomer;
    use pay::term::ListTerm;

    let secret_key = std::env::var("SECRET_KEY").expect("Missing SECRET_KEY in env");
    let client = Client::new(secret_key);
    let paginator = ListCustomer::new().paginate();
    println!("GOT");
    let paginator2 = ListTerm::new().paginate();
    println!("GOT2");
    let mut stream = paginator.stream(&client);

    // take a value out from the stream
    if let Some(val) = stream.try_next().await? {
        println!("GOT = {:?}", val);
    }
    if let Some(val) = stream.try_next().await? {
        println!("GOT = {:?}", val);
    }
    // 3つめないのに取得しようとすると異常終了 > pay

    // alternatively, you can use stream combinators
    let _ = stream.try_collect::<Vec<_>>().await?;

    let mut stream2 = paginator2.stream(&client);
    if let Some(val) = stream2.try_next().await? {
        println!("GOT = {:?}", val);
    }
    /*
    let customer = CreateCustomer::new()
        .name("Alexander Lyon")
        .email("test@async-payjp.com")
        .description("A fake customer that is used to illustrate the examples in async-payjp.")
        .metadata([(String::from("async-payjp"), String::from("true"))])
        .send(client)
        .await?;

     */

    Ok(())
}
