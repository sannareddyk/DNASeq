#!/bin/bash

count=1
for samplepath in path/to/mutect/realign/*.realignedtogether.bam
do
 echo $samplepath
 samplename=$(basename "$samplepath" | cut -d. -f1)
 echo $samplename
 scripts_dir=path/to/mutect/recalibrate
 script_path=$scripts_dir/"pbs.script.recalibrate."$count
 #echo $script_path
 ((count+=1))

 cp path/to/cmd/gatk_recalibrate.sh $script_path
 sed -i -e "s/#sampleName/$samplename/g" $script_path
  
done

#for script in pbs.script.realign*; do qsub $script; done
