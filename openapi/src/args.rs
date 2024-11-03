use std::fmt::Debug;
use clap::Parser;
use lazy_static::lazy_static;

/// todo openapi.jsonのバージョニング？日付で良さそうだがどうするか
#[derive(Debug, Parser)]
pub struct Commands {
    #[arg(default_value = "openapi3.json")]
    pub path: String,

    /// Output directory for generated code, defaults to `out`
    #[arg(long, default_value = "out")]
    pub out: String,
    /// Instead of writing files, generate a graph of dependencies in `graphviz` `DOT` format. Writes
    /// to `graph.txt`
    #[arg(long)]
    pub graph: bool,
    /// The URL to target for the docs.
    #[arg(long, default_value = "https://pay.jp/docs/api")]
    pub api_docs_url: String,
    /// Skip the step of copying the generated code from `out` to `generated/`.
    #[arg(long)]
    pub dry_run: bool,
}

lazy_static! {
    // グローバルで使える静的なHashMapを定義
    pub static ref args: Commands = {
        Commands::parse()
    };
}