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


# =============================================================================
# WHILE THIS RUNS: ask Copilot about the command below
#
# The run takes about 20 to 25 minutes. Open Copilot Chat (the chat icon in the sidebar)
# and put these to it, with this file open so it can see the command:
#
#   - Explain each parameter of this nextflow run command.
#   - This run uses --aligner star_salmon. What do STAR and Salmon each do?
#     Why two tools rather than one?
#   - Human genes are spliced. Where in this command is that fact accounted for?
#   - --fasta and --gtf point to a 5 Mb slice of chromosome 19, not the whole
#     genome. What does that do to the share of reads that map, and why is it
#     acceptable for a demonstration?
#   - What does -profile docker change about how the pipeline runs?
#
# A profile is a named bundle of settings that lives inside the pipeline itself,
# not in our files, so the last question is really asking Copilot to read
# nf-core's own configuration.
#
# Check every answer against this script, the config files beside it, and the
# course book. An AI assistant answers with the same confidence whether it knows
# or is guessing, and you are the one who has to tell the difference.
# =============================================================================

nextflow run 'https://github.com/nf-core/rnaseq' \
    -r 3.27.0 \
    -profile docker \
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
