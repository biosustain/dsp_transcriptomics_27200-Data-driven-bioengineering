#!/usr/bin/env bash
# =============================================================================
# Build the small human demo dataset for the in-class nf-core/rnaseq run.
#
# RUN THIS ONCE, on a machine with disk and bandwidth. Students never run it:
# they get the small files it produces, which are committed to the repository.
#
# What it makes:
#   - a 5 Mb slice of chromosome 22, with the GTF for that slice
#   - four fastq pairs containing only reads that map inside the slice
#   - a samplesheet pointing at them
#
# Why a slice: STAR has to hold the genome index in memory. The whole human
# genome needs about 30 GB, which no Codespace has. Five megabases needs a few
# hundred MB, so the same pipeline runs in the room.
#
# Why "reads that map inside the slice" and not a random subsample: chr22 is
# about 1.6% of the genome, so random reads would give a ~1% mapping rate and a
# MultiQC report that looks broken. Students read that report, so it has to look
# like a real experiment.
#
# Needs: samtools, bgzip, curl, docker.
# =============================================================================
set -euo pipefail

# --- what to build ----------------------------------------------------------
CHR=22
START=37500000          # densest 5 Mb on chr22: 105 protein-coding genes
END=42500000
THREADS=4

# Two donors, untreated and dexamethasone, from Himes 2014 (PRJNA229998).
# Names must match data/data-02-Homo_sapiens/metadata/metadata.tsv.
declare -a RUNS=(
  "SRR1039520 N061011_untreated"
  "SRR1039521 N061011_dexamethasone"
  "SRR1039508 N61311_untreated"
  "SRR1039509 N61311_dexamethasone"
)

ROOT=$(git rev-parse --show-toplevel)
REF_DIR="$ROOT/data/genome_files/human_chr22_subset"
FQ_DIR="$ROOT/data/seq_files_subsampled/PRJNA229998_GSE52778_human"
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

HISAT2="quay.io/biocontainers/hisat2:2.2.1--h503566f_8"

mkdir -p "$REF_DIR" "$FQ_DIR"
echo "Working in $WORK"
echo "Region: ${CHR}:${START}-${END}  ($(( (END-START)/1000000 )) Mb)"
echo

# --- 1. reference slice -----------------------------------------------------
echo "[1/5] Reference slice"
curl -sL -o "$WORK/chr.fa.gz" \
  "https://ftp.ensembl.org/pub/grch37/current/fasta/homo_sapiens/dna/Homo_sapiens.GRCh37.dna.chromosome.${CHR}.fa.gz"
gzip -dc "$WORK/chr.fa.gz" > "$WORK/chr.fa"
samtools faidx "$WORK/chr.fa"
# faidx writes a header like ">22:37500000-42500000"; rename it to plain "22"
# so it matches the GTF seqname below. Coordinates in the new file start at 1,
# which is why the GTF has to be shifted by the same amount.
samtools faidx "$WORK/chr.fa" "${CHR}:${START}-${END}" \
  | sed "1s/.*/>${CHR}/" > "$WORK/subset.fa"
bgzip -c "$WORK/subset.fa" > "$REF_DIR/chr${CHR}_subset.fa.gz"
echo "      $(du -h "$REF_DIR/chr${CHR}_subset.fa.gz" | cut -f1) written"

# --- 2. matching GTF --------------------------------------------------------
echo "[2/5] Annotation for the slice"
curl -sL -o "$WORK/full.gtf.gz" \
  "https://ftp.ensembl.org/pub/grch37/current/gtf/homo_sapiens/Homo_sapiens.GRCh37.87.gtf.gz"
# Keep only features lying entirely inside the window, then shift coordinates so
# position 1 of the new FASTA is position 1 of the annotation. Partly-overlapping
# features are dropped rather than truncated, which would make invalid exons.
gzip -dc "$WORK/full.gtf.gz" \
  | awk -v FS='\t' -v OFS='\t' -v c="$CHR" -v s="$START" -v e="$END" \
      '$0 ~ /^#/ {next} $1==c && $4>=s && $5<=e { $4=$4-s+1; $5=$5-s+1; print }' \
  > "$WORK/subset.gtf"
bgzip -c "$WORK/subset.gtf" > "$REF_DIR/chr${CHR}_subset.gtf.gz"
echo "      $(awk '$3=="gene"' "$WORK/subset.gtf" | wc -l | tr -d ' ') genes, \
$(du -h "$REF_DIR/chr${CHR}_subset.gtf.gz" | cut -f1)"

# --- 3. index the slice -----------------------------------------------------
echo "[3/5] HISAT2 index"
docker run --rm -v "$WORK":/w -w /w "$HISAT2" \
  hisat2-build -p "$THREADS" subset.fa idx >/dev/null 2>&1
echo "      done"

# --- 4. select the reads ----------------------------------------------------
echo "[4/5] Reads (this is the slow part)"
for entry in "${RUNS[@]}"; do
  run=${entry%% *}; name=${entry##* }
  echo "      $name ($run)"

  urls=$(curl -s "https://www.ebi.ac.uk/ena/portal/api/filereport?accession=${run}&result=read_run&fields=fastq_ftp&format=tsv" | tail -1)
  r1=$(echo "$urls" | tr ';' '\n' | grep '_1.fastq.gz$' | head -1)
  r2=$(echo "$urls" | tr ';' '\n' | grep '_2.fastq.gz$' | head -1)
  curl -sL -o "$WORK/r1.fq.gz" "https://$r1"
  curl -sL -o "$WORK/r2.fq.gz" "https://$r2"

  # Align, keep only pairs where both mates mapped (-f 3), name-sort so the
  # fastq pair comes out in step, then write the two files back out.
  docker run --rm -v "$WORK":/w -w /w "$HISAT2" \
    hisat2 -p "$THREADS" -x idx -1 r1.fq.gz -2 r2.fq.gz -S aln.sam 2> "$WORK/${name}.hisat2.log"
  samtools view -@ "$THREADS" -b -f 3 "$WORK/aln.sam" \
    | samtools sort -n -@ "$THREADS" -o "$WORK/aln.bam" -
  samtools fastq -@ "$THREADS" \
    -1 "$FQ_DIR/${name}_1.fastq.gz" -2 "$FQ_DIR/${name}_2.fastq.gz" \
    -0 /dev/null -s /dev/null -n "$WORK/aln.bam"

  rate=$(grep 'overall alignment rate' "$WORK/${name}.hisat2.log" | awk '{print $1}')
  echo "        kept $(du -h "$FQ_DIR/${name}_1.fastq.gz" | cut -f1) per mate, region alignment rate $rate"
  rm -f "$WORK"/r1.fq.gz "$WORK"/r2.fq.gz "$WORK"/aln.sam "$WORK"/aln.bam
done

# --- 5. samplesheet ---------------------------------------------------------
echo "[5/5] Samplesheet"
SHEET="$FQ_DIR/samplesheet_human_chr${CHR}_subset.csv"
echo "sample,fastq_1,fastq_2,strandedness" > "$SHEET"
for entry in "${RUNS[@]}"; do
  name=${entry##* }
  echo "${name},${FQ_DIR}/${name}_1.fastq.gz,${FQ_DIR}/${name}_2.fastq.gz,auto" >> "$SHEET"
done

echo
echo "Done."
echo "  reference : $REF_DIR"
echo "  reads     : $FQ_DIR   ($(du -sh "$FQ_DIR" | cut -f1) total)"
echo "  samplesheet: $SHEET"
echo
echo "Remember: custom.config needs --genomeSAindexNbases 10 for a genome this"
echo "small, or STAR will build an index that maps nothing. See custom.config."
