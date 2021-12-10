#!/usr/bin/R
R -e "library(CopywriteR)" \
-e "Sample_ID <- 'DG_517'" \
-e "bam_location <- file.path(getwd(),'data',Sample_ID, paste(Sample_ID,'sorted_dedup_realign_BQSR.bam',sep='.'))" \
-e "sample.control <- data.frame(bam_location, bam_location)" \
-e "bp.param <- SnowParam(workers = 12, type = 'SOCK')" \
-e "CopywriteR(sample.control = sample.control, destination.folder=file.path(getwd(),'data',Sample_ID), reference.folder= file.path(getwd(),'data','hg19','hg19_100kb_chr'), bp.param)" \
-e "plotCNA(destination.folder = file.path(getwd(),'data',Sample_ID))"
