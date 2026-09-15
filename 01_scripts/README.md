# DSP Transcriptomics — Human ASM (dexamethasone) workshop

Second dataset for the existing repo
`dsp_transcriptomics_27200-Data-driven-bioengineering`
(**Dataset 2: Homo sapiens** — Himes *et al.*, 2014, airway smooth muscle + dexamethasone;
GEO GSE52778 / PRJNA229998).

Adapted from the *E. coli* MG1655 saccharin scripts. The *E. coli* scripts and outputs are
untouched; everything human is namespaced so it lives alongside them in the same repo.

## Where things live in the repo

| What | Path (relative to repo root) |
|---|---|
| nf-core star_salmon output (already produced) | `data/data-02-Homo_sapiens/hasapiens/star_salmon/` |
| Human sample metadata (QC reads this) | `data/data-02-Homo_sapiens/metadata/metadata.tsv` |
| differentialabundance samplesheet + contrast | `data/data-02-Homo_sapiens/metadata/` |
| RefSeq GRCh37 GTF | `data/data-02-Homo_sapiens/genome_files/GCF_000001405.13_GRCh37_genomic.gtf.gz` |
| All human outputs | `results/human/` (rds, plots, DE + enrichment TSVs) |

The three `.Rmd` scripts use `git_root` so they resolve these paths on any machine
(local Mac or Codespace).

## Scientific decisions baked into these scripts

- **Contrast:** dexamethasone (treatment) vs untreated (control), n = 4 per group. The
  albuterol and albuterol+dexamethasone arms are **excluded** (per the workshop plan / Lasse).
- **Design:** `~ donor + condition` (paired) is the primary model — each donor contributes
  one treated and one untreated sample. Script 02 also runs the simple `~ condition` model
  side by side so the effect of accounting for donor is visible for teaching.
- **Enrichment:** g:Profiler (`gprofiler2::gost`) for ORA (native human support), `fgsea` +
  MSigDB Hallmark (`msigdbr`) for GSEA. This replaces the *E. coli* KEGGREST/mulea/locus-tag
  machinery, which existed only because g:Profiler does not support *E. coli*.
- **Gene IDs:** the pipeline used a **RefSeq** GTF (`GCF_000001405.13_GRCh37`) with
  `gtf_extra_attributes = gene_name`, so both `gene_id` and `gene_name` in the RDS are
  gene **symbols** (e.g. `A1BG`, `A2M`), not ENSEMBL IDs. Symbols are what g:Profiler and
  MSigDB expect, so **no ID conversion is needed**. Script 01 prints the actual ID types at
  runtime so you can confirm this on your data.
- **Counts:** Salmon estimates are fractional; script 01 **rounds** to integers before DESeq2
  (not `as.integer` truncation).

## What you MUST verify before running

1. **RDS location.** Script 01 reads
   `data/data-02-Homo_sapiens/hasapiens/star_salmon/salmon.merged.gene.SummarizedExperiment.rds`.
   Confirm that file is committed / present at that path.

2. **RDS assay + rowData columns.** Script 01 uses `assayNames()[1]` and
   `rowData()$gene_name` / `$gene_id`, and prints them at runtime. If your RDS names differ,
   adjust there.

## Sample metadata

`data/data-02-Homo_sapiens/metadata/metadata.tsv` was generated directly from your count-matrix
column names and cross-checked against your nf-core samplesheet (8 dex/untreated samples,
4 donors). No values were invented.

## Files

| File | Change from E. coli version |
|---|---|
| `01_scripts/00_nfcore_rnaseq_processing.sh` | Provenance only (run already done); real repo + Azure paths recorded |
| `01_scripts/01_quality_control.Rmd` | star_salmon RDS path, donor factor, round-to-int, paired design, symbols (no locus-tag map), runtime ID check, `results/human/` outputs |
| `01_scripts/02_differential_expression_analysis.Rmd` | `~ donor + condition` primary + `~ condition` teaching comparison; `results/human/` |
| `01_scripts/03_gene_functional.Rmd` | g:Profiler ORA + fgsea/MSigDB GSEA (KEGGREST/mulea removed); `results/human/` |
| `01_scripts/params_degs.json` | Real repo paths, RefSeq GTF, group size 4, parametric fit, gprofiler2 on |
| `01_scripts/run_differentialabundance.sh` | outdir -> `results/human/differentialabundance` |
| `01_scripts/custom.config` | Unchanged (environment resource limits, not organism-specific) |
| `data/data-02-Homo_sapiens/metadata/metadata.tsv` | New — derived from your sample names |

## Not touched / not invented

- No PC1 percentages, gene counts, or specific pathway hits were written into the prose —
  the *E. coli* scripts had hardcoded numbers (e.g. "PC1 = 85.4%", C3 outlier narrative);
  those are removed rather than replaced with guesses. The rendered output will fill them in.
- The Python notebook was left out, as requested.
- `assets/`, bookdown/publishing config, and the `docs/` site were not migrated — say the
  word and I'll set those up too.
