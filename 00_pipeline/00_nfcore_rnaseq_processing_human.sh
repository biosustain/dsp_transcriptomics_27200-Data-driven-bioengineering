# Script to process RNA sequencing files — Human ASM (dexamethasone), Himes 2014
# =============================================================================
# PROVENANCE ONLY — this run has already been completed on Seqera/Azure.
# Kept here to document how the star_salmon output under
#   data/data-02-Homo_sapiens/hasapiens/star_salmon/
# was generated. You do NOT need to re-run this for the workshop.
# =============================================================================
#
# Eukaryotic dataset: aligner = star_salmon (STAR + Salmon), prokaryotic = false.
# Reference: RefSeq GRCh37 / hg19 (GCF_000001405.13), with gene_name as an extra
# GTF attribute — which is why the count matrix carries gene symbols.
#
# The actual run used Azure blob (az://) paths on Seqera. Those are recorded in
# the comment block below for reference; the repo itself only stores the
# downstream output needed for teaching.

# Due to too high computational load, this example uses downsampled read files (50 0000 reads each) and approximately 5 Mb of chromsome 19 as the reference. Two samples are processed only as example.


nextflow run 'https://github.com/nf-core/rnaseq' \
    -name 'hsapiens_PRJNA229998_GSE52778' \
    -r 3.26.0 \
    -profile docker \
    --aligner star_salmon \
    --input  '/workspaces/dsp_transcriptomics_27200-Data-driven-bioengineering/data/seq_files_subsampled/PRJNA229998_GSE52778_human/samplesheet_PRJNA229998_subsampled_2samples.csv' \
    --outdir '/workspaces/dsp_transcriptomics_27200-Data-driven-bioengineering/results/human/nfcore_rnaseq_processing_downsampled' \
    --fasta '/workspaces/dsp_transcriptomics_27200-Data-driven-bioengineering/data/genome_files/human/chr19_5Mb_GRCh37.fa.gz' \
    --gtf '/workspaces/dsp_transcriptomics_27200-Data-driven-bioengineering/data/genome_files/human/chr19_5Mb_GRCh37.gtf.gz' \
    --gtf_extra_attributes 'gene' \
    --gtf_group_features 'gene_id' \
    --featurecounts_feature_type 'exon' \
    --featurecounts_group_type 'transcript_biotype' \
    --remove_ribo_rna \
    --skip_biotype_qc \
    --skip_preseq \
    --skip_bbsplit \
    -c /workspaces/dsp_transcriptomics_27200-Data-driven-bioengineering/00_pipeline/custom.config

# -----------------------------------------------------------------------------
# Original Seqera/Azure run (for the record — not runnable from the repo):
#   input:  az://seqera/raw/teaching_bioengineering_08_Oct_2026/PRJNA229998_GSE52778/samplesheet_PRJNA229998.csv
#   outdir: az://seqera/results/teaching_bioengineering_08_Oct_2026/hsapiens_PRJNA229998_GSE52778_3Sept_E16_v326_all_samples/
#   fasta:  az://seqera/databases/ref-genomes/H_sapiens_GRCh37_hg19/GCF_000001405.13_GRCh37_genomic.fna.gz
#   gtf:    az://seqera/databases/ref-genomes/H_sapiens_GRCh37_hg19/GCF_000001405.13_GRCh37_genomic.gtf.gz
#   aligner: star_salmon | prokaryotic: false | remove_ribo_rna: true | skip_biotype_qc: true
# -----------------------------------------------------------------------------
