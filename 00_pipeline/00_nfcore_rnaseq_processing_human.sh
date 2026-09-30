# Script to process RNA sequencing files — Human ASM (dexamethasone), Himes 2014
# =============================================================================
# PROVENANCE ONLY — this run has already been completed on the DTU HPC.
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

# Due to too high computational load, this example uses downsampled read files (50 0000 reads each) and approximately 5 Mb of chromsome 19 as the reference. Two samples are processed only as example.


nextflow run 'https://github.com/nf-core/rnaseq' \
    -name 'onesample_hsapiens_PRJNA229998_GSE52778' \
    -r 3.27.0 \
    -profile docker \
    --aligner star_salmon \
    --input  '/workspaces/dsp_transcriptomics_27200-Data-driven-bioengineering/data/seq_files_subsampled/PRJNA229998_GSE52778_human/samplesheet_PRJNA229998_subsampled_1sample.csv' \
    --outdir '/workspaces/dsp_transcriptomics_27200-Data-driven-bioengineering/results/human/nfcore_rnaseq_processing_downsampled' \
    --fasta '/workspaces/dsp_transcriptomics_27200-Data-driven-bioengineering/data/genome_files/human/chr19_GRCh38_48115444-53115443.fna.gz' \
    --gtf '/workspaces/dsp_transcriptomics_27200-Data-driven-bioengineering/data/genome_files/human/chr19_GRCh38_48115444-53115443.gtf.gz' \
    --gencode \
    --gtf_group_features 'gene_id' \
    --featurecounts_feature_type 'exon' \
    --skip_markduplicates \
    --skip_biotype_qc \
    --skip_preseq \
    --skip_bbsplit \
    -c /workspaces/dsp_transcriptomics_27200-Data-driven-bioengineering/00_pipeline/custom.config

# -----------------------------------------------------------------------------
# Full run on the DTU HPC (for the record — not runnable from the repo):
#   nf-core/rnaseq 3.27.0, -profile conda, LSF; 8 samples (dexamethasone + untreated), FASTQs from ENA
#   fasta:  GRCh38.primary_assembly.genome.fa            (GENCODE release 50)
#   gtf:    gencode.v50.primary_assembly.annotation.gtf  (GENCODE release 50)
#   aligner: star_salmon | gencode: true | remove_ribo_rna: true
# -----------------------------------------------------------------------------
