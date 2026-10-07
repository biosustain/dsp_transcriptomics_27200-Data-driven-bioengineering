# Script to process RNA sequencing files - Staphylococcus aureus USA100


# =============================================================================
# WHILE THIS RUNS: ask Copilot about the command below
#
# The run takes about 10 minutes. Open Copilot Chat (the chat icon in the sidebar)
# and put these to it, with this file open so it can see the command:
#
#   - Explain each parameter of this nextflow run command.
#   - The bacterial run uses -profile prokaryotic. What does that profile
#     actually set? Which aligner does it choose, and which steps does it skip?
#   - Why does the human run use --aligner star_salmon instead? What is
#     different about the two genomes?
#   - Why are gencode and the skip_* switches in a config file (human_demo.config)
#     instead of on the command line?
#   - What does -profile docker change about how the pipeline runs?
#
# A profile is a named bundle of settings that lives inside the pipeline itself,
# not in our files, so the second question is really asking Copilot to read
# nf-core's own configuration.
#
# Check every answer against this script, the config files beside it, and the
# course book. An AI assistant answers with the same confidence whether it knows
# or is guessing, and you are the one who has to tell the difference.
# =============================================================================

nextflow run 'https://github.com/nf-core/rnaseq' \
    -name 'saureus_usa100_PRJNA685119_GSE163153' \
    -r 3.23.0 \
    -profile prokaryotic,docker \
    --input  '/workspaces/dsp_transcriptomics_27200-Data-driven-bioengineering/data/seq_files_subsampled/PRJNA685119_GSE163153_saureus/usa100/samplesheet_PRJNA685119_usa100_subset_24h_2samples.csv' \
    --outdir '/workspaces/dsp_transcriptomics_27200-Data-driven-bioengineering/results/saureus_usa100_nfcore_processing_downsampled' \
    --fasta  '/workspaces/dsp_transcriptomics_27200-Data-driven-bioengineering/data/genome_files/saureus/usa100_NC_002745/GCF_000009645.1_ASM964v1_genomic.fna.gz' \
    --gtf    '/workspaces/dsp_transcriptomics_27200-Data-driven-bioengineering/data/genome_files/saureus/usa100_NC_002745/GCF_000009645.1_ASM964v1_genomic.gtf.gz' \
    -c /workspaces/dsp_transcriptomics_27200-Data-driven-bioengineering/00_pipeline/custom.config

# -----------------------------------------------------------------------------
# Free the disk, but only if the run actually succeeded.
#
# Measured in a 4-core Codespace: the repository and the base system come to
# about 7 GB, Nextflow's work/ directory to well under 1 GB, and the Docker
# images nf-core pulls to nearly 22 GB. On a 32 GB disk the images are the
# whole problem, so they are what gets reclaimed.
#
# Deleting work/ costs you -resume, so a re-run starts from the beginning.
# Pruning the images means the other dataset re-downloads its containers if you
# run it next. Both are fair trades: the run is short, and without them a
# Codespace ends the morning at 95% full.
#
# If the pipeline failed, everything is kept: work/ holds the logs you need and
# -resume lets you carry on from where it stopped.
# -----------------------------------------------------------------------------
status=$?
root=$(git rev-parse --show-toplevel 2>/dev/null) || root=""

if [ "$status" -ne 0 ]; then
    echo "Pipeline failed (exit $status). Keeping work/ so you can debug and -resume."
elif [ -z "$root" ]; then
    echo "Not inside the repository, so nothing was deleted."
    echo "To free the disk yourself: rm -rf work .nextflow* && docker image prune -af"
else
    echo "Pipeline finished. Freeing disk space..."
    rm -rf "$root/work" "$root"/.nextflow*
    docker image prune -af > /dev/null 2>&1 && echo "  removed the pipeline's Docker images (~22 GB)"
    df -h "$root" | awk 'NR==1 || NR==2'
fi
