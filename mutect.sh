#!/bin/bash

##sript for somatic variant calling using mutect

#PBS -l walltime=24:00:00
#PBS -l select=1:ncpus=2:mem=20gb
#PBS -M xx
#PBS -m ae
#PBS -j oe
#PBS -q xx

#load modules
module load gatk/3.5
module load java/sun-jdk-1.6.0_19
module load mutect/1.1.4

JAVA_XMX=4G
NORMAL_SAMPLE=#normalSample
TUMOR_SAMPLE=#tumorSample
TARGETS_FILE=path/to/targets_norandomUn.bed
INPUT_DIR=path/to/recalibrate
OUTPUT_DIR=path/to/variantcalls

#somatic variant calling using mutect
java -Xmx$JAVA_XMX -jar $MUTECT_HOME/muTect-1.1.4.jar \
--analysis_type MuTect \
--reference_sequence path/to/fasta/hs37d5.fa \
--cosmic path/to/annotations/Cosmic_v70_hs37d5.vcf \
--dbsnp path/to/dbsnp_b142_GRCh37p13.vcf \
--intervals $TARGETS_FILE \
--input_file:normal $INPUT_DIR/$NORMAL_SAMPLE.realigned.recalibrated.bam \
--input_file:tumor $INPUT_DIR/$TUMOR_SAMPLE.realigned.recalibrated.bam \
--out $OUTPUT_DIR/$NORMAL_SAMPLE-$TUMOR_SAMPLE.txt \
--vcf $OUTPUT_DIR/$NORMAL_SAMPLE-$TUMOR_SAMPLE.vcf \
-rf BadCigar
#-drf DuplicateRead
