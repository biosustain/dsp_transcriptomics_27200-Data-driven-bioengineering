#!/usr/bin/env python3
"""Generate the student notebooks in 02_notebooks/ from the Rmd scripts in 01_scripts/.

The Rmd files are the single source of truth: they are also the chapters of the
course book. The notebooks are derived from them, so never edit an .ipynb by
hand -- edit the Rmd and regenerate:

    python3 util/rmd_to_ipynb.py                       # all six notebooks
    python3 util/rmd_to_ipynb.py 01_scripts/x.Rmd --out 02_notebooks/y.ipynb

The R code is copied into the cells verbatim. What the script translates is the
R Markdown scaffolding that Jupyter cannot render or run:

  * YAML front matter is dropped (the first heading is the title).
  * `eval=FALSE` chunks become display-only code blocks (or are dropped when the
    Rmd also hides them with `echo=FALSE`), so "Run All" never executes a chunk
    the report itself does not run.
  * `fig.width`/`fig.height` become `options(repr.plot.*)` so figures keep the
    size the author chose.
  * `:::class` callouts and `<div class="...">` boxes become inline-styled
    `<div>`s, with blank lines inside them so Jupyter still renders the markdown
    they contain.
  * `` `r 5` `` style literal inline R in prose is folded to its value.

Standard library only, so it runs in the dev container, a Codespace or a laptop.
"""

import argparse
import hashlib
import json
import re
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]

# Source Rmd -> generated notebook. Grouped by organism to mirror the book's parts
# and the data/ folders; the human scripts carry no suffix in 01_scripts/ only
# for historical reasons, which is confusing for students, so it is not kept here.
NOTEBOOKS = {
    "01_scripts/01_quality_control_saureus.Rmd":
        "02_notebooks/staphylococcus_aureus/01_quality_control.ipynb",
    "01_scripts/02_differential_expression_analysis_saureus.Rmd":
        "02_notebooks/staphylococcus_aureus/02_differential_expression_analysis.ipynb",
    "01_scripts/03_gene_functional_saureus.Rmd":
        "02_notebooks/staphylococcus_aureus/03_gene_functional.ipynb",
    "01_scripts/01_quality_control.Rmd":
        "02_notebooks/homo_sapiens/01_quality_control.ipynb",
    "01_scripts/02_differential_expression_analysis.Rmd":
        "02_notebooks/homo_sapiens/02_differential_expression_analysis.ipynb",
    "01_scripts/03_gene_functional.Rmd":
        "02_notebooks/homo_sapiens/03_gene_functional.ipynb",
}

# Inline styles for the callout classes. Colours follow the ones the Rmd files
# already use for their inline-styled callouts, so notebooks and book match.
CLASS_STYLE = {
    "boxy":      "background:#f0f4f8;border:1px solid #c9d6e3;border-radius:4px;padding:10px 20px;margin:10px 0;",
    "note":      "background:#eaf4fd;border-left:5px solid #3498db;border-radius:4px;padding:10px 16px;margin:10px 0;",
    "important": "background:#fdf2e9;border-left:5px solid #e67e22;border-radius:4px;padding:10px 16px;margin:10px 0;",
    "tip":       "background:#fff3cd;border-left:4px solid #ffc107;border-radius:4px;padding:10px 16px;margin:10px 0;",
    "remember":  "background:#d1ecf1;border-left:4px solid #0c5460;border-radius:4px;padding:10px 16px;margin:10px 0;",
}

CHUNK_OPEN = re.compile(r"^```\{r(?:[ ,]+([A-Za-z0-9._-]+))?\s*,?\s*(.*?)\}\s*$")
CHUNK_OPT = re.compile(r"([A-Za-z][\w.]*)\s*=\s*([^,]+)")
FENCE_OPEN = re.compile(r"^:::+\s*(?:\{([^}]*)\}|([\w-]+))?\s*$")
FENCE_STYLE = re.compile(r'style\s*=\s*"([^"]*)"')
DIV_OPEN = re.compile(r'^\s*<div\b([^>]*)>\s*$')
DIV_CLASS = re.compile(r'class\s*=\s*"([^"]+)"')
DIV_CLOSE = re.compile(r"^\s*</div>\s*$")
HTML_COMMENT = re.compile(r"^\s*<!--.*-->\s*$")
INLINE_R_NUM = re.compile(r"`r\s+(-?\d+(?:\.\d+)?)`")
INLINE_R_STR = re.compile(r'`r\s+"([^"]*)"`')

KERNEL_METADATA = {
    "kernelspec": {"display_name": "R", "language": "R", "name": "ir"},
    "language_info": {
        "codemirror_mode": "r",
        "file_extension": ".r",
        "mimetype": "text/x-r-source",
        "name": "R",
        "pygments_lexer": "r",
    },
}


def strip_front_matter(lines):
    if lines and lines[0].strip() == "---":
        for i in range(1, len(lines)):
            if lines[i].strip() == "---":
                return lines[i + 1:]
    return lines


