install.packages(
  c(
    "languageserver",
    "ggpubr",
    "plotly",
    "remotes",
    "bookdown",
    "DT",
    "here",
    "kableExtra",
    "pheatmap",
    # Needed by the S. aureus and human (ASM + dexamethasone) analyses.
    "tidyverse",
    "factoextra",
    "gggenes",
    "reshape2",
    "gprofiler2",
    "msigdbr",
    # Jupyter R kernel.
    "heatmaply",
    "pbdZMQ",
    "IRkernel"
  ),
  dependencies = TRUE,
  repos = "https://cloud.r-project.org",
  Ncpus = parallel::detectCores()
)

if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager", repos = "https://cloud.r-project.org")
}

# Install Bioconductor packages — fgsea must come before mulea
BiocManager::install(
  c(
    "DESeq2",
    "apeglm",
    "EnhancedVolcano",
    "KEGGREST",
    "fgsea",
    # E. coli KEGG gene-symbol annotation, used by the E. coli scripts.
    "org.EcK12.eg.db"
  ),
  update = FALSE,
  ask = FALSE
)

# mulea is not on CRAN — install from GitHub
remotes::install_github("ELTEbioinformatics/mulea")
