# Display settings for the Jupyter notebooks under 02_notebooks/.
#
# The notebooks are generated from the Rmd files in 01_scripts/, which are also
# the chapters of the course book. Knitr applies a set of display defaults when
# it renders the book; the R kernel in Jupyter does not. This file applies the
# equivalent settings so that a figure or a table looks the same in the notebook
# as it does in the book.
#
# Sourced by the first code cell of every notebook. Nothing here affects the
# analysis - only how results are displayed.

# Warnings hidden, matching warning=FALSE in the Rmd chunks, and 7 x 5 inch
# figures, matching the book's default figure size. Chunks that asked for a
# different size set it themselves, just above the plot.
# Remove the warn option to see warnings.
options(warn = -1, repr.plot.width = 7, repr.plot.height = 5)

# Make tables display in Jupyter the way they do in the rendered report.
# kable()/kableExtra return HTML that the R kernel would otherwise show as
# raw text; DT::datatable() is an interactive widget whose JavaScript does
# not run in the VS Code output pane, so it is shown as a static table.
options(knitr.table.format = "html")
local({
  css <- paste0("<style>table.table,table.dataframe{border-collapse:collapse;font-size:0.9em}",
                ".table th,.table td{padding:3px 10px;border-bottom:1px solid #ddd}",
                ".table-striped tbody tr:nth-child(odd){background:#f5f7fa}</style>")
  registerS3method("repr_html", "knitr_kable", function(obj, ...) {
    paste0(css, paste(obj, collapse = "\n"))
  }, envir = asNamespace("repr"))
  registerS3method("repr_html", "datatables", function(obj, ...) {
    d <- as.data.frame(obj$x$data, stringsAsFactors = FALSE, check.names = FALSE)
    note <- if (nrow(d) > 100) sprintf(
      "<p style='font-size:0.85em;color:#666'><em>Static preview: first 100 of %d rows.</em></p>", nrow(d)) else ""
    tbl <- knitr::kable(head(d, 100), format = "html", row.names = FALSE,
                        table.attr = "class='table table-striped'")
    paste0(css, note, paste(tbl, collapse = "\n"))
  }, envir = asNamespace("repr"))
})
