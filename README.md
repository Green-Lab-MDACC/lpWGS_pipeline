# lpWGS_pipeline

Documentation of pipeline for processing lpWGS data.

# Required Packages

fastqc https://www.bioinformatics.babraham.ac.uk/projects/fastqc/

picard https://github.com/broadinstitute/picard

bwa http://bio-bwa.sourceforge.net/bwa.shtml

trimmomatic http://www.usadellab.org/cms/?page=trimmomatic

# Usage
FASTQC generated from FASTQ files for paired-end reads (R1 & R2) using ```fastqc```

    fastqc /path/to/<Sample_ID_R1>.fastq.gz
    fastqc /path/to/<Sample_ID_R2>.fastq.gz

Quality trimming and adapter clipping using ```Trimmomatic``` for <Sample_ID_R1> & <Sample_ID_R2>

    java -jar /path/to/trimmomatic-0.39.jar PE -phred33 /path/to/<Sample_ID_R1>.fastq.gz /path/to/<Sample_ID_R2>.fastq.gz
    /path/to/<Sample_ID_R1_P>.fastq.gz /path/to/<Sample_ID_R1_S>.fastq.gz /path/to/<Sample_ID_R2_P>.fastq.gz /path/to/<Sample_ID_R2_S>.fastq.gz
    ILLUMINACLIP:/path/to/adapters/TruSeq3-PE-2.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

Align paired reads to hg19 genome and convert to .BAM using ```bwa mem``` and ```samtools view```

    bwa mem -t 4 hg19.fasta /path/to/<Sample_ID_R1_P>.fastq.gz /path/to/<Sample_ID_R2_P>.fastq.gz | samtools view -S -b - > /path/to/<Sample_ID>.bam
