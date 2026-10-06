# Script to process RNA sequencing files - Staphylococcus aureus USA100

# -----------------------------------------------------------------------------
# Keep the scratch files off the small disk.
#
# /workspaces is 32 GB and holds the repository, the results and every Docker
# image the pipeline pulls. /tmp is a separate 118 GB disk that nothing else
# uses. Nextflow writes its intermediates to work/, which is by far the largest
# thing a run produces, so it goes there instead. Override with NXF_WORK if you
# want it somewhere else.
# -----------------------------------------------------------------------------
NXF_WORK="${NXF_WORK:-/tmp/nxf-work}"

nextflow run 'https://github.com/nf-core/rnaseq' \
    -name 'saureus_usa100_PRJNA685119_GSE163153' \
    -r 3.23.0 \
    -profile prokaryotic,docker \
    -work-dir "$NXF_WORK" \
    --input  '/workspaces/dsp_transcriptomics_27200-Data-driven-bioengineering/data/seq_files_subsampled/PRJNA685119_GSE163153_saureus/usa100/samplesheet_PRJNA685119_usa100_subset_24h_2samples.csv' \
    --outdir '/workspaces/dsp_transcriptomics_27200-Data-driven-bioengineering/results/saureus_usa100_nfcore_processing_downsampled' \
    --fasta  '/workspaces/dsp_transcriptomics_27200-Data-driven-bioengineering/data/genome_files/saureus/usa100_NC_002745/GCF_000009645.1_ASM964v1_genomic.fna.gz' \
    --gtf    '/workspaces/dsp_transcriptomics_27200-Data-driven-bioengineering/data/genome_files/saureus/usa100_NC_002745/GCF_000009645.1_ASM964v1_genomic.gtf.gz' \
    -c /workspaces/dsp_transcriptomics_27200-Data-driven-bioengineering/00_pipeline/custom.config

# -----------------------------------------------------------------------------
# Free the disk, but only if the run actually succeeded.
#
# Two things to reclaim. The scratch directory, which is the bigger of the two
# while the run is going, and the Docker images: nf-core pulls around twenty of
# them, close to 22 GB, and they stay behind on a 32 GB disk.
#
# Deleting the scratch costs you -resume, so a re-run starts from the beginning.
# Pruning the images means the other dataset re-downloads its containers if you
# run it next. Both are fair trades here: the run is short, and without them a
# Codespace ends the morning at 95% full.
#
# If the pipeline failed, everything is kept: the logs are in the scratch
# directory and -resume lets you carry on from where it stopped.
# -----------------------------------------------------------------------------
status=$?
root=$(git rev-parse --show-toplevel 2>/dev/null) || root=""

if [ "$status" -ne 0 ]; then
    echo "Pipeline failed (exit $status). Keeping $NXF_WORK so you can debug and -resume."
else
    echo "Pipeline finished. Freeing disk space..."
    rm -rf "$NXF_WORK"
    [ -n "$root" ] && rm -rf "$root"/.nextflow*
    docker image prune -af > /dev/null 2>&1 && echo "  removed the pipeline's Docker images"
    df -h "${root:-$PWD}" | awk 'NR==1 || NR==2'
fi
