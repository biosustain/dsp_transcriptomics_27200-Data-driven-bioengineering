# Script to process RNA sequencing files - Human ASM (dexamethasone), Himes 2014
# =============================================================================
# PROVENANCE ONLY - this run has already been completed on the DTU HPC.
# Kept here to document how the star_salmon output under
#   data/data-02-Homo_sapiens/hasapiens/star_salmon/
# was generated. You do NOT need to re-run this for the workshop.
# =============================================================================
#
# Eukaryotic dataset: aligner = star_salmon (STAR + Salmon), prokaryotic = false.
# Reference: GRCh38 primary assembly + GENCODE v50 primary-assembly annotation.
#
# The actual run used paths on the DTU HPC. Those are recorded in
# the comment block below for reference; the repo itself only stores the
# downstream output needed for teaching.

# Due to too high computational load, this example uses downsampled read files (50,000 reads each) and approximately 5 Mb of chromosome 19 as the reference. Two samples are processed only as example.


# gencode and the skip_* switches are set in human_demo.config, not here.
# Nextflow reads them from the command line as strings, which the rnaseq 3.27
# schema rejects, so the run would stop before it starts. See that file.

# No -name is set on purpose. Nextflow refuses to reuse a run name, so a fixed
# one makes the second attempt fail with "Run name ... has been already used".
# Left out, Nextflow generates a fresh name each time and you can just re-run.

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
    -r 3.27.0 \
    -profile docker \
    -work-dir "$NXF_WORK" \
    --aligner star_salmon \
    --input  '/workspaces/dsp_transcriptomics_27200-Data-driven-bioengineering/data/seq_files_subsampled/PRJNA229998_GSE52778_human/samplesheet_PRJNA229998_subsampled_2samples.csv' \
    --outdir '/workspaces/dsp_transcriptomics_27200-Data-driven-bioengineering/results/human/nfcore_rnaseq_processing_downsampled' \
    --fasta '/workspaces/dsp_transcriptomics_27200-Data-driven-bioengineering/data/genome_files/human/chr19_GRCh38_48115444-53115443.fna.gz' \
    --gtf '/workspaces/dsp_transcriptomics_27200-Data-driven-bioengineering/data/genome_files/human/chr19_GRCh38_48115444-53115443.gtf.gz' \
    --gtf_group_features 'gene_id' \
    --featurecounts_feature_type 'exon' \
    -c /workspaces/dsp_transcriptomics_27200-Data-driven-bioengineering/00_pipeline/custom.config \
    -c /workspaces/dsp_transcriptomics_27200-Data-driven-bioengineering/00_pipeline/human_demo.config

# -----------------------------------------------------------------------------
# Full run on the DTU HPC (for the record - not runnable from the repo):
#   nf-core/rnaseq 3.27.0, -profile conda, LSF; 8 samples (dexamethasone + untreated), FASTQs from ENA
#   fasta:  GRCh38.primary_assembly.genome.fa            (GENCODE release 50)
#   gtf:    gencode.v50.primary_assembly.annotation.gtf  (GENCODE release 50)
#   aligner: star_salmon | gencode: true | remove_ribo_rna: true
# -----------------------------------------------------------------------------

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
