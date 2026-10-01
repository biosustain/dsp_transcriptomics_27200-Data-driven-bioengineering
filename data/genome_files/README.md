# Sources of genome files

Reference genomes and annotations used in this course: NCBI RefSeq (*S. aureus*) and GENCODE (human).

## Staphylococcus aureus

**USA-100**, mapped to the N315 reference (accession GCF_000009645.1). This is
the genome used for the hands-on pipeline run, so both the sequence and the
annotation are here:

```
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/009/645/GCF_000009645.1_ASM964v1/GCF_000009645.1_ASM964v1_genomic.fna.gz
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/009/645/GCF_000009645.1_ASM964v1/GCF_000009645.1_ASM964v1_genomic.gtf.gz
```

**USA-500**, mapped to the USA300_FPR3757 reference (accession GCF_000013465.1).
The USA-500 isolate has no finished genome of its own, so the paper used its
closest relative and we do the same:

```
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/013/465/GCF_000013465.1_ASM1346v1/GCF_000013465.1_ASM1346v1_genomic.gtf.gz
```

Both live under `saureus/`, one folder per strain.

## Homo sapiens

GRCh38 primary assembly with the GENCODE release 50 primary-assembly annotation. Only the
chr19 demo slice (`human/chr19_GRCh38_48115444-53115443.*`) is stored here:

```
wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_50/GRCh38.primary_assembly.genome.fa.gz
wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_50/gencode.v50.primary_assembly.annotation.gtf.gz
```
