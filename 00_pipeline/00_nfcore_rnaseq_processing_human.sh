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
