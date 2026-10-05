# Pipeline - turning reads into counts

This is the first step of the session. Before analysing a count matrix, you make one.

## What students run

```bash
bash 00_pipeline/00_nfcore_rnaseq_processing_saureus.sh
```

Six *S. aureus* USA-100 samples (three biofilm, three planktonic, all at 24 h),
sub-sampled to 50,000 reads each, through nf-core/rnaseq v3.23.0 with the
`prokaryotic` profile (Bowtie2 + Salmon). About 10 minutes in a 4-core Codespace.

**This run is a demonstration.** Six files of 50,000 reads are enough to watch the
pipeline work and to read its MultiQC report, and far too few to draw biology from.
Students do not analyse their own output: the notebooks start from the full count
matrices in `data/`, made with this same pipeline. Say this out loud in class, or
someone will go hunting for their output in notebook 01.

The walkthrough, with every argument explained, is the *Running the nf-core/rnaseq
pipeline* chapter of the course book.

## Files

| File | What it is |
|---|---|
| `00_nfcore_rnaseq_processing_saureus.sh` | The run students do, on the sub-sampled USA-100 files |
| `00_nfcore_rnaseq_processing.sh` | Provenance only: how the **human** counts in `data/` were produced (STAR + Salmon, full dataset). Not run in class |
| `custom.config` | Caps CPUs and memory so the run fits in a Codespace (4 cores, 14 GB) |

## Where the real counts came from

The matrices the notebooks read were produced with the same pipeline on the full
datasets:

- *S. aureus*, both strains, all three time points, `prokaryotic` profile (Bowtie2 + Salmon),
  each strain against its own reference
- Human, STAR + Salmon, because human genes have introns and need a splice-aware aligner

Both sets of outputs, including their MultiQC reports, are in `data/`.
