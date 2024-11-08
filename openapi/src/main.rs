use std::fs;
use std::fs::File;
use std::path::Path;

use anyhow::{bail, Context, Result};
use petgraph::dot::{Config, Dot};
use openapi_codegen::codegen::CodeGen;
use openapi_codegen::crates::ALL_CRATES;
use openapi_codegen::spec::Spec;
use openapi_codegen::utils::write_to_file;
use openapi_codegen::args;
use tracing::info;


fn main() -> Result<()> {
    tracing_subscriber::fmt::init();
    let in_path = args.path.clone();
    let out_path = Path::new(&args.out);
    if out_path.exists() {
        fs::remove_dir_all(out_path).context("could not remove out folder")?;
    }
    fs::create_dir_all(out_path).context("could not create out folder")?;

    info!("generating code for {in_path} to {}", out_path.display());

    let raw = File::open(in_path).context("failed to load the specfile. does it exist?")?;
    let spec = Spec::new(serde_json::from_reader(&raw).context("failed to read json from specfile")?);
    info!("Finished parsing spec");

    let codegen = CodeGen::new(spec)?;

    if args.graph {
        let comp_graph = codegen.components.gen_component_dep_graph();
        let graph_txt = format!("{:?}", Dot::with_config(&comp_graph, &[Config::EdgeNoLabel]));
        write_to_file(graph_txt, "graphs/components_graph.txt")?;

        let crate_graph = codegen.components.gen_crate_dep_graph();
        let graph_txt = format!("{:?}", Dot::with_config(&crate_graph, &[Config::EdgeNoLabel]));
        write_to_file(graph_txt, "graphs/crate_graph.txt")?;
        return Ok(());
    }

    codegen.write_files()?;

    let mut fmt_cmd = std::process::Command::new("cargo");
    fmt_cmd.arg("+nightly").arg("fmt").arg("--");
    for krate in &*ALL_CRATES {
        fmt_cmd.arg(format!("{}/{}/src/mod.rs", out_path.display(), krate.generated_out_path()));
    }
    fmt_cmd.arg(format!("{}/tests/mod.rs", out_path.display()));
    info!("out=: {}" ,out_path.display());

    if !args.dry_run {
        info!("Formatting generated files");
        let out = fmt_cmd.output()?;
        if !out.status.success() {
            bail!("Rustfmt failed with outputs {:?}", out);
        }

        info!("Copying generated files");
        run_rsync(&format!("{}/crates/", out_path.display()), "../generated/")?;
        run_rsync(&format!("{}/tests/", out_path.display()), "../tests/tests/it/generated/")?;

        std::process::Command::new("cp")
            .arg(format!("{}/crate_info.md", out_path.display()))
            .arg("../crate_info.md")
            .output()?;
    }
    Ok(())
}
// --delete-during so that generated files don't stick around when not generated anymore
fn run_rsync(src: &str, dest: &str) -> Result<()> {
    let out = std::process::Command::new("rsync")
        .arg("-a")
        .arg("--delete-during")
        .arg(src)
        .arg(dest)
        .output()?;

    if !out.status.success() {
        bail!("rsync failed with outputs {:?}", out);
    }
    Ok(())
}
