# 🧬 27200 Data Driven Bioengineering - Transcriptomics

> **Course materials are live — and we're still polishing a few things for this year!**

---

## 📚 Course Materials

All materials, resources, and a **draft agenda** for the day are available in this repository. We are actively updating and revising content ahead of the course.

👉 **[View the full repository →](https://github.com/biosustain/dsp_transcriptomics_27200-Data-driven-bioengineering)**

---

## 📋 Course Details

| | |
|---|---|
| 🕘 **Duration** | 10:00 – 14:00 |

---

## 🎯 Main Concepts & Learning Objectives

> _TODO: fill in — e.g. Illumina sequencing basics, the nf-core/rnaseq pipeline, QC/EDA, differential expression with DESeq2, functional enrichment (ORA/GSEA)._

- 
- 
- 

---

## 🔑 Key Takeaways

> _TODO: the key messages you want students to leave with._

- 
- 
- 

---

## 🧪 Exercises & Interactive Activities

> _TODO: list the planned hands-on scripts/activities (e.g. Script 01–04 below), with a short description of what each one covers._

| Script | Description |
|---|---|
|  |  |

---

## 🛠️ Software, Datasets & Resources

> _TODO: list required software, datasets, and other resources beyond the R package installation below._

- 
- 
- 

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
  "factoextra",
  "knitr",
  "kableExtra",
  "DT",
  "plotly",
  "ggpubr",
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
  "EnhancedVolcano"
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
*The DSP Transcriptomics Training Team*

---

<div align="center">

</div>


