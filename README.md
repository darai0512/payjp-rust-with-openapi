# Pay.jp OpenAPI spec & rust binding

![CI](https://github.com/darai0512/payjp-rust/workflows/CI/badge.svg)
[![crates.io](https://img.shields.io/crates/v/payjp-rust.svg)](https://crates.io/crates/payjp-rust)
[![docs.rs](https://docs.rs/payjp-rust/badge.svg)](https://docs.rs/payjp-rust)

** WIP **

- [Openapi v3.1](./openapi/docs)はビルドできる状態になっております
  - 内容の最終fixはまだです
  - ディレクトリ構成・ビルド方法も試行錯誤中です
  - $refなどのIDE補完が.jsonnetだと(工夫しないと)効かないため、基本は.jsonでいきつつ、Generics表現
- openapiからrustのSDKの一部を生成するところは、ライブラリのopenapi v3.1対応ができておらず自前実装中で、今しばらくかかります
  - ただしopenapi v2からrust sdkを生成可能です(非同期対応などはしてませんが)。[3.1->2.0の変換は可能](https://stackoverflow.com/questions/56637299/convert-openapi-3-0-to-swagger-2-0)です。
  - openapi v2: https://www.reddit.com/r/rust/comments/x9zkr7/recommendations_for_rust_openapi_client/
  - [ ] AllOfのobject構造merge
  - [ ] top level listの許可
  - [ ] etc...
- 最終的なSDK（tokioなどの非同期機能提供など）も上記が完了してからとなります
  - [ ] generated/async-payjp-shared

based on [arlyon/async-stripe](https://github.com/arlyon/async-stripe) by Alexander Lyon

## memo

openapi分割
- openapitools/openapi-generator-cli
  - dockerは動くがlocalで導入するのが大変な場合がある
  - 表現力が足りない。 ex, paths以下に$refのmulti key mergeができない
- jsonnet

expandable: 普段はnullstringなIDを返すが、expand=...を指定するとobjectを返す

- jsonnet時にファイル参照を消したい. list refだけに(itemあるから無理？)

top level listはpanicされる on parse_schema_as_rust_object()

`obj` is borrowed here
|                 returns a value referencing data owned by the current function
自己参照はエラー
https://qiita.com/garkimasera/items/272dc029281b8639aff2

## Example

This asynchronous example uses `Tokio` to create
a [Payjp Customer](https://pay.jp/docs/api#customers). Your `Cargo.toml` could
look like this:

```toml
tokio = { version = "1", features = ["full"] }
payjp = { version = "0.28", features = ["runtime-tokio-hyper"] }
payjp_core = { version = "0.28", features = ["customer"] }
```

And then the code:

```rust
#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let secret_key = "sk_xxx";
    let client = payjp::Client::new(secret_key);
    let customer = payjp_core::customer::CreateCustomer {
        email: Some("test@async-payjp.com"),
        ..Default::default()
    }
        .send(&client)
        .await?;

    println!("created a customer at https://pay.jp/d/customers/{}", customer.id);
    Ok(())
}
```

A full list of examples can be found in the [examples](/examples).

## Relevant Crates

### Client

The main entry point is the `payjp-rust` crate which provides a client for making Payjp
API requests.
`payjp-rust` is compatible with the [`async-std`](https://github.com/async-rs/async-std)
and [`tokio`](https://github.com/tokio-rs/tokio) runtimes and the `native-tls`
and `rustls` backends. When adding the dependency, you must select a runtime feature.

#### Installation

```toml
[dependencies]
payjp = { version = "0.31", features = ["runtime-tokio-hyper"] }
```

#### Feature Flags

supports the following features combining runtime and TLS choices:

- `runtime-tokio-hyper`
- `runtime-tokio-hyper-rustls`
- `runtime-tokio-hyper-rustls-webpki`
- `runtime-blocking`
- `runtime-blocking-rustls`
- `runtime-blocking-rustls-webpki`
- `runtime-async-std-surf`