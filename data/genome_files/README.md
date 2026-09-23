# Sources of genome files

Reference genomes and annotations used in this course, all from NCBI RefSeq.

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

## Homo sapiens

GRCh37 (hg19), the assembly used in the original paper (accession GCF_000001405.13).
Annotation only, since the counts were produced before the course:

```
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/405/GCF_000001405.13_GRCh37/GCF_000001405.13_GRCh37_genomic.gtf.gz
```
