# Start here

Welcome to the transcriptomics session. Everything you need is already installed
in this Codespace: R, all the packages, Nextflow and Docker. Nothing to set up.

## What to do

**First, make a count matrix yourself.** Start this now, during the welcome: it runs on its
own while the lectures go on.

### Pick ONE dataset and run it

A Codespace has room for **one** pipeline run at a time. Choose one, paste it into the
terminal, and leave it running.

**Human** - the dataset the rest of the day uses. About **20 to 25 minutes**.

```bash
bash 00_pipeline/00_nfcore_rnaseq_processing_human.sh
```

***S. aureus*** - the advanced track. About **10 minutes**.

```bash
bash 00_pipeline/00_nfcore_rnaseq_processing_saureus.sh
```

Each script deletes its own working files at the end, so if you want to try the other one
afterwards there is room for it. Run them one at a time, never both at once.

### While it runs, and when it finishes

That run is a **demonstration**: two samples of 50,000 reads are far too few to draw
biology from, so you will **not** analyse its output. The point is to watch reads turn
into a table of numbers, and to read the quality report it produces.

Your results land in:

| Run | Folder |
|---|---|
| Human | `results/human/nfcore_rnaseq_processing_downsampled/` |
| *S. aureus* | `results/saureus_usa100_nfcore_processing_downsampled/` |

Open it in the file tree on the left and have a look around. Worth finding:

- **`multiqc/`** - every quality metric from every step, gathered into one page. Start here.
- **`star_salmon/`** (human) or **`bowtie2_salmon/`** (*S. aureus*) - the alignments, and
  `salmon.merged.gene_counts.tsv`, which is the count matrix itself. Open it: that table is
  what the whole rest of the day is built on.
- **`pipeline_info/`** - what ran, for how long, with which software versions.

**Then open the real quality report.** Yours covers two samples; these cover the full
datasets we processed before the course, and they are the ones worth interpreting. In the
file tree, right-click the file and choose **Open Preview**:

| Dataset | File |
|---|---|
| Human ASM, 8 samples | `data/data-02-Homo_sapiens/hasapiens/multiqc/data-02-Homo_sapiens_multiqc_report.html` |
| *S. aureus* USA-100, 32 samples | `data/data-01-Staphylococcus_aureus/USA-100/data-01-Staphylococcus_aureus_USA100_multiqc_report.html` |
| *S. aureus* USA-500, 32 samples | `data/data-01-Staphylococcus_aureus/USA-500/data-01-Staphylococcus_aureus_USA500_multiqc_report.html` |

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
