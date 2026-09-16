# Checks that every package the workshop scripts load is actually usable in
# the built image. Run against the freshly published image by
# .github/workflows/publish-devcontainer.yml.
#
# This exists because install.packages() only *warns* on failure: the image
# can build "successfully" while a package is silently broken, and the first
# person to find out would otherwise be a student mid-workshop.

pkgs <- c(
  # Loaded via library() somewhere in 01_scripts/ or project/
  "DESeq2", "DT", "EnhancedVolcano", "KEGGREST", "RColorBrewer",
  "SummarizedExperiment", "apeglm", "factoextra", "fgsea", "gggenes",
  "ggpubr", "gprofiler2", "heatmaply", "kableExtra", "knitr", "msigdbr",
  "mulea", "org.EcK12.eg.db", "pheatmap", "plotly", "reshape2", "tidyverse",
  # Needed to render the bookdown site
  "bookdown", "rmarkdown"
)

ok <- vapply(pkgs, requireNamespace, logical(1), quietly = TRUE)

if (any(!ok)) {
  cat("BROKEN PACKAGES:", paste(pkgs[!ok], collapse = ", "), "\n")
  quit(status = 1)
}

cat("All", length(pkgs), "R packages load correctly.\n")
