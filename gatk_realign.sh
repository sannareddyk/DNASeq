#!/bin/bash

##script to run realignment step of GATK

#PBS -l walltime=24:00:00
#PBS -l select=1:ncpus=2:mem=5gb:tmpspace=54984mb
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
NORMAL_SAMPLE=#normalSample
LGTUMOR_SAMPLE=#lowgradeSample
HGTUMOR_SAMPLE=#highgradeSample
TARGET_FILE=path/to/targets.bed
OUTPUT_DIR=path/to/realign

##realignment
java -Xmx$JAVA_XMX -jar $GATK_HOME/GenomeAnalysisTK.jar \
	-T RealignerTargetCreator \
	-R path/to/fasta/hs37d5.fa \
	-I path/to/$NORMAL_SAMPLE/$NORMAL_SAMPLE".bam" -I path/to/$LGTUMOR_SAMPLE/$LGTUMOR_SAMPLE".bam" -I path/to/$HGTUMOR_SAMPLE/$HGTUMOR_SAMPLE".bam" \
	-nt $RTC_DATA_THREADS \
	-drf DuplicateRead \
	--known path/to/GATK_resource_bundle/2.8/b37/1000G_phase1.indels.b37.vcf \
	--known path/to/GATK_resource_bundle/2.8/b37/Mills_and_1000G_gold_standard.indels.b37.vcf \
	-o $OUTPUT_DIR/$NORMAL_SAMPLE-$LGTUMOR_SAMPLE-$HGTUMOR_SAMPLE.RTC.intervals \
	-L:capture,BED $TARGET_FILE

cd $OUTPUT_DIR

java -Xmx$JAVA_XMX -jar $GATK_HOME/GenomeAnalysisTK.jar \
	-T IndelRealigner \
	-R /path/to/fasta/hs37d5.fa \
	-I path/to/$NORMAL_SAMPLE/$NORMAL_SAMPLE".bam" -I path/to/$LGTUMOR_SAMPLE/$LGTUMOR_SAMPLE".bam" -I path/to/$HGTUMOR_SAMPLE/$HGTUMOR_SAMPLE".bam" \
	-drf DuplicateRead \
	-targetIntervals $OUTPUT_DIR/$NORMAL_SAMPLE-$LGTUMOR_SAMPLE-$HGTUMOR_SAMPLE.RTC.intervals \
	-known path/to/GATK_resource_bundle/2.8/b37/1000G_phase1.indels.b37.vcf \
	-known path/to/GATK_resource_bundle/2.8/b37/Mills_and_1000G_gold_standard.indels.b37.vcf \
	-nWayOut '.realignedtogether.bam'
