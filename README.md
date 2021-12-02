# lpWGS_pipeline

Documentation of pipeline for processing lpWGS data.

# Required Packages

fastqc https://www.bioinformatics.babraham.ac.uk/projects/fastqc/

picard https://github.com/broadinstitute/picard

bwa http://bio-bwa.sourceforge.net/bwa.shtml

trimmomatic http://www.usadellab.org/cms/?page=trimmomatic

samtools http://samtools.sourceforge.net/

GATK: https://gatk.broadinstitute.org/hc/en-us


# Usage
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
    
Perform indel realignment using ```GATK3 GenomeAnalysisTK```

    java -jar /rsrch3/home/lym_myl_rsch/bnsugg/Test_Pipeline/GenomeAnalysisTK.jar -T RealignerTargetCreator -R /rsrch3/home/lym_myl_rsch/bnsugg/Test_Pipeline/hg19_bundle/hg19.fasta -I /rsrch3/home/lym_myl_rsch/bnsugg/Test_Pipeline/DG_517.sorted_dedup.bam -known /rsrch3/home/lym_myl_rsch/bnsugg/Test_Pipeline/hg19_bundle/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf.gz -known /rsrch3/home/lym_myl_rsch/bnsugg/Test_Pipeline/hg19_bundle/1000G_phase1.indels.hg19.sites.vcf.gz -o /rsrch3/home/lym_myl_rsch/bnsugg/Test_Pipeline/DG_517.sorted_dedup.IndelRealigner.intervals
    
    java -jar /rsrch3/home/lym_myl_rsch/bnsugg/Test_Pipeline/GenomeAnalysisTK.jar -T IndelRealigner -R /rsrch3/home/lym_myl_rsch/bnsugg/Test_Pipeline/hg19_bundle/hg19.fasta -I /rsrch3/home/lym_myl_rsch/bnsugg/Test_Pipeline/DG_517.sorted_dedup.bam -known /rsrch3/home/lym_myl_rsch/bnsugg/Test_Pipeline/hg19_bundle/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf.gz -known /rsrch3/home/lym_myl_rsch/bnsugg/Test_Pipeline/hg19_bundle/1000G_phase1.indels.hg19.sites.vcf.gz --targetIntervals /rsrch3/home/lym_myl_rsch/bnsugg/Test_Pipeline/DG_517.sorted_dedup.IndelRealigner.intervals -o /rsrch3/home/lym_myl_rsch/bnsugg/Test_Pipeline/DG_517.sorted_dedup_realign.bam

Perform indel realignment using ```GATK4 HaplotypeCaller```

    gatk HaplotypeCaller -R /path/to/ucsc.hg19.fasta -I /path/to/<Sample_ID>.sorted_dedup.bam -O /path/to/<Sample_ID>.sorted_dedup.IndelRealigner.vcf.gz -bamout /path/to/<Sample_ID>.sorted_dedup_realign.bam
    
Run base quality score recalibration using ```GATK4 BaseRecalibrator```

    gatk BaseRecalibrator -R /path/to/ucsc.hg19.fasta -I /path/to/DG_517.sorted_dedup_realign.bam --knownSites /path/to/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf.gz --knownSites /path/to/1000G_phase1.indels.hg19.sites.vcf.gz --knownSites /path/to/dbsnp_138.hg19.vcf.gz -o /path/to/DG_517.sorted_dedup_realign.recal_data.table

Run ```GATK4 Print Reads```

    gatk PrintReads -R /path/to/ucsc.hg19.fasta -I /path/to/DG_517.sorted_dedup_realign.bam --BQSR /path/to/DG_517.sorted_dedup_realign.recal_data.table -o /path/to/DG_517.sorted_dedup_realign_BQSR.bam
