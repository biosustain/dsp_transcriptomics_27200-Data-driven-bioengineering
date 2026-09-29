#!/usr/bin/env python3

# The script was generated using Claude and the following prompt: 
# "On chr19, select the sequence with the highest density of exons within a total of approximately 5 million consecutive base pairs. Use the gtf file GCF_000001405.13_GRCh37_genomic.gtf.gz for this. Generate a new gtf.gz file with selected genes and exons. Then use this information to select approximately 5 million base pairs fom chr19 using file chr19_GRCh37.fa.gz. Save it as a new fna.gz file. Make sure that index positions between gtf file and the newly generated subsequence of chromsome 19 are matching. Save everything in a folder called gtf_density_exons"

"""Find the ~5 Mb window of chr19 (GRCh37) with the most exons, subset the
RefSeq GTF to it and extract the matching sequence, re-indexed to position 1.

Exon density:
  * exons are counted as UNIQUE intervals (start, end, strand), so an exon
    shared by several transcripts of a gene counts once
  * only exons of genes whose full extent (min start / max end over all their
    features) lies inside the window count, and the whole gene is kept, so
    no transcript is truncated
  * window length is fixed at WINDOW bp; the score only changes when a gene
    enters or leaves, so every gene start is tested as a window start
  * ties: more genes first, then the leftmost window

Re-indexing (GTF and FASTA both 1-based, inclusive):
  new = old - (START - 1)
"""
import gzip
import re
from collections import defaultdict
from pathlib import Path

HERE = Path(__file__).resolve().parent
FASTA_IN = HERE.parent / "chr19_GRCh37.fa.gz"
GTF_IN = HERE.parent / "GCF_000001405.13_GRCh37_genomic.gtf.gz"
CHROM = "NC_000019.9"
WINDOW = 5_000_000

gid_re = re.compile(r'gene_id "([^"]*)"')

# ---- read chr19 GTF lines, grouped by gene ----
genes = defaultdict(list)
headers = []
with gzip.open(GTF_IN, "rt") as fh:
    for line in fh:
        if line.startswith("#"):
            headers.append(line)
            continue
        f = line.rstrip("\n").split("\t")
        if f[0] == CHROM:
            genes[gid_re.search(f[8]).group(1)].append(f)

extent = {}
exons = {}                                  # gene_id -> set of unique exons
for gid, feats in genes.items():
    extent[gid] = (min(int(f[3]) for f in feats), max(int(f[4]) for f in feats))
    exons[gid] = {(int(f[3]), int(f[4]), f[6]) for f in feats if f[2] == "exon"}

# ---- chromosome length ----
with gzip.open(FASTA_IN, "rt") as fh:
    assert fh.readline()[1:].split()[0] == CHROM
    seq = "".join(line.strip() for line in fh)
chrom_len = len(seq)

# ---- scan windows ----
best = None
for s in sorted({lo for lo, _ in extent.values()}):
    s = min(s, chrom_len - WINDOW + 1)
    e = s + WINDOW - 1
    inside = [g for g, (lo, hi) in extent.items() if lo >= s and hi <= e]
    uniq = set().union(*(exons[g] for g in inside)) if inside else set()
    key = (len(uniq), len(inside), -s)
    if best is None or key > best[0]:
        best = (key, s, e, set(inside))

(n_exons, n_genes, _), START, END, kept_ids = best
OFFSET = START - 1
NEW_NAME = f"{CHROM}_{START}_{END}"
stem = f"chr19_GRCh37_{START}-{END}"

# ---- FASTA ----
sub = seq[START - 1:END]
assert len(sub) == WINDOW
n_count = sub.upper().count("N")
with open(HERE / f"{stem}.fna", "w") as out:
    out.write(f">{NEW_NAME} {CHROM}:{START}-{END} GRCh37 exon-dense window\n")
    for i in range(0, len(sub), 60):
        out.write(sub[i:i + 60] + "\n")

# ---- GTF ----
kept = [f for g in kept_ids for f in genes[g]]
kept.sort(key=lambda f: (int(f[3]), -int(f[4])))
with gzip.open(HERE / f"{stem}.gtf.gz", "wt") as out:
    out.writelines(headers)
    out.write(f"#!subset {CHROM}:{START}-{END} (most unique exons per {WINDOW} bp); "
              f"new = old - {OFFSET}\n")
    for f in kept:
        f = f.copy()
        f[0] = NEW_NAME
        f[3] = str(int(f[3]) - OFFSET)
        f[4] = str(int(f[4]) - OFFSET)
        out.write("\t".join(f) + "\n")

# ---- boundary-crossing genes (not included) ----
with open(HERE / "dropped_boundary_genes.txt", "w") as out:
    out.write("gene_id\told_start\told_end\n")
    for g, (lo, hi) in sorted(extent.items(), key=lambda x: x[1]):
        if g not in kept_ids and hi >= START and lo <= END:
            out.write(f"{g}\t{lo}\t{hi}\n")

total_uniq = len(set().union(*exons.values()))
print(f"chr19: {len(extent)} genes, {total_uniq} unique exons, length {chrom_len}")
print(f"Best window: {CHROM}:{START}-{END}  unique exons={n_exons}  genes={n_genes}  N={n_count}")
print(f"Wrote {stem}.fna and {stem}.gtf.gz ({len(kept)} lines)")
