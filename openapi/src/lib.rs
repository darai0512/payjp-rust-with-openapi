pub mod codegen;
mod components;
mod crate_inference;
mod crate_table;
pub mod crates;
mod deduplication;
mod graph;
mod object_writing;
mod overrides;
mod printable;
mod requests;
mod rust_object;
mod rust_type;
pub mod spec;
mod spec_inference;
mod resource_object;
mod templates;
mod types;
pub mod utils;
mod visitor;
// pub mod args;
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
    pub static ref args: Commands = {
        Commands::parse()
    };
}

pub const PAYJP_TYPES: &str = "payjp_types";
