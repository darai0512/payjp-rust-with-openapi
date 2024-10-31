//! Customer
//! ========
//!
//! Reference: <https://pay.jp/docs/api#customers>
//!
//! This example shows how to create and list customers.

use futures_util::StreamExt;
use futures_util::TryStreamExt;
use payjp::{Client, StripeError};
use stripe_core::customer::{CreateCustomer, ListCustomer};

pub async fn run_customer_example(client: &Client) -> Result<(), StripeError> {
    let customer = CreateCustomer::new()
        .name("Alexander Lyon")
        .email("test@async-payjp.com")
        .description("A fake customer that is used to illustrate the examples in async-payjp.")
        .metadata([(String::from("async-payjp"), String::from("true"))])
        .send(client)
        .await?;

    println!("created a customer at https://dashboard.stripe.com/test/customers/{}", customer.id);

    let customer = CreateCustomer::new()
        .name("Someone Else")
        .email("test@async-payjp.com")
        .description("A fake customer that is used to illustrate the examples in async-payjp.")
        .metadata([(String::from("async-payjp"), String::from("true"))])
        .send(client)
        .await?;

    println!("created a customer at https://dashboard.stripe.com/test/customers/{}", customer.id);

    let mut stream = ListCustomer::new().paginate().stream(client);

    // get the next customer
    let _next = stream.next().await.unwrap();

    // or collect them
    let customers = stream.try_collect::<Vec<_>>().await.unwrap();

    println!("fetched {} customers: {:?}", customers.len(), customers);
    Ok(())
}

/* subscriptions
use stripe::{Client, StripeError};
use stripe_billing::subscription::{CreateSubscription, CreateSubscriptionItems};
use stripe_core::customer::CreateCustomer;
use stripe_payment::payment_method::{
    AttachPaymentMethod, CreatePaymentMethod, CreatePaymentMethodCard,
    CreatePaymentMethodCardDetailsParams, CreatePaymentMethodType,
};
use stripe_product::price::{CreatePrice, CreatePriceRecurring, CreatePriceRecurringInterval};
use stripe_product::product::CreateProduct;
use stripe_types::{Currency, Expandable};

pub async fn run_subscriptions_example(client: &Client) -> Result<(), StripeError> {
    let customer = CreateCustomer::new()
        .name("Alexander Lyon")
        .email("test@async-payjp.com")
        .description("A fake customer that is used to illustrate the examples in async-payjp.")
        .metadata([(String::from("async-payjp"), String::from("true"))])
        .send(client)
        .await?;

    println!("created a customer at https://dashboard.stripe.com/test/customers/{}", customer.id);
    let payment_method = CreatePaymentMethod::new()
        .type_(CreatePaymentMethodType::Card)
        .card(CreatePaymentMethodCard::CardDetailsParams(CreatePaymentMethodCardDetailsParams {
            number: String::from("4000008260000000"), // UK visa
            exp_year: 2025,
            exp_month: 1,
            cvc: Some(String::from("123")),
            networks: None,
        }))
        .send(client)
        .await?;
    AttachPaymentMethod::new(payment_method.id.clone(), &customer.id).send(client).await?;

    println!(
        "created a payment method with id {} and attached it to {}",
        payment_method.id,
        customer.name.unwrap()
    );

    // create a new example product
    let product = CreateProduct::new("Monthly T-Shirt Subscription")
        .metadata([(String::from("async-payjp"), String::from("true"))])
        .send(client)
        .await?;

    // and add a price for it in USD
    let price = CreatePrice::new(Currency::USD)
        .product(&product.id)
        .metadata([(String::from("async-payjp"), String::from("true"))])
        .unit_amount(1000)
        .recurring(CreatePriceRecurring::new(CreatePriceRecurringInterval::Month))
        .expand([String::from("product")])
        .send(client)
        .await?;

    println!(
        "created a product {:?} at price {} {}",
        product.name,
        price.unit_amount.unwrap() / 100,
        price.currency,
    );

    let subscription = CreateSubscription::new(&customer.id)
        .items(vec![CreateSubscriptionItems {
            price: Some(price.id.to_string()),
            ..Default::default()
        }])
        .default_payment_method(&payment_method.id)
        .expand([
            String::from("items"),
            String::from("items.data.price.product"),
            String::from("schedule"),
        ])
        .send(client)
        .await?;

    println!(
        "created a {} subscription for {:?} for {} {} per {} at https://dashboard.stripe.com/test/subscriptions/{}",
        subscription.status,
        match &subscription.items.data[0].price.product {
            Expandable::Object(p) => &p.name,
            _ => panic!("product not found"),
        },
        subscription.items.data[0].price.unit_amount.unwrap() / 100,
        subscription.items.data[0].price.currency,
        subscription.items.data[0].price.recurring.as_ref().unwrap().interval,
        subscription.id
    );
    Ok(())
}
*/