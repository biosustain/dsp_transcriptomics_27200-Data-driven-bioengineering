  ## Script to sub-sample 50 000 reads of fastq files randomly
  # Reduces the size of fastq files and thus allows processing in the training environment
  # Use sektk (https://github.com/lh3/seqtk); keep random seeds constant for both fastq files: -s100)
  
  seqtk sample -s100 SRR13251347_1.fastq.gz 50000 | gzip > SRR13251347_1_sub_50k.fastq.gz
  seqtk sample -s100 SRR13251347_2.fastq.gz 50000 | gzip > SRR13251347_2_sub_50k.fastq.gz
  
  seqtk sample -s100 SRR13251344_1.fastq.gz 50000 | gzip > SRR13251344_1_sub_50k.fastq.gz
  seqtk sample -s100 SRR13251344_2.fastq.gz 50000 | gzip > SRR13251344_2_sub_50k.fastq.gz
  
  seqtk sample -s100 SRR13251345_1.fastq.gz 50000 | gzip > SRR13251345_1_sub_50k.fastq.gz
  seqtk sample -s100 SRR13251345_2.fastq.gz 50000 | gzip > SRR13251345_2_sub_50k.fastq.gz
  
  seqtk sample -s100 SRR13251301_1.fastq.gz 50000 | gzip > SRR13251301_1_sub_50k.fastq.gz
  seqtk sample -s100 SRR13251301_2.fastq.gz 50000 | gzip > SRR13251301_2_sub_50k.fastq.gz
  
  seqtk sample -s100 SRR13251302_1.fastq.gz 50000 | gzip > SRR13251302_1_sub_50k.fastq.gz
  seqtk sample -s100 SRR13251302_2.fastq.gz 50000 | gzip > SRR13251302_2_sub_50k.fastq.gz
  
  seqtk sample -s100 SRR13251300_1.fastq.gz 50000 | gzip > SRR13251300_1_sub_50k.fastq.gz
  seqtk sample -s100 SRR13251300_2.fastq.gz 50000 | gzip > SRR13251300_2_sub_50k.fastq.gz
  
  
  
  

  
