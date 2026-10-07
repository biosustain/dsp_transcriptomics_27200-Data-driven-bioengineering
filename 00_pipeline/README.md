# Pipeline - turning reads into counts

This is the first step of the session. Before analysing a count matrix, you make one.

## Pick one and run it

A Codespace has room for **one** pipeline run at a time, so choose one. Both scripts
delete their own working files when they finish, so if you want to try the other one
afterwards you can.

| | Command | Time |
|---|---|---|
| **Human** (the dataset the rest of the day uses) | `bash 00_pipeline/00_nfcore_rnaseq_processing_human.sh` | about **20 to 25 minutes** |
| ***S. aureus*** (the advanced track) | `bash 00_pipeline/00_nfcore_rnaseq_processing_saureus.sh` | about **10 minutes** |

- **Human**: two samples, one dexamethasone-treated and one untreated from the same
  donor, 50,000 read pairs each, against a 5 Mb slice of chromosome 19.
  nf-core/rnaseq v3.27.0, `star_salmon` (STAR + Salmon), because human genes have introns.
- ***S. aureus***: two USA-100 samples at 24 h, one biofilm and one planktonic, 50,000
  reads each. nf-core/rnaseq v3.23.0 with the `prokaryotic` profile (Bowtie2 + Salmon),
  which suits bacteria because they have no introns.

Each uses the same pipeline version as the full dataset it comes from, so what you run
matches the counts you analyse later.

## Where your output lands

| Run | Output folder |
|---|---|
| Human | `results/human/nfcore_rnaseq_processing_downsampled/` |
| *S. aureus* | `results/saureus_usa100_nfcore_processing_downsampled/` |

Worth opening, in this order:

1. `multiqc/` - every quality metric from every step, on one page. Start here.
2. `star_salmon/` (human) or `bowtie2_salmon/` (*S. aureus*) - the alignments and the
   merged count matrices. `salmon.merged.gene_counts.tsv` is the table itself.
3. `pipeline_info/` - what ran, how long it took, which software versions. The
   reproducibility record, and where `execution_trace_*.txt` shows the time per step.

## Then read the real MultiQC report

**This run is a demonstration.** Two files of 50,000 reads are enough to watch the
pipeline work, and far too few to judge an experiment by. Students do not analyse their
own output: the notebooks start from the full count matrices in `data/`, made with this
same pipeline.

Say this out loud in class, or someone will go hunting for their output in notebook 01.

For a report worth interpreting, open the one from the full dataset:

| Dataset | MultiQC report |
|---|---|
| Human ASM, 8 samples | [open in your browser](https://biosustain.github.io/dsp_transcriptomics_27200-Data-driven-bioengineering/multiqc/human_multiqc_report.html) |
| *S. aureus* USA-100, 32 samples | [open in your browser](https://biosustain.github.io/dsp_transcriptomics_27200-Data-driven-bioengineering/multiqc/usa100_multiqc_report.html) |
| *S. aureus* USA-500, 32 samples | [open in your browser](https://biosustain.github.io/dsp_transcriptomics_27200-Data-driven-bioengineering/multiqc/usa500_multiqc_report.html) |

These open straight in a browser. The same files live in `data/`, next to each dataset, but
VS Code cannot display an HTML page inside a Codespace, so use the links above.

Students should open one **while the pipeline is still running** - it takes about ten
minutes to go through and fills the wait.

The walkthrough, with every argument explained, is the *Running the nf-core/rnaseq
pipeline* chapter of the course book.

## Files

| File | What it is |
|---|---|
| `00_nfcore_rnaseq_processing_human.sh` | The human demo run, and a record of how the full human counts were produced |
| `00_nfcore_rnaseq_processing_saureus.sh` | The *S. aureus* demo run, on the sub-sampled USA-100 files |
| `custom.config` | Caps CPUs and memory so a run fits in a Codespace (4 cores, 14 GB) |
| `human_demo.config` | Boolean switches for the human run. They cannot be passed on the command line: Nextflow reads them as strings and the rnaseq 3.27 schema rejects that |

## Where the real counts came from

The matrices the notebooks read were produced with the same pipeline on the full
datasets:

- Human, nf-core/rnaseq v3.27.0, STAR + Salmon, against the whole GRCh38 genome with
  the GENCODE v50 annotation
- *S. aureus*, nf-core/rnaseq v3.23.0, both strains, all three time points,
  `prokaryotic` profile (Bowtie2 + Salmon), each strain against its own reference

Both sets of outputs, including the MultiQC reports above, are in `data/`.
