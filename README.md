# 🧬 27200 Data Driven Bioengineering - Transcriptomics

> **Course materials are live — and we're still polishing a few things for this year!**

---

## 📚 Course Materials

All materials, resources, and a **draft agenda** for the day are available in this repository. We are actively updating and revising content ahead of the course.

👉 **[View the full repository →](https://github.com/biosustain/dsp_transcriptomics_27200-Data-driven-bioengineering)**

---

## 📋 Course Details

This session is the **Transcriptomics week (Week 6)** of **27200 Data-driven Bioengineering** (DTU Bioengineering, Fall 2026) — a 13-week course building systems-level, data-driven reasoning across omics technologies, modeling, and AI.

| | |
|---|---|
| 📅 **Lecture date** | Thursday, 08 October 2026 |
| 🕘 **Duration** | 10:00 – 14:00 (≈2 h lecture + ≈2 h guided exercises) |
| 🧭 **Theme** | Transcript abundance as a dynamic — but incomplete — regulatory readout |
| 👥 **Format** | Active learning in fixed groups of 4; 2–3 short in-class quizzes; end-of-session "key insight + muddy point" reflection |
| 📝 **Deliverable** | No formal written deliverable this week — in-class outputs and quizzes; optional project-relevant notes |

---

## 🎯 Main Concepts & Learning Objectives

By the end of this session, students will be able to:

- Describe the **RNA-seq workflow** from raw reads to a count matrix, including processing with the **nf-core/rnaseq** pipeline
- Interpret **count matrices** and related data structures — what they contain and what they omit (LO4)
- Apply and compare **normalization** strategies, and revisit **batch effects** and experimental design from the statistics week
- Perform **quality control and exploratory analysis**: PCA, sample correlation, outlier detection
- Run and interpret **differential expression analysis** with DESeq2, including design formulas, shrinkage, and multiple testing (LO5)
- Gain biological insight through **functional enrichment** — ORA and GSEA with KEGG, GO, and MSigDB gene sets
- Explain **what transcriptomics reflects and what it misses** — how the technology constrains biological interpretation (LO8)

**In-class quiz themes:** count matrices & normalization · PCA interpretation · transcript abundance versus activity

---

## 🔑 Key Takeaways

Tied to the course's recurring backbone principles:

- **Measurement defines reality** — a count matrix is a filtered snapshot: transcript abundance is not protein abundance, and not activity
- **Representation shapes understanding** — expression becomes a matrix; normalization and transformation choices shape every downstream conclusion
- **Models are controlled simplifications** — the DESeq2 design formula *is* your hypothesis; assumptions and shrinkage determine what you can claim
- Inference is bounded by **experimental design**: replication, confounders, and multiple testing (ties back to Week 4)

---

## 🧪 Exercises & Interactive Activities

The hands-on work happens in **[`02_notebooks/`](02_notebooks/)** — Jupyter notebooks (R kernel) generated from the scripts in `01_scripts/`. **Pick ONE dataset** and run its notebooks in order, **01 → 02 → 03**; every step saves results that the next one loads. If your group finishes early, start on the other dataset.

| Notebook | Description |
|---|---|
| **_Staphylococcus aureus_ — biofilm vs planktonic** | |
| [`01_quality_control`](02_notebooks/staphylococcus_aureus/01_quality_control.ipynb) | QC and exploratory analysis across lifestyles and time points, one strain at a time |
| [`02_differential_expression_analysis`](02_notebooks/staphylococcus_aureus/02_differential_expression_analysis.ipynb) | DESeq2: maturation over time, and biofilm vs planktonic adjusted for time |
| [`03_gene_functional`](02_notebooks/staphylococcus_aureus/03_gene_functional.ipynb) | ORA and GSEA with KEGG and GO gene sets |
| **_Homo sapiens_ — airway smooth muscle ± dexamethasone** | |
| [`01_quality_control`](02_notebooks/homo_sapiens/01_quality_control.ipynb) | QC and exploratory analysis, accounting for donor |
| [`02_differential_expression_analysis`](02_notebooks/homo_sapiens/02_differential_expression_analysis.ipynb) | DESeq2 with a paired design (`~ donor + condition`) |
| [`03_gene_functional`](02_notebooks/homo_sapiens/03_gene_functional.ipynb) | ORA with g:Profiler and GSEA with MSigDB gene sets |

---

## 🛠️ Software, Datasets & Resources

**Software**

- **R (≥ 4.3)** with DESeq2, fgsea, mulea, tidyverse and friends — full list in the installation script below
- **Jupyter notebooks (R kernel)** in [`02_notebooks/`](02_notebooks/), or the source R Markdown scripts in [`01_scripts/`](01_scripts/)
- **GitHub Codespaces / dev container** — preconfigured cloud environment, no local install needed (see setup options below)
- **nf-core/rnaseq** (Nextflow) — used upstream to process raw reads; outputs are provided precomputed

**Datasets** (small, preprocessed for in-class scalability)

- 🦠 *Staphylococcus aureus* **biofilm vs planktonic** time course, strains USA-100 and USA-500 — [`data/data-01-Staphylococcus_aureus/`](data/data-01-Staphylococcus_aureus/)
- 🧑‍🔬 *Homo sapiens* **airway smooth muscle ± dexamethasone** (paired donor design) — [`data/data-02-Homo_sapiens/`](data/data-02-Homo_sapiens/)
- 📚 Prebuilt gene-set databases (KEGG, GO) in [`data/databases/`](data/databases/)

**Resources**

- 📖 **[Rendered course book](https://biosustain.github.io/dsp_transcriptomics_27200-Data-driven-bioengineering/)** — the `docs/` site built from this repository (bookdown)
- 🎞️ Slides in [`slides/`](slides/)
- 🔬 Example nf-core/rnaseq outputs and MultiQC report in [`data/nf-core_rnaseq/`](data/nf-core_rnaseq/) and [`results/`](results/)

---

**Material for the workshop is located at:**
[dsp_transcriptomics_27200-Data-driven-bioengineering](https://github.com/biosustain/dsp_transcriptomics_27200-Data-driven-bioengineering)

Below are two setup options for the practical activities:

>Run the workshop in the cloud (no need to install anything).
>
<div class="warning">
  <strong>⚠️ Warning:</strong> Change the configuration at the Machine type: increase it to 4-core .
</div>


**Launch the app:**
[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/biosustain/dsp_transcriptomics_27200-Data-driven-bioengineering)

Once the Codespace is running, open `02_notebooks/` and start with `staphylococcus_aureus/01_quality_control.ipynb`.

**First time in the notebooks — three things to expect:**

- 🌐 **Browser:** use **Chrome, Firefox or Edge**. Codespaces does not work reliably in Safari.
- 🧮 **Kernel:** when VS Code asks you to *Select Kernel*, choose **R** (under *Jupyter Kernel*). The notebooks run R, not Python.
- ⚠️ **"No text editor active" pop-up:** a warning from the R extension that appears when running cells. It is harmless — your code still runs. Just close it.
- ▶️ **Running cells:** use **Shift+Enter** or the ▶ button next to the cell — **not Ctrl+Enter**, which the R extension intercepts and sends to a terminal instead of the notebook. The first cell can take a moment while the R kernel starts.


>Run the workshop locally on your machine. 

<div class="warning">
  <strong>⚠️ Warning:</strong> Please, contact me if you need help! Juliana Assis(jasge@dtu.dk)
</div>


**To run it on your own machine, install the following packages:**

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


## 💬 See You There!

We're looking forward to seeing everyone. If you have questions before the course, feel free to reach out.

**Best wishes,**  
*The 27200 Data Driven Bioengineering - Transcriptomics Team*

---

<div align="center">

</div>


