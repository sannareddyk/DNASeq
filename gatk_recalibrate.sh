#!/bin/bash

##script to run recalibration step of GATK

#PBS -l walltime=24:00:00
#PBS -l select=1:ncpus=8:mem=20gb
#PBS -M xx
#PBS -m ae
#PBS -j oe
#PBS -q xx

#load modules
module load samtools/0.1.18
module load gatk/3.5
module load java/jdk-7u25

JAVA_XMX=4800M
RTC_DATA_THREADS=2
SAMPLE=#sampleName
TARGET_FILE=path/to/targets.bed
INPUT_DIR=path/to/mutect/realign
OUTPUT_DIR=path/to/mutect/recalibrate

##recalibration
java -Xmx$JAVA_XMX -jar $GATK_HOME/GenomeAnalysisTK.jar \
   -T BaseRecalibrator \
   -R path/to/fasta/hs37d5.fa \
   -I $INPUT_DIR/$SAMPLE.realignedtogether.bam \
   -nct 8 \
   -knownSites path/to/GATK_resource_bundle/2.8/b37/dbsnp_138.b37.vcf \
   -knownSites path/to/GATK_resource_bundle/2.8/b37/1000G_phase1.indels.b37.vcf \
   -knownSites path/to/GATK_resource_bundle/2.8/b37/Mills_and_1000G_gold_standard.indels.b37.vcf \
   -o $OUTPUT_DIR/$SAMPLE.realigned.recal_data.grp \
   -L:capture,BED $TARGET_FILE \
   -rf BadCigar

java -Xmx$JAVA_XMX -jar $GATK_HOME/GenomeAnalysisTK.jar \
   -T PrintReads \
   -R path/to/fasta/hs37d5.fa \
   -I $INPUT_DIR/$SAMPLE.realignedtogether.bam \
   -nct 8 \
   -BQSR $OUTPUT_DIR/$SAMPLE.realigned.recal_data.grp \
   -o $OUTPUT_DIR/$SAMPLE.realigned.recalibrated.bam

