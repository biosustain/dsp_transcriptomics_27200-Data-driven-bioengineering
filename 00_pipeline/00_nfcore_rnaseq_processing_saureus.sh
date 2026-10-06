# Script to process RNA sequencing files - Staphylococcus aureus USA100

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
# A Codespace does not have room for two pipeline runs. Nearly everything this
# run wrote lives in work/, and none of it is needed once results/ exists.
#
# Deleting it costs you -resume: Nextflow re-uses work/ to skip the steps it has
# already done, so a re-run after this starts from the beginning. The run is
# short, so that is a fair trade.
#
# If the pipeline failed, work/ is kept: it holds the logs you need to see why,
# and -resume lets you carry on from where it stopped.
# -----------------------------------------------------------------------------
status=$?
root=$(git rev-parse --show-toplevel 2>/dev/null) || root=""

if [ "$status" -ne 0 ]; then
    echo "Pipeline failed (exit $status). Keeping work/ so you can debug and -resume."
elif [ -z "$root" ]; then
    echo "Not inside the repository, so nothing was deleted."
    echo "Run this from the repository root to free the disk: rm -rf work .nextflow*"
else
    echo "Pipeline finished. Freeing disk space..."
    rm -rf "$root/work" "$root"/.nextflow*
    df -h "$root" | awk 'NR==1 || NR==2'
fi
