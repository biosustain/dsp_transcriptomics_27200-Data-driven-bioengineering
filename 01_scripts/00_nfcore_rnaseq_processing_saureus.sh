# Script to process RNA sequencing files — Staphylococcus aureus USA100

nextflow run 'https://github.com/nf-core/rnaseq' \
    -name 'saureus_usa100_PRJNA685119_GSE163153' \
    -r 3.23.0 \
    -profile prokaryotic,docker \
    --input  '/workspaces/dsp_transcriptomics_27200-Data-driven-bioengineering/data/seq_files_subsampled/PRJNA685119_GSE163153_saureus/usa100/samplesheet_PRJNA685119_usa100_subset_24h.csv' \
    --outdir '/workspaces/dsp_transcriptomics_27200-Data-driven-bioengineering/results/saureus_usa100_nfcore_processing_downsampled' \
    --fasta  '/workspaces/dsp_transcriptomics_27200-Data-driven-bioengineering/data/genome_files/saureus/usa100_NC_002745/GCF_000009645.1_ASM964v1_genomic.fna.gz' \
    --gtf    '/workspaces/dsp_transcriptomics_27200-Data-driven-bioengineering/data/genome_files/saureus/usa100_NC_002745/GCF_000009645.1_ASM964v1_genomic.gtf.gz' \
    -c /workspaces/dsp_transcriptomics_27200-Data-driven-bioengineering/01_scripts/custom.config

