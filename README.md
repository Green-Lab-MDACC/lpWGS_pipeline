# lpWGS_pipeline

Documentation of pipeline for processing paired end reads of lpWGS data.

![image](https://user-images.githubusercontent.com/92883998/144877994-9abf667d-aca0-406d-bf32-1c8798f21a4c.png)


# Required Packages

fastqc https://www.bioinformatics.babraham.ac.uk/projects/fastqc/

picard https://github.com/broadinstitute/picard

bwa http://bio-bwa.sourceforge.net/bwa.shtml

trimmomatic http://www.usadellab.org/cms/?page=trimmomatic

samtools http://samtools.sourceforge.net/

GATK3: https://gatk.broadinstitute.org/hc/en-us


# Usage
Requirements:

Sample_ID name

${Sample_ID}_R1.fastq.gz

${Sample_ID}_R2.fastq.gz

ucsc.hg_19.fasta reference genome

genome.fa bwa index reference genome

hg19 known sites (from ucsc):

1000G_phase1.indels.hg19.sites.vcf

dbsnp_138.hg19.vcf

Mills_and_1000G_gold_standard.indels.hg19.sites.vcf

CopywriteR Mapping Folder (provided): hg19_100kb_chr


Run ```lPWGS_pipeline.sh```  after specifying ```Sample_ID```, adding ```${Sample_ID}_R1.fastq.gz```  and  ```${Sample_ID}_R2.fastq.gz```  to data folder, adding the bwa index output of ```genome.fa```, ```ucsc.hg_19.fasta```, and hg19 known-sites to the hg19 folder in the hg19 resource bundle from GATK gs://gatk-legacy-bundles

Run ``copywriter.sh`` after specifying ```Sample_ID``

# Pipeline Description
FASTQC generated from FASTQ files for paired-end reads (R1 & R2) using ```fastqc``` for <Sample_ID>

    fastqc /path/to/<Sample_ID_R1>.fastq.gz
    fastqc /path/to/<Sample_ID_R2>.fastq.gz

Quality trimming and adapter clipping using ```Trimmomatic``` for FASTQ files <Sample_ID_R1> & <Sample_ID_R2>

    java -jar /path/to/trimmomatic-0.39.jar PE -phred33 /path/to/<Sample_ID_R1>.fastq.gz /path/to/<Sample_ID_R2>.fastq.gz
    /path/to/<Sample_ID_R1_P>.fastq.gz /path/to/<Sample_ID_R1_S>.fastq.gz /path/to/<Sample_ID_R2_P>.fastq.gz /path/to/<Sample_ID_R2_S>.fastq.gz
    ILLUMINACLIP:/path/to/adapters/TruSeq3-PE-2.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

Align paired reads to hg19 genome and convert .FASTQ to .BAM using ```bwa mem``` and ```samtools view```

    bwa mem -t 4 hg19.fasta /path/to/<Sample_ID_R1_P>.fastq.gz /path/to/<Sample_ID_R2_P>.fastq.gz | samtools view -S -b - > /path/to/<Sample_ID>.bam
    
Coordinate sort .BAM file using ```samtools sort```

    samtools sort -O bam -@ 10 -o /path/to/<Sample_ID>.sorted.bam  /path/to/<Sample_ID>.bam

Deduplicate sorted bam file (sorted.bam) using ```picard MarkDuplicates``` 

    java -jar /path/to/picard.jar MarkDuplicates REMOVE_DUPLICATES=true I=/path/to/<Sample_ID>.sorted.bam O=/path/to/<Sample_ID>.sorted_dedup.bam M=/path/to/<Sample_ID>.sorted_markdup_metrics.txt
    
Create index of deduplicated and sorted bam file (sorted_dedup.bam) using ```samtools index```

    samtools index /rsrch3/home/lym_myl_rsch/bnsugg/Test_Pipeline/DG_517.sorted_dedup.bam

From here there are two options using GATK3 or GATK4.

## GATK3
Perform indel realignment using ```GATK3 GenomeAnalysisTK RealignerTargetCreator and IndelRealigner```

    java -jar /rsrch3/home/lym_myl_rsch/bnsugg/Test_Pipeline/GenomeAnalysisTK.jar -T RealignerTargetCreator -R /path/to/hg19.fasta -I /path/to/<Sample_ID>.sorted_dedup.bam -known /path/to/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf.gz -known /path/to/1000G_phase1.indels.hg19.sites.vcf.gz -o /path/to/DG_517.sorted_dedup.IndelRealigner.intervals
    
    java -jar /rsrch3/home/lym_myl_rsch/bnsugg/Test_Pipeline/GenomeAnalysisTK.jar -T IndelRealigner -R /path/to/hg19.fasta -I /path/to/<Sample_ID>.sorted_dedup.bam -known /path/to/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf.gz -known /path/to/1000G_phase1.indels.hg19.sites.vcf.gz --targetIntervals /path/to/DG_517.sorted_dedup.IndelRealigner.intervals -o /path/to/<Sample_ID>.sorted_dedup_realign.bam

Run base quality score recalibration using ```GATK3 BaseRecalibrator```:

    java -jar /path/to/GenomeAnalysisTK.jar -T BaseRecalibrator -R /path/to/ucsc.hg19.fasta -I /path/to/<Sample_ID>.sorted_dedup_realign.bam --knownSites /path/to/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf.gz --knownSites /path/to/1000G_phase1.indels.hg19.sites.vcf.gz --knownSites /path/to/dbsnp_138.hg19.vcf.gz -o /rsrch3/home/lym_myl_rsch/bnsugg/Test_Pipeline/<Sample_ID>.sorted_dedup_realign.recal_data.table

    java -jar /rsrch3/home/lym_myl_rsch/bnsugg/Test_Pipeline/GenomeAnalysisTK.jar -T PrintReads -R /path/to/hg19.fasta -I /path/to/<Sample_ID>.sorted_dedup_realign.bam --BQSR /path/to/Test_Pipeline/<Sample_ID>.sorted_dedup_realign.recal_data.table -o /path/to/<Sample_ID>.sorted_dedup_realign_BQSR.bam


## GATK4

Perform indel realignment using ```GATK4 HaplotypeCaller```

    gatk HaplotypeCaller -R /path/to/hg19.fasta -I /path/to/<Sample_ID>.sorted_dedup.bam -O /path/to/<Sample_ID>.sorted_dedup.IndelRealigner.vcf.gz -bamout /path/to/<Sample_ID>.sorted_dedup_realign.bam
    
Run base quality score recalibration using ```GATK4 BaseRecalibrator```

    gatk BaseRecalibrator -R /path/to/hg19.fasta -I /path/to/<Sample_ID>.sorted_dedup_realign.bam --known-sites /path/to/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf.gz --known-sites /path/to/1000G_phase1.indels.hg19.sites.vcf.gz --known-sites /path/to/dbsnp_138.hg19.vcf.gz -O /path/to/<Sample_ID>.sorted_dedup_realign.recal_data.table

Run ```GATK4 Print Reads```

    gatk PrintReads -R /path/to/hg19.fasta -I /path/to/<Sample_ID>.sorted_dedup_realign.bam --BQSR /path/to/<Sample_ID>.sorted_dedup_realign.recal_data.table -O /path/to/<Sample_ID>.sorted_dedup_realign_BQSR.bam


## CopywriteR

Run ```CopywriteR```

    R -e "library(<Sample_ID>)" -e "Sample_ID <- '<Sample_ID>'" -e "bam_location <- file.path(getwd(),'data',Sample_ID, paste(Sample_ID,'sorted_dedup_realign_BQSR.bam',sep='.'))" -e "sample.control <- data.frame(bam_location, bam_location)" -e "bp.param <- SnowParam(workers = 12, type = 'SOCK')" -e "CopywriteR(sample.control = sample.control, destination.folder=file.path(getwd(),'data',Sample_ID), reference.folder= file.path(getwd(),'data','hg19','hg19_100kb_chr'), bp.param)"
