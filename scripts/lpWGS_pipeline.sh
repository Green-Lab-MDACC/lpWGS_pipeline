#!/bin/bash
Sample_ID="DG_517"
Sample_ID_R1="${Sample_ID}_R1"
Sample_ID_R2="${Sample_ID}_R2"
mkdir ./data/${Sample_ID}

# Run FastQC
fastqc ./data/FASTQ/$Sample_ID_R1.fastq.gz
fastqc ./data/FASTQ/$Sample_ID_R2.fastq.gz

# Trim Reads
java -jar ./programs/Trimmomatic-0.39/trimmomatic-0.39.jar PE -phred33 \
./data/FASTQ/$Sample_ID_R1.fastq.gz ./data/FASTQ/$Sample_ID_R2.fastq.gz \
./data/${Sample_ID}/${Sample_ID_R1}_P.fastq.gz ./data/${Sample_ID}/${Sample_ID_R1}_S.fastq.gz \
./data/${Sample_ID}/${Sample_ID_R2}_P.fastq.gz ./data/${Sample_ID}/${Sample_ID_R2}_S.fastq.gz \
ILLUMINACLIP:./Trimmomatic-0.39/adapters/TruSeq3-PE-2.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

#Align Reads to hg19 genome
bwa mem -t 4 -R "@RG\tPL:ILLUMINA\tID:HFNTGDRXY.1.TACGCTAC+CGTGTGAT\tPU:HFNTGDRXY.1.TACGCTAC+CGTGTGAT\tSM:${Sample_ID}" ./data/hg19/genome.fa ./data/${Sample_ID}/${Sample_ID_R1}_P.fastq.gz ./data/${Sample_ID}/${Sample_ID_R2}_P.fastq.gz | samtools view -S -b - > ./data/${Sample_ID}/$Sample_ID.bam
samtools sort -O bam -@ 10 -o ./data/${Sample_ID}/${Sample_ID}.sorted.bam ./data/${Sample_ID}/${Sample_ID}.bam

#Deduplicate w/ picard and index
java -jar $PWD/programs/picard.jar MarkDuplicates REMOVE_DUPLICATES=true I=$PWD/data/${Sample_ID}/$Sample_ID.sorted.bam O=$PWD/data/${Sample_ID}/$Sample_ID.sorted_dedup.bam M=$PWD/data/${Sample_ID}/$Sample_ID.sorted_markdup_metrics.txt
samtools index $PWD/data/${Sample_ID}/$Sample_ID.sorted_dedup.bam

#Perform indel realignment using GATK3 RealignerTargetCreator and IndelRealigner
java -jar $PWD/programs/GenomeAnalysisTK.jar -T RealignerTargetCreator -R $PWD/data/hg19/ucsc.hg19.fasta  -I $PWD/data/${Sample_ID}/$Sample_ID.sorted_dedup.bam -known $PWD/data/hg19/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf.gz -known $PWD/data/hg19/1000G_phase1.indels.hg19.sites.vcf.gz -o $PWD/data/${Sample_ID}/$Sample_ID.sorted_dedup.IndelRealigner.intervals
java -jar $PWD/programs/GenomeAnalysisTK.jar -T IndelRealigner -R $PWD/data/hg19/ucsc.hg19.fasta -I $PWD/data/${Sample_ID}/$Sample_ID.sorted_dedup.bam -known $PWD/data/hg19/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf.gz -known $PWD/data/hg19/1000G_phase1.indels.hg19.sites.vcf.gz --targetIntervals $PWD/data/${Sample_ID}/$Sample_ID.sorted_dedup.IndelRealigner.intervals -o $PWD/data/${Sample_ID}/$Sample_ID.sorted_dedup_realign.bam

#Perform BQSR
java -jar $PWD/programs/GenomeAnalysisTK.jar -T BaseRecalibrator -R $PWD/data/hg19/ucsc.hg19.fasta -I $PWD/data/${Sample_ID}/${Sample_ID}.sorted_dedup_realign.bam --knownSites $PWD/data/hg19/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf.gz --knownSites $PWD/data/hg19/1000G_phase1.indels.hg19.sites.vcf.gz --knownSites $PWD/data/hg19/dbsnp_138.hg19.vcf.gz -o $PWD/data/${Sample_ID}/$Sample_ID.sorted_dedup_realign.recal_data.table
java -jar $PWD/programs/GenomeAnalysisTK.jar -T PrintReads -R $PWD/data/hg19/ucsc.hg19.fasta -I $PWD/data/${Sample_ID}/${Sample_ID}.sorted_dedup_realign.bam --BQSR $PWD/data/${Sample_ID}/$Sample_ID.sorted_dedup_realign.recal_data.table -o $PWD/data/${Sample_ID}/${Sample_ID}.sorted_dedup_realign_BQSR.bam