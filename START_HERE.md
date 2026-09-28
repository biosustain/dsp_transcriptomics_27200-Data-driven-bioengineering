# Start here

Welcome to the transcriptomics session. Everything you need is already installed
in this Codespace: R, all the packages, Nextflow and Docker. Nothing to set up.

## What to do

**First, make a count matrix yourself.** Follow the *Running the nf-core/rnaseq pipeline*
chapter in the [course book](https://biosustain.github.io/dsp_transcriptomics_27200-Data-driven-bioengineering/),
or run it directly:

```bash
bash 00_pipeline/00_nfcore_rnaseq_processing_saureus.sh
```

It takes about 10 minutes on six small files. That run is a demonstration: it is far too
small to analyse, so you will **not** use its output afterwards. The point is to see how
reads become a table of counts, and to read the quality report it produces.

**Then analyse real counts.** The notebooks start from full count matrices, made with the
same pipeline, already in `data/`.

1. Open **`02_notebooks/homo_sapiens/01_quality_control.ipynb`** in the file tree on the left.
2. When VS Code asks you to *Select Kernel*, choose **Jupyter Kernel... → R**. The notebooks are R, not Python.
3. Run cells with **Shift+Enter**, or the play button next to each cell.
4. Work through the three notebooks **in order**: `01` quality control, then `02` differential
   expression, then `03` functional enrichment. Each one saves results the next one reads, so
   the order matters.

Work in your group, and stop at the **Interpretation questions** at the end of each
notebook. Those are the point of the session. Nobody expects a complete answer, and
arguing about them is the exercise.

## Three things that surprise people

- A pop-up saying **"No text editor active"** may appear when you run a cell. It is
  harmless. Close it, your code has still run.
- **Ctrl+Enter does not work** in these notebooks. The R extension takes it and sends
  your code to a terminal instead. Use Shift+Enter.
- The **first cell takes a moment** while R starts up. Later cells are quick.

## If something goes wrong

- Restart the kernel and run the notebook from the top. Most problems disappear.
- The `results/` folder starts empty. It fills up as you run the notebooks, so if a
  file is missing it usually means an earlier notebook has not been run yet.
- Still stuck? Ask one of us, or write to Juliana Assis (jasge@dtu.dk).

## Wanting more

The *S. aureus* notebooks in `02_notebooks/staphylococcus_aureus/` are the advanced
track: two strains, three time points, and a hypothesis to test across strains. Start
them if you finish the human dataset.

The full course book, with all the explanations, is at
<https://biosustain.github.io/dsp_transcriptomics_27200-Data-driven-bioengineering/>.

## Before you leave

**Delete your Codespace** when the session ends, so it does not eat your free GitHub
quota. Go to <https://github.com/codespaces>, find this one, and delete it.
