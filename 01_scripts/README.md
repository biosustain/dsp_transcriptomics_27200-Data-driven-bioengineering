# Analysis scripts — 27200 Transcriptomics week

R Markdown source scripts for the two main datasets of the transcriptomics session.
They are rendered into the course book (see `project/_bookdown.yml`) and converted to
Jupyter notebooks in `02_notebooks/` (regenerate with `python util/rmd_to_ipynb.py`).

All scripts resolve paths from the repo root via `git rev-parse --show-toplevel`, so they
run unchanged on a local machine or in a Codespace.

## Datasets

| Dataset | Source | Scripts |
|---|---|---|
| *Staphylococcus aureus* — biofilm vs planktonic over time, strains USA-100/USA-500 | Tomlinson *et al.* 2021, GEO GSE163153 / PRJNA685119 | `*_saureus.Rmd` |
| *Homo sapiens* — airway smooth muscle ± dexamethasone, paired donor design | Himes *et al.* 2014, GEO GSE52778 / PRJNA229998 | unsuffixed `.Rmd` |

Each dataset has three scripts, run in order — every step saves results the next one loads:

1. `01_quality_control[_saureus].Rmd` — QC and exploratory analysis (PCA, correlation, outliers)
2. `02_differential_expression_analysis[_saureus].Rmd` — DESeq2
3. `03_gene_functional[_saureus].Rmd` — functional enrichment (ORA & GSEA)

## Helper and provenance files

| File | Purpose |
|---|---|
| `00_nfcore_rnaseq_processing.sh` | Provenance: the nf-core/rnaseq command used to process the **human** dataset (outputs already committed — no need to run) |
| `02b_prepare_genesets_saureus.Rmd` | Builds the KEGG/GO gene-set `.rds` caches in `data/databases/` used by the S. aureus functional script (cached outputs committed) |
| `render_all_strains.R` | Renders the parameterized S. aureus scripts for **both** strains (USA-100 and USA-500); HTML lands next to the scripts |
| `gsea_collection_comparison.Rmd` | One-off sensitivity check: human GSEA with filtered vs unfiltered gene-set collections |
| `params_degs.json` | Parameters for the optional nf-core/differentialabundance run (human dataset) |
| `run_differentialabundance.sh` | Optional comparison track: nf-core/differentialabundance with the simple `~ condition` model (the paired `~ donor + condition` DESeq2 analysis in script 02 is the primary analysis) |
| `custom.config` | Nextflow resource limits (CPUs/memory) for the in-class pipeline run — **to be added** |

## Scientific decisions baked into the scripts

**S. aureus**

- Strain-specific reference genomes: **USA-100** → N315 (`GCF_000009645.1`); **USA-500** →
  USA300_FPR3757 (`GCF_000013465.1`), its closest finished relative, as in the paper.
- Scripts 02/03 are parameterized by strain (`params$strain`) with USA-100 as the
  interactive/book default; use `render_all_strains.R` for both strains.
- Enrichment via KEGGREST/mulea with locus-tag → symbol maps cached in `data/databases/`.

**Human**

- Contrast: dexamethasone vs untreated, n = 4 donors per group; albuterol arms excluded.
- Design: `~ donor + condition` (paired) is the primary model; script 02 also runs plain
  `~ condition` side by side for teaching.
- Enrichment: g:Profiler (`gprofiler2::gost`, live API — needs internet) for ORA;
  `fgsea` + MSigDB Hallmark (`msigdbr`) for GSEA.
- Gene IDs: the RefSeq GRCh37 GTF yields gene **symbols** in both `gene_id` and
  `gene_name`, so no ID conversion is needed.
- Counts: Salmon estimates are fractional; script 01 rounds to integers before DESeq2.

## Outputs

- S. aureus → `results/usa100/`, `results/usa500/`, `results/cross_strain/`
- Human → `results/human/`
- E. coli (practice chapters in `project/`) → `results/` root and `results/rds/`

All outputs are committed so the book builds from a fresh clone without re-running
anything upstream.
