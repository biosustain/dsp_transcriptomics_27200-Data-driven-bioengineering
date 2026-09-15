#!/bin/bash

# =============================================================================
# nf-core/differentialabundance run script
# Study: Human ASM — dexamethasone vs untreated (Himes 2014, PRJNA229998)
# Working directory: /workspaces/dsp_transcriptomics_27200-Data-driven-bioengineering
#
# NOTE: This track uses a simple ~ condition contrast (differentialabundance's
# standard model). The paired ~ donor + condition analysis lives in the DESeq2
# Rmd scripts (02_differential_expression_analysis.Rmd), which is the primary
# analysis for the workshop. Keep this as the optional/comparison track.
# =============================================================================

set -euo pipefail

nextflow run nf-core/differentialabundance \
    -r 1.5.0 \
    -profile docker \
    -params-file params_degs.json \
    --outdir results/human/differentialabundance
