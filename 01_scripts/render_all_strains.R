# =============================================================================
# render_all_strains.R
#
# Renders the S. aureus differential expression report for BOTH strains in one
# go. Each strain produces its own HTML file, and the cross-strain comparison
# table in Part 3 accumulates results from both runs.
#
# Usage (from a terminal at the repo root):
#     Rscript 01_scripts/render_all_strains.R
#
# or, inside R:
#     source("01_scripts/render_all_strains.R")
#
# To run a single strain instead, just open the .Rmd and either edit the
# `strain <- ...` line or render with params, e.g.:
#     rmarkdown::render("01_scripts/02_differential_expression_analysis_saureus.Rmd",
#                       params = list(strain = "USA-500"))
# =============================================================================

git_root <- system("git rev-parse --show-toplevel", intern = TRUE)
rmd      <- file.path(git_root, "01_scripts",
                      "02_differential_expression_analysis_saureus.Rmd")

strains <- c("USA-100", "USA-500")

for (s in strains) {
  message("\n=== Rendering ", s, " ===")
  rmarkdown::render(
    input       = rmd,
    params      = list(strain = s),
    output_file = paste0("02_DE_", tolower(gsub("-", "", s)), ".html"),
    envir       = new.env()   # fresh environment per strain, avoids object bleed
  )
}

message("\nDone. Two HTML reports written next to the .Rmd, and the cross-strain ",
        "table in Part 3 now contains both strains.")
