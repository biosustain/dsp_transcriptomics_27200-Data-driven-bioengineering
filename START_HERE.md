# Start here

> **Reading this as plain text?** Right-click `START_HERE.md` in the file tree on the left
> and choose **Open Preview** for the formatted version. Easier to follow.

Welcome to the transcriptomics session. Everything you need is already installed
in this Codespace: R, all the packages, Nextflow and Docker. Nothing to set up.

## The day in three steps

| | What | How long |
|---|---|---|
| **1** | **Run the pipeline** to make a count matrix yourself | ~25 min, runs on its own |
| **2** | **While it runs**, read the command, and explore a real quality report | the same ~25 min |
| **3** | **Analyse real counts** in the notebooks | the rest of the session |

Start step 1 now, during the welcome. It runs by itself while the lectures go on, and you
do steps 2 and 3 without waiting for it.

---

## Step 1: Run the pipeline

Pick **ONE** dataset. A Codespace has room for one run at a time. Paste it into the
terminal and leave it running.

**Human** - the dataset the rest of the day uses. About **20 to 25 minutes**.

```bash
bash 00_pipeline/00_nfcore_rnaseq_processing_human.sh
```

***S. aureus*** - the advanced track. About **10 minutes**.

```bash
bash 00_pipeline/00_nfcore_rnaseq_processing_saureus.sh
```

Each script clears up after itself when it finishes, so you can try the other one
afterwards if you want. Run them one at a time, never both at once.

This run is a **demonstration**: two samples of 50,000 reads are far too few to draw
biology from, so you will **not** analyse its output. The point is to watch reads turn into
a table of numbers.

Which one you pick here does not decide what you analyse later. **Everyone works through the
human dataset in step 3**, whichever pipeline they ran, because step 3 starts from the full
count matrices in `data/` rather than from your run.

---

## Step 2: While it runs

Do not sit and watch the terminal. There are two things to do, both of which take about as
long as the run.

### 2a. Read the command you just ran

Open the script you started - the questions to ask are written inside it, as comments just
above the command:

- [`00_pipeline/00_nfcore_rnaseq_processing_human.sh`](00_pipeline/00_nfcore_rnaseq_processing_human.sh)
- [`00_pipeline/00_nfcore_rnaseq_processing_saureus.sh`](00_pipeline/00_nfcore_rnaseq_processing_saureus.sh)

Open **Copilot Chat** (the chat icon in the sidebar) with that file open, and work through
them. Check every answer against the script and the course book: an AI assistant answers
with the same confidence whether it knows or is guessing.

### 2b. Explore a real quality report

Your own run covers two samples. These cover the **full** datasets, processed before the
course, and they are the ones worth interpreting. They open straight in your browser, no
download needed:

| Dataset | MultiQC report |
|---|---|
| Human ASM, 8 samples | [open](https://biosustain.github.io/dsp_transcriptomics_27200-Data-driven-bioengineering/multiqc/human_multiqc_report.html) |
| *S. aureus* USA-100, 32 samples | [open](https://biosustain.github.io/dsp_transcriptomics_27200-Data-driven-bioengineering/multiqc/usa100_multiqc_report.html) |
| *S. aureus* USA-500, 32 samples | [open](https://biosustain.github.io/dsp_transcriptomics_27200-Data-driven-bioengineering/multiqc/usa500_multiqc_report.html) |

Spend ten minutes in the one matching your dataset. Worth finding:

- The **general statistics** table at the top, one row per sample
- **FastQC**: read quality, GC content, adapter content, duplication, before and after trimming
- **How many reads aligned**, per sample
- The **PCA and sample-distance heatmap** from DESeq2
- **Software versions**, at the very end

### When your run finishes

Your output lands in:

| Run | Folder |
|---|---|
| Human | `results/human/nfcore_rnaseq_processing_downsampled/` |
| *S. aureus* | `results/saureus_usa100_nfcore_processing_downsampled/` |

Open it in the file tree and look around. `multiqc/` is your own report; `star_salmon/`
(human) or `bowtie2_salmon/` (*S. aureus*) holds `salmon.merged.gene_counts.tsv`, the count
matrix itself. Open that file: that table is what the whole rest of the day is built on.
`pipeline_info/` records what ran, for how long, with which software versions.

---

## Step 3: Analyse real counts

**Everyone does the human dataset**, whichever pipeline they ran in step 1. The *S. aureus*
notebooks are the advanced track: start them afterwards if you have time.

The notebooks start from full count matrices, made with the same pipeline, already in
`data/` - not from your own run.

1. Open [`02_notebooks/homo_sapiens/01_quality_control.ipynb`](02_notebooks/homo_sapiens/01_quality_control.ipynb), or find it in the file tree on the left.
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
