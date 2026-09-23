# 27200 Data Driven Bioengineering - Transcriptomics

Material for the transcriptomics part of the course. We are still adding and
tidying things up before the class, so expect small changes.

[Course repository](https://github.com/biosustain/dsp_transcriptomics_27200-Data-driven-bioengineering)
· [Course book](https://biosustain.github.io/dsp_transcriptomics_27200-Data-driven-bioengineering/)

## The class

This is week 6 of 27200 Data-driven Bioengineering (DTU Bioengineering, autumn 2026).

| | |
|---|---|
| Date | Thursday 8 October 2026 |
| Time | 8:00 - 12:00 (about 2 hours of lecture, then 2 hours of exercises) |
| Topic | What RNA-seq can and cannot tell you about a cell |
| Format | Group work in groups of 4, a few short quizzes, and a short reflection at the end |
| To hand in | Nothing written this week. You work in class, and can keep your notes for the project |

## What you will learn

By the end of the day you should be able to:

- Follow an RNA-seq experiment from raw reads to a table of counts, and say what the nf-core/rnaseq pipeline does along the way
- Read a count matrix and say what it contains and what it leaves out
- Explain why counts need normalising, and what happens if you skip it
- Do the basic quality checks: PCA, sample correlation, spotting odd samples
- Run a differential expression analysis in DESeq2 and read the output: the design formula, shrinkage, and why we correct p-values
- Use enrichment analysis (ORA and GSEA) to get from a gene list to biology
- Say where transcriptomics stops being informative, and what you would measure next

Quiz topics: count matrices and normalisation, reading a PCA, and the difference
between how much RNA is present and what the cell is actually doing.

## Things worth remembering

- A count matrix is not the cell. RNA levels are not protein levels, and protein levels are not activity.
- The choices you make (normalisation, transformation, thresholds) shape the result as much as the biology does.
- The design formula is your hypothesis. If it is wrong, everything downstream is wrong.
- What you can conclude depends on how the experiment was designed: replicates, confounders, and how many tests you ran.

## Exercises

The practical work is in [`02_notebooks/`](02_notebooks/), as Jupyter notebooks
with an R kernel. They are generated from the scripts in [`01_scripts/`](01_scripts/).

**Pick one dataset** and run its three notebooks in order (01, then 02, then 03).
Each one saves results that the next one reads, so the order matters. If you
finish early, have a look at the other dataset.

| Notebook | What it does |
|---|---|
| *Staphylococcus aureus*, biofilm vs planktonic | |
| [`01_quality_control`](02_notebooks/staphylococcus_aureus/01_quality_control.ipynb) | Quality checks and first look at the data, one strain at a time |
| [`02_differential_expression_analysis`](02_notebooks/staphylococcus_aureus/02_differential_expression_analysis.ipynb) | DESeq2: how cultures change over time, and biofilm vs planktonic |
| [`03_gene_functional`](02_notebooks/staphylococcus_aureus/03_gene_functional.ipynb) | Enrichment with KEGG and GO gene sets |
| *Homo sapiens*, airway smooth muscle with and without dexamethasone | |
| [`01_quality_control`](02_notebooks/homo_sapiens/01_quality_control.ipynb) | Quality checks, taking the donors into account |
| [`02_differential_expression_analysis`](02_notebooks/homo_sapiens/02_differential_expression_analysis.ipynb) | DESeq2 with a paired design (`~ donor + condition`) |
| [`03_gene_functional`](02_notebooks/homo_sapiens/03_gene_functional.ipynb) | Enrichment with g:Profiler and MSigDB |

## Software and data

**Software**

- R 4.3 or newer, with DESeq2, fgsea, mulea, tidyverse and a few others. The script at the bottom installs everything.
- The notebooks in [`02_notebooks/`](02_notebooks/), or the R Markdown scripts they come from in [`01_scripts/`](01_scripts/).
- GitHub Codespaces, if you would rather not install anything (see below).
- nf-core/rnaseq was used to process the raw reads. You do not run it yourself, the output is already here.

**Data** (small versions, so everything runs in class)

- *Staphylococcus aureus*, biofilm vs planktonic over time, strains USA-100 and USA-500: [`data/data-01-Staphylococcus_aureus/`](data/data-01-Staphylococcus_aureus/)
- *Homo sapiens*, airway smooth muscle with and without dexamethasone, four donors: [`data/data-02-Homo_sapiens/`](data/data-02-Homo_sapiens/)
- Gene sets for enrichment (KEGG, GO): [`data/databases/`](data/databases/)

**Other**

- The [course book](https://biosustain.github.io/dsp_transcriptomics_27200-Data-driven-bioengineering/), built from this repository
- Slides in [`slides/`](slides/)
- Example pipeline output and a MultiQC report in [`data/nf-core_rnaseq/`](data/nf-core_rnaseq/) and [`results/`](results/)

## Setting up

There are two ways to do this. The cloud option is easier and is what we will use in class.

### Option 1: in the cloud

Nothing to install.

> **Before you start:** change the machine type to **4-core** when you create the Codespace.

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/biosustain/dsp_transcriptomics_27200-Data-driven-bioengineering)

Once it has started, open `02_notebooks/` and pick a dataset to begin with.

A few things that surprise people the first time:

- Use Chrome, Firefox or Edge. Codespaces is unreliable in Safari.
- When VS Code asks you to select a kernel, choose **R** (under *Jupyter Kernel*). The notebooks are R, not Python.
- You may get a pop-up saying "No text editor active". It is harmless, just close it. Your code still runs.
- Run cells with **Shift+Enter** or the play button, not Ctrl+Enter. The first cell takes a moment while R starts up.

### Option 2: on your own machine

> Stuck? Write to me: Juliana Assis (jasge@dtu.dk)

Run this once before the class to install the packages you need:

```{r, eval=FALSE}
# ============================================================
# DSP Transcriptomics Workshop – Package Installation Script
# ============================================================
# Run this script ONCE before the workshop to install all
# required R packages. Works on macOS, Linux, and Windows.
# Tested with R >= 4.3.
# ============================================================

## ---- 0. Helper: install only if missing --------------------

install_if_missing <- function(pkg, installer, ...) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    message("Installing: ", pkg)
    installer(pkg, ...)
  } else {
    message("Already installed: ", pkg)
  }
}

## ---- 1. CRAN packages --------------------------------------

cran_pkgs <- c(
  "tidyverse",
  "reshape2",
  "RColorBrewer",
  "pheatmap",
  "heatmaply",
  "factoextra",
  "knitr",
  "kableExtra",
  "DT",
  "plotly",
  "ggpubr",
  "gggenes",     # operon plots (S. aureus)
  "gprofiler2",  # ORA via g:Profiler (human)
  "msigdbr",     # MSigDB gene sets for GSEA (human)
  "remotes"      # needed for GitHub installs below
)

for (pkg in cran_pkgs) {
  install_if_missing(pkg, install.packages,
                     dependencies = TRUE)
}

## ---- 2. Bioconductor packages ------------------------------

if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
}
# Pin to the release that matches R 4.4; BiocManager picks the right
# version automatically, but you can force with: BiocManager::install(version = "3.19")

bioc_pkgs <- c(
  "DESeq2",
  "apeglm",       # recommended shrinkage estimator used with DESeq2
  "fgsea",
  "KEGGREST",
  "EnhancedVolcano",
  "org.EcK12.eg.db"  # E. coli gene annotation (E. coli chapters)
)

for (pkg in bioc_pkgs) {
  install_if_missing(pkg, BiocManager::install,
                     update = FALSE, ask = FALSE)
}

## ---- 3. GitHub packages ------------------------------------

# mulea is not on CRAN/Bioconductor yet
if (!requireNamespace("mulea", quietly = TRUE)) {
  message("Installing mulea from GitHub (ELTEbioinformatics/mulea)")
  remotes::install_github("ELTEbioinformatics/mulea")
} else {
  message("Already installed: mulea")
}

## ---- 4. Verification ---------------------------------------

all_pkgs <- c(
  cran_pkgs,
  bioc_pkgs,
  "mulea"
)
# remove helper-only packages from the check list
check_pkgs <- setdiff(all_pkgs, "remotes")

cat("\n========== Installation check ==========\n")
ok  <- character(0)
nok <- character(0)

for (pkg in check_pkgs) {
  if (requireNamespace(pkg, quietly = TRUE)) {
    ok <- c(ok, pkg)
  } else {
    nok <- c(nok, pkg)
  }
}

cat("OK  (", length(ok),  "):", paste(ok,  collapse = ", "), "\n\n")

if (length(nok) > 0) {
  cat("FAILED (", length(nok), "):", paste(nok, collapse = ", "), "\n")
  cat("Please re-run the script or install the above packages manually.\n")
} else {
  cat("All packages installed successfully. You are ready for the workshop!\n")
}
cat("=========================================\n")
```

## See you there

If anything is unclear before the class, just ask.

Juliana Assis, Sebastian Schulz and Alberto Palleja Caro
