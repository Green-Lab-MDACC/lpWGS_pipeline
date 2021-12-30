#!/bin/bash
Sample_ID="DG520"
Sample_ID_R1="${Sample_ID}m22_R1"
Sample_ID_R2="${Sample_ID}m22_R2"
# mkdir ./data/${Sample_ID}

# # Run FastQC
# fastqc ./data/FASTQ/$Sample_ID_R1.fastq.gz
# fastqc ./data/FASTQ/$Sample_ID_R2.fastq.gz

# # Trim Reads
# java -jar ./programs/Trimmomatic-0.39/trimmomatic-0.39.jar PE -phred33 \
# ./data/FASTQ/$Sample_ID_R1.fastq.gz ./data/FASTQ/$Sample_ID_R2.fastq.gz \
# ./data/${Sample_ID}/${Sample_ID_R1}_P.fastq.gz ./data/${Sample_ID}/${Sample_ID_R1}_S.fastq.gz \
# ./data/${Sample_ID}/${Sample_ID_R2}_P.fastq.gz ./data/${Sample_ID}/${Sample_ID_R2}_S.fastq.gz \
# ILLUMINACLIP:./programs/Trimmomatic-0.39/adapters/TruSeq3-PE-2.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

# #Align Reads to hg19 genome
# bwa mem -t 4 -R "@RG\tPL:ILLUMINA\tSM:${Sample_ID}" ./data/hg19/genome.fa ./data/${Sample_ID}/${Sample_ID_R1}_P.fastq.gz ./data/${Sample_ID}/${Sample_ID_R2}_P.fastq.gz | samtools view -S -b - > ./data/${Sample_ID}/$Sample_ID.bam
# samtools sort -O bam -@ 10 -o ./data/${Sample_ID}/${Sample_ID}.sorted.bam ./data/${Sample_ID}/${Sample_ID}.bam

# #Deduplicate w/ picard and index
# java -jar $PWD/programs/picard.jar MarkDuplicates REMOVE_DUPLICATES=true I=$PWD/data/${Sample_ID}/$Sample_ID.sorted.bam O=$PWD/data/${Sample_ID}/$Sample_ID.sorted_dedup.bam M=$PWD/data/${Sample_ID}/$Sample_ID.sorted_markdup_metrics.txt
# samtools index $PWD/data/${Sample_ID}/$Sample_ID.sorted_dedup.bam

# #Perform indel realignment using GATK3 RealignerTargetCreator and IndelRealigner
# java -jar $PWD/programs/GenomeAnalysisTK.jar -T RealignerTargetCreator -R $PWD/data/hg19/ucsc.hg19.fasta  -I $PWD/data/${Sample_ID}/$Sample_ID.sorted_dedup.bam -known $PWD/data/hg19/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf.gz -known $PWD/data/hg19/1000G_phase1.indels.hg19.sites.vcf.gz -o $PWD/data/${Sample_ID}/$Sample_ID.sorted_dedup.IndelRealigner.intervals
# java -jar $PWD/programs/GenomeAnalysisTK.jar -T IndelRealigner -R $PWD/data/hg19/ucsc.hg19.fasta -I $PWD/data/${Sample_ID}/$Sample_ID.sorted_dedup.bam -known $PWD/data/hg19/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf.gz -known $PWD/data/hg19/1000G_phase1.indels.hg19.sites.vcf.gz --targetIntervals $PWD/data/${Sample_ID}/$Sample_ID.sorted_dedup.IndelRealigner.intervals -o $PWD/data/${Sample_ID}/$Sample_ID.sorted_dedup_realign.bam

# #Perform BQSR
# java -jar $PWD/programs/GenomeAnalysisTK.jar -T BaseRecalibrator -R $PWD/data/hg19/ucsc.hg19.fasta -I $PWD/data/${Sample_ID}/${Sample_ID}.sorted_dedup_realign.bam --knownSites $PWD/data/hg19/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf.gz --knownSites $PWD/data/hg19/1000G_phase1.indels.hg19.sites.vcf.gz --knownSites $PWD/data/hg19/dbsnp_138.hg19.vcf.gz -o $PWD/data/${Sample_ID}/$Sample_ID.sorted_dedup_realign.recal_data.table
# java -jar $PWD/programs/GenomeAnalysisTK.jar -T PrintReads -R $PWD/data/hg19/ucsc.hg19.fasta -I $PWD/data/${Sample_ID}/${Sample_ID}.sorted_dedup_realign.bam --BQSR $PWD/data/${Sample_ID}/$Sample_ID.sorted_dedup_realign.recal_data.table -o $PWD/data/${Sample_ID}/${Sample_ID}.sorted_dedup_realign_BQSR.bam

#Perform CopywriteR
R -e "library(CopywriteR)" \
-e "Sample_ID <- '${Sample_ID}'" \
-e "bam_location <- file.path(getwd(),'data',Sample_ID, paste(Sample_ID,'sorted_dedup_realign_BQSR.bam',sep='.'))" \
-e "sample.control <- data.frame(bam_location, bam_location)" \
-e "bp.param <- SnowParam(workers = 12, type = 'SOCK')" \
-e "CopywriteR(sample.control = sample.control, destination.folder=file.path(getwd(),'data',Sample_ID), reference.folder= file.path(getwd(),'data','hg19','hg19_100kb_chr'), bp.param)" \
-e "plotCNA(destination.folder = file.path(getwd(),'data',Sample_ID))"

#Extract seg file
R -e "Sample_ID <- '${Sample_ID}'" \
-e "load(file.path(getwd(),'data',Sample_ID,'CNAprofiles','segment.Rdata'))" \
-e "write.csv(segment.CNA.object[['output']], file = file.path(getwd(),'data',Sample_ID,'CNAprofiles','${Sample_ID}.csv'))"

#Run readCounter
cd $PWD/programs/hmmcopy_utils
cmake $PWD/programs/hmmcopy_utils
make
cd .. 
cd ..
$PWD/programs/hmmcopy_utils/bin/readCounter --window 1000000 --quality 20 $PWD/data/${Sample_ID}/${Sample_ID}.sorted_dedup_realign_BQSR.bam > $PWD/data/${Sample_ID}/${Sample_ID}.wig --chromosome chr1,chr2,chr3,chr4,chr5,chr6,chr7,chr8,chr9,chr10,chr11,chr12,chr13,chr14,chr15,chr16,chr17,chr18,chr19,chr20,chr21,chr22,chrX,chrY

#Run IchorCNA
Rscript $PWD/programs/ichorCNA/scripts/runIchorCNA.R --id ${Sample_ID} --WIG $PWD/data/${Sample_ID}/${Sample_ID}.wig --outDir $PWD/data/${Sample_ID} --gcWig $PWD/programs/ichorCNA/inst/extdata/gc_hg19_1000kb.wig --normal 'c(0.5, 0.85, 0.995, 0.999)' --libdir $PWD/programs/ichorCNA

#Modify seg file
python ./scripts/cnapp_prepper.py ${Sample_ID}