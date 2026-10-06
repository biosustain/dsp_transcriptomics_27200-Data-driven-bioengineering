#!/usr/bin/env bash
# How the human demo FASTQ files were made
# =============================================================================
# The demo maps against a 5 Mb slice of chromosome 19, which is 0.16% of the
# genome. Reads taken at random from the whole transcriptome therefore almost
# never map: the first version of these files mapped 1.4%, which is below
# nf-core/rnaseq's --min_mapped_reads 5 threshold, so every sample was dropped
# with a "failed the 5% mapped threshold" banner at the end of the run.
#
# The fix is to pick reads that come from the region in the first place, rather
# than hoping random ones land there. These files now map 80 to 82 per cent.
#
# Run from the repository root. Needs Docker and about 5 GB of free disk; the
# full FASTQs are deleted again as soon as each sample has been filtered.
# =============================================================================
set -euo pipefail

BB="quay.io/biocontainers/bbmap:39.06--h92535d8_0"
OUT="data/seq_files_subsampled/PRJNA229998_GSE52778_human"
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

gunzip -c data/genome_files/human/chr19_GRCh38_48115444-53115443.fna.gz > "$WORK/slice.fna"

# SRR1039513 = N052611 dexamethasone, SRR1039512 = N052611 untreated
for SRR in SRR1039513 SRR1039512; do
    case "$SRR" in
        SRR1039513) SUB=003 ;;
        SRR1039512) SUB=002 ;;
    esac
    BASE="https://ftp.sra.ebi.ac.uk/vol1/fastq/SRR103/$SUB/$SRR"

    echo ">>> $SRR: downloading (about 2 to 3 GB)"
    curl -sL -o "$WORK/${SRR}_1.fastq.gz" "$BASE/${SRR}_1.fastq.gz"
    curl -sL -o "$WORK/${SRR}_2.fastq.gz" "$BASE/${SRR}_2.fastq.gz"

    # Keep pairs sharing a 31-mer with the slice. k-mer matching rather than
    # alignment: it takes half a minute instead of an hour, and for *choosing*
    # reads that is enough. Reads are 63 bp, so even one crossing an exon
    # junction has 31 bp on one side and is still caught.
    echo ">>> $SRR: selecting reads from the chr19 region"
    docker run --rm -v "$WORK:/d" "$BB" bbduk.sh -Xmx4g threads=4 \
        in1="/d/${SRR}_1.fastq.gz" in2="/d/${SRR}_2.fastq.gz" \
        ref=/d/slice.fna k=31 \
        outm="/d/m_1.fastq.gz" outm2="/d/m_2.fastq.gz" \
        stats="/d/${SRR}_stats.txt" overwrite=t

    # About 2.4 to 2.8% of reads match, i.e. 400k to 700k pairs. Take 50k.
    echo ">>> $SRR: subsampling to 50,000 pairs"
    docker run --rm -v "$WORK:/d" "$BB" reformat.sh -Xmx2g \
        in1=/d/m_1.fastq.gz in2=/d/m_2.fastq.gz \
        out1="/d/${SRR}_1_sub_50k.fastq.gz" out2="/d/${SRR}_2_sub_50k.fastq.gz" \
        samplereadstarget=50000 sampleseed=42 overwrite=t

    cp "$WORK/${SRR}_1_sub_50k.fastq.gz" "$WORK/${SRR}_2_sub_50k.fastq.gz" "$OUT/"
    rm -f "$WORK/${SRR}"_[12].fastq.gz "$WORK"/m_[12].fastq.gz
    echo ">>> $SRR: done"
done

# Sanity check: what fraction of the selected reads actually map back?
# Expect roughly 80%. Anything near 1% means the selection did not work.
for SRR in SRR1039513 SRR1039512; do
    echo ">>> $SRR: mapping rate"
    docker run --rm -v "$PWD/$OUT:/r" -v "$WORK:/d" "$BB" bbmap.sh -Xmx4g threads=4 \
        ref=/d/slice.fna nodisk=t out=/dev/null \
        in1="/r/${SRR}_1_sub_50k.fastq.gz" in2="/r/${SRR}_2_sub_50k.fastq.gz" 2>&1 |
        grep -A2 '^Read 1 data:' | grep mapped
done

# -----------------------------------------------------------------------------
# NOT regenerated: SRR1039508, 509, 516, 517, 520, 521. Those six are still
# random subsamples and still map at about 1.4%. They are only referenced by
# samplesheet_PRJNA229998_subsampled.csv, which the class does not use - the
# notebooks start from the full count matrices under data/. Add their accessions
# to the loop above if they are ever needed.
# -----------------------------------------------------------------------------