def parse_chunk_header(line):
    m = CHUNK_OPEN.match(line)
    label, raw = m.group(1), m.group(2) or ""
    opts = {k: v.strip() for k, v in CHUNK_OPT.findall(raw)}
    return label, opts


def parse_rmd(text):
    """Split into ('md', lines) and ('code', label, opts, lines) blocks."""
    blocks, buf, i = [], [], 0
    lines = strip_front_matter(text.splitlines())
    while i < len(lines):
        line = lines[i]
        if CHUNK_OPEN.match(line):
            if buf:
                blocks.append(("md", buf))
                buf = []
            label, opts = parse_chunk_header(line)
            body, i = [], i + 1
            while i < len(lines) and lines[i].strip() != "```":
                body.append(lines[i])
                i += 1
            blocks.append(("code", label, opts, body))
        else:
            buf.append(line)
        i += 1
    if buf:
        blocks.append(("md", buf))
    return blocks


def dedent(lines):
    indents = [len(l) - len(l.lstrip(" ")) for l in lines if l.strip()]
    cut = min(indents) if indents else 0
    return [l[cut:] if l.strip() else "" for l in lines]


def is_false(v):
    return v is not None and v.upper() == "FALSE"


def convert_markdown(lines, stats):
    """Rewrite R Markdown-only syntax into markdown Jupyter renders correctly.

    Jupyter follows CommonMark: markdown inside an HTML block is only parsed
    if blank lines separate it from the enclosing tags. Every box therefore
    gets a blank line after its opening tag and before its closing tag.
    """
    out, fence_depth, div_depth, block = [], 0, 0, []

    def flush_block(close_tag):
        out.extend(dedent(block))
        out.append("")
        out.append(close_tag)
        block.clear()

    for line in lines:
        if HTML_COMMENT.match(line):
            continue

        line = INLINE_R_NUM.sub(lambda m: m.group(1), line)
        line = INLINE_R_STR.sub(lambda m: m.group(1), line)
        if "`r " in line:
            stats["inline_r_unfolded"] += 1

        m = FENCE_OPEN.match(line)
        if m and (m.group(1) or m.group(2)):
            attrs, cls = m.group(1), m.group(2)
            if attrs and FENCE_STYLE.search(attrs):
                style = FENCE_STYLE.search(attrs).group(1)
            else:
                style = CLASS_STYLE.get((cls or "boxy").strip(), CLASS_STYLE["boxy"])
            out.append(f'<div style="{style}">')
            out.append("")
            fence_depth += 1
            stats["callouts"] += 1
            continue
        if m and fence_depth and not (m.group(1) or m.group(2)):
            out.append("")
            out.append("</div>")
            fence_depth -= 1
            continue

        m = DIV_OPEN.match(line)
        if m:
            attrs = m.group(1)
            cm = DIV_CLASS.search(attrs)
            if cm and "style=" not in attrs:
                style = CLASS_STYLE.get(cm.group(1).split()[0], CLASS_STYLE["boxy"])
                attrs = DIV_CLASS.sub(f'style="{style}"', attrs)
            out.append(f"<div{attrs}>")
            out.append("")
            div_depth += 1
            stats["callouts"] += 1
            continue
        if DIV_CLOSE.match(line) and div_depth:
            out.append("")
            out.append("</div>")
            div_depth -= 1
            continue

        out.append(line.rstrip())

    # Trim edge blank lines and collapse long runs of them.
    text = "\n".join(out).strip("\n")
    text = re.sub(r"\n{3,}", "\n\n", text)
    return text


def convert_code(label, opts, body, stats):
    """Return ('code', src) or ('md', src) or None for a dropped chunk."""
    src = "\n".join(body).strip("\n")
    if is_false(opts.get("eval")):
        if is_false(opts.get("echo")):
            stats["dropped"] += 1
            return None
        stats["display_only"] += 1
        return ("md", f"```r\n{src}\n```")

    w, h = opts.get("fig.width"), opts.get("fig.height")
    if w or h:
        stats["fig_sized"] += 1
        parts = []
        if w:
            parts.append(f"repr.plot.width = {w}")
        if h:
            parts.append(f"repr.plot.height = {h}")
        src = f"options({', '.join(parts)})  # figure size set in the Rmd chunk\n{src}"
    return ("code", src)


def cell(kind, source, cell_id, name=None):
    c = {
        "cell_type": kind,
        "id": cell_id,
        "metadata": {} if name is None else {"name": name},
        "source": source.splitlines(keepends=True),
    }
    if kind == "code":
        c["execution_count"] = None
        c["outputs"] = []
    return c


