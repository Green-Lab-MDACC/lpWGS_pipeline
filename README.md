# lpWGS_pipeline

Documentation of pipeline for processing paired end reads of lpWGS data.

![image](https://user-images.githubusercontent.com/92883998/147773578-192c4ee8-14bf-4b53-ba6b-2e9edc585c03.png)


# Required Packages

fastqc https://www.bioinformatics.babraham.ac.uk/projects/fastqc/

picard https://github.com/broadinstitute/picard

bwa http://bio-bwa.sourceforge.net/bwa.shtml

trimmomatic http://www.usadellab.org/cms/?page=trimmomatic

samtools http://samtools.sourceforge.net/

GATK3: https://gatk.broadinstitute.org/hc/en-us

copywriteR: https://github.com/PeeperLab/CopywriteR

ichorCNA: https://github.com/broadinstitute/ichorCNA

CNApp: https://github.com/elifesciences-publications/CNApp


# Usage
Requirements and Required Format:

```Sample_ID```

```${Sample_ID}_R1.fastq.gz``` saved under "data/FASTQ"

```${Sample_ID}_R2.fastq.gz``` saved under "data/FASTQ"

```ucsc.hg_19.fasta```saved under "data/hg19"

```genome.fa``` bwa index reference genome saved under "data/hg19"

```1000G_phase1.indels.hg19.sites.vcf``` hg19 known sites saved under "data/hg19"

```dbsnp_138.hg19.vcf``` saved under  hg19 known sites "data/hg19"

```Mills_and_1000G_gold_standard.indels.hg19.sites.vcf```  hg19 known sites saved under "data/hg19"

```hg19_100kb_chr``` CopywriteR Mapping Folder (provided)


Run ```lPWGS_pipeline.sh```  after specifying ```Sample_ID```, adding ```${Sample_ID}_R1.fastq.gz```  and  ```${Sample_ID}_R2.fastq.gz```  to data folder, adding the bwa index output of ```genome.fa```, ```ucsc.hg_19.fasta```, and ```hg19 known-sites``` to the hg19 folder in the hg19 resource bundle from GATK gs://gatk-legacy-bundles


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

    samtools index /path/to/data/${Sample_ID}/$Sample_ID.sorted_dedup.bam


From here there are two options using GATK3 or GATK4.

## GATK3
Perform indel realignment using ```GATK3 GenomeAnalysisTK RealignerTargetCreator and IndelRealigner```

    java -jar /path/to/GenomeAnalysisTK.jar -T RealignerTargetCreator -R /path/to/hg19.fasta -I /path/to/<Sample_ID>.sorted_dedup.bam -known /path/to/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf.gz -known /path/to/1000G_phase1.indels.hg19.sites.vcf.gz -o /path/to/DG_517.sorted_dedup.IndelRealigner.intervals
    
    java -jar /path/to/GenomeAnalysisTK.jar -T IndelRealigner -R /path/to/hg19.fasta -I /path/to/<Sample_ID>.sorted_dedup.bam -known /path/to/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf.gz -known /path/to/1000G_phase1.indels.hg19.sites.vcf.gz --targetIntervals /path/to/DG_517.sorted_dedup.IndelRealigner.intervals -o /path/to/<Sample_ID>.sorted_dedup_realign.bam

Run base quality score recalibration using ```GATK3 BaseRecalibrator```:

    java -jar /path/to/GenomeAnalysisTK.jar -T BaseRecalibrator -R /path/to/ucsc.hg19.fasta -I /path/to/<Sample_ID>.sorted_dedup_realign.bam --knownSites /path/to/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf.gz --knownSites /path/to/1000G_phase1.indels.hg19.sites.vcf.gz --knownSites /path/to/dbsnp_138.hg19.vcf.gz -o /path/to/<Sample_ID>.sorted_dedup_realign.recal_data.table

    java -jar /path/to/GenomeAnalysisTK.jar -T PrintReads -R /path/to/hg19.fasta -I /path/to/<Sample_ID>.sorted_dedup_realign.bam --BQSR /path/to/Test_Pipeline/<Sample_ID>.sorted_dedup_realign.recal_data.table -o /path/to/<Sample_ID>.sorted_dedup_realign_BQSR.bam



## CopywriteR

Run ```CopywriteR```

    R -e "library(<Sample_ID>)" -e "Sample_ID <- '<Sample_ID>'" -e "bam_location <- file.path(getwd(),'data',Sample_ID, paste(Sample_ID,'sorted_dedup_realign_BQSR.bam',sep='.'))" -e "sample.control <- data.frame(bam_location, bam_location)" -e "bp.param <- SnowParam(workers = 12, type = 'SOCK')" -e "CopywriteR(sample.control = sample.control, destination.folder=file.path(getwd(),'data',Sample_ID), reference.folder= file.path(getwd(),'data','hg19','hg19_100kb_chr'), bp.param)" -e "plotCNA(destination.folder = file.path(getwd(),'data',Sample_ID))"

## ichorCNA

Run ```IchorCNA```

    script path/to/ichorCNA/scripts/runIchorCNA.R --id <Sample_ID> --WIG path/to/data/<Sample_ID>/<Sample_ID>.wig --outDir path/to/data/<Sample_ID> --gcWig path/to/programs/ichorCNA/inst/extdata/gc_hg19_1000kb.wig --normal 'c(0.5, 0.85, 0.995, 0.999)' --libdir /path/to/programs/ichorCNA

## CNApp

Run ```CNApp``` in browser with <Sample_ID>.CNApp__input.txt as input


