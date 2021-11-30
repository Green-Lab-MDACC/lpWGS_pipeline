# lpWGS_pipeline

Documentation of pipeline for processing lpWGS data.

# Required Packages

fastqc https://www.bioinformatics.babraham.ac.uk/projects/fastqc/

picard https://github.com/broadinstitute/picard

bwa http://bio-bwa.sourceforge.net/bwa.shtml

# Usage
FASTQC generated from FASTQ files for paired-end reads (R1 & R2) using ```fastqc```

    fastqc /path/to/<Sample_ID_R1>.fastq.gz
    fastqc /path/to/<Sample_ID_R2>.fastq.gz

Adapter Trimming using ```Trimmomatic```