def preamble(src_rel):
    md = (
        "> **Generated notebook — do not edit here.**  \n"
        f"> Source: `{src_rel}`, which is also a chapter of the course book.  \n"
        "> To change anything, edit the Rmd and run `python3 util/rmd_to_ipynb.py`.\n"
        ">\n"
        "> Run the notebooks in order — **01 → 02 → 03** — with the **R** kernel; "
        "each step saves results that the next one loads.\n"
        "\n"
        "**First time here? Four things to expect:**\n"
        "\n"
        "- 🌐 **Browser:** use **Chrome, Firefox or Edge** — Codespaces does not work reliably in Safari.\n"
        "- 🧮 **Kernel:** when VS Code asks you to *Select Kernel*, choose **Jupyter Kernel...** → **R**. The notebooks run R, not Python.\n"
        "- ⚠️ **\"No text editor active\" pop-up:** a harmless warning from the R extension — your code still runs. Just close it.\n"
        "- ▶️ **Running cells:** use **Shift+Enter** or the ▶ button next to the cell — **not Ctrl+Enter**, which the R extension intercepts. The first cell can take a moment while the R kernel starts."
    )
    code = (
        "# Match the report's defaults: warnings hidden (warning=FALSE in the Rmd)\n"
        "# and 7 x 5 inch figures. Remove the warn option to see warnings.\n"
        "options(warn = -1, repr.plot.width = 7, repr.plot.height = 5)\n"
        "\n"
        "# Make tables display in Jupyter the way they do in the rendered report.\n"
        "# kable()/kableExtra return HTML that the R kernel would otherwise show as\n"
        "# raw text; DT::datatable() is an interactive widget whose JavaScript does\n"
        "# not run in the VS Code output pane, so it is shown as a static table.\n"
        "options(knitr.table.format = \"html\")\n"
        "local({\n"
        "  css <- paste0(\"<style>table.table,table.dataframe{border-collapse:collapse;font-size:0.9em}\",\n"
        "                \".table th,.table td{padding:3px 10px;border-bottom:1px solid #ddd}\",\n"
        "                \".table-striped tbody tr:nth-child(odd){background:#f5f7fa}</style>\")\n"
        "  registerS3method(\"repr_html\", \"knitr_kable\", function(obj, ...) {\n"
        "    paste0(css, paste(obj, collapse = \"\\n\"))\n"
        "  }, envir = asNamespace(\"repr\"))\n"
        "  registerS3method(\"repr_html\", \"datatables\", function(obj, ...) {\n"
        "    d <- as.data.frame(obj$x$data, stringsAsFactors = FALSE, check.names = FALSE)\n"
        "    note <- if (nrow(d) > 100) sprintf(\n"
        "      \"<p style='font-size:0.85em;color:#666'><em>Static preview: first 100 of %d rows.</em></p>\", nrow(d)) else \"\"\n"
        "    tbl <- knitr::kable(head(d, 100), format = \"html\", row.names = FALSE,\n"
        "                        table.attr = \"class='table table-striped'\")\n"
        "    paste0(css, note, paste(tbl, collapse = \"\\n\"))\n"
        "  }, envir = asNamespace(\"repr\"))\n"
        "})"
    )
    return md, code


def convert(src: Path, dst: Path):
    src_rel = src.resolve().relative_to(REPO).as_posix()
    stats = {k: 0 for k in ("callouts", "dropped", "display_only", "fig_sized", "inline_r_unfolded")}
    cells = []

    def add(kind, source, name=None):
        cid = hashlib.sha1(f"{dst.name}:{len(cells)}".encode()).hexdigest()[:8]
        cells.append(cell(kind, source, cid, name))

    md, code = preamble(src_rel)
    add("markdown", md)
    add("code", code)

    for block in parse_rmd(src.read_text(encoding="utf-8")):
        if block[0] == "md":
            text = convert_markdown(block[1], stats)
            if text:
                add("markdown", text)
        else:
            _, label, opts, body = block
            res = convert_code(label, opts, body, stats)
            if res is None:
                continue
            kind, source = res
            add("code" if kind == "code" else "markdown", source, label if kind == "code" else None)

    nb = {
        "cells": cells,
        "metadata": KERNEL_METADATA,
        "nbformat": 4,
        "nbformat_minor": 5,
    }
    dst.parent.mkdir(parents=True, exist_ok=True)
    dst.write_text(json.dumps(nb, indent=1, ensure_ascii=False) + "\n", encoding="utf-8")

    n_code = sum(c["cell_type"] == "code" for c in cells)
    print(f"{dst.relative_to(REPO)}: {len(cells)} cells ({n_code} code) | "
          f"callouts {stats['callouts']}, fig-sized {stats['fig_sized']}, "
          f"display-only {stats['display_only']}, dropped {stats['dropped']}"
          + (f", UNFOLDED inline R {stats['inline_r_unfolded']}" if stats["inline_r_unfolded"] else ""))


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("rmd", nargs="?", help="a single Rmd to convert (default: all six)")
    ap.add_argument("--out", help="output .ipynb path (with a single Rmd)")
    args = ap.parse_args()

    if args.rmd:
        if not args.out:
            sys.exit("--out is required when converting a single file")
        convert(Path(args.rmd), Path(args.out))
        return
    for src, dst in NOTEBOOKS.items():
        convert(REPO / src, REPO / dst)


if __name__ == "__main__":
    main()
