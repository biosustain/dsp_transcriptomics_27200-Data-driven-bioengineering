# =============================================================================
# render_all_strains.R
#
# Runs the whole S. aureus analysis for BOTH strains and writes one HTML report
# per script per strain, next to the .Rmd files.
#
# Why this exists: the book only ever renders USA-100, because the chapters
# default to that strain. USA-500 exists only because someone ran it by hand.
# Any change to the bacterial scripts therefore leaves USA-500 on the old
# results until this is run, and results/cross_strain/biofilm_vs_planktonic_24h.tsv
# ends up comparing two different analyses.
#
# Usage, from a terminal at the repository root:
#     Rscript 01_scripts/render_all_strains.R
#
# or, inside R:
#     source("01_scripts/render_all_strains.R")
#
# A single strain of a single script:
#     rmarkdown::render("01_scripts/02_differential_expression_analysis_saureus.Rmd",
#                       params = list(strain = "USA-500"))
#
# Takes a few minutes per strain. The gene sets under data/databases/ are
# already prepared for both strains and committed, so 02b does not need to run.
# =============================================================================

git_root <- system("git rev-parse --show-toplevel", intern = TRUE)

# Order matters: 01 writes the DESeqDataSet that 02 reads, and 02 writes the
# DE tables that 03 reads.
steps <- list(
  list(rmd = "01_quality_control_saureus.Rmd",                prefix = "01_QC"),
  list(rmd = "02_differential_expression_analysis_saureus.Rmd", prefix = "02_DE"),
  list(rmd = "03_gene_functional_saureus.Rmd",                prefix = "03_FN")
)

strains <- c("USA-100", "USA-500")

for (s in strains) {
  tag <- tolower(gsub("-", "", s))
  for (st in steps) {
    message("\n=== ", s, " : ", st$rmd, " ===")
    rmarkdown::render(
      input       = file.path(git_root, "01_scripts", st$rmd),
      # 03 takes the lower-case tag ("usa100"); 01 and 02 take the full name.
      params      = list(strain = if (startsWith(st$prefix, "03")) tag else s),
      output_file = paste0(st$prefix, "_", tag, ".html"),
      envir       = new.env()   # fresh environment per run, avoids object bleed
    )
  }
}

message("\nDone. Six HTML reports written next to the .Rmd files, and the ",
        "cross-strain table in Part 3 now holds both strains.\n",
        "Check they agree:  cat results/cross_strain/biofilm_vs_planktonic_24h.tsv")
