#!/bin/bash

count=1
while IFS=$'\t' read -r f1 f2 f3
do
 echo $f1
 echo $f2
 echo $f3
 normalsample=$f1
 lowgradesample=$f2
 highgradesample=$f3
 #echo $normalSample
 
 scripts_dir=path/to/mutect/realign
 script_path=$scripts_dir/"pbs.script.realign."$count
 #echo $script_path
 ((count+=1))

 cp path/to/cmd/gatk_realign.sh $script_path
 sed -i -e "s/#normalSample/$normalsample/g" $script_path
 sed -i -e "s/#lowgradeSample/$lowgradesample/g" $script_path
 sed -i -e "s/#highgradeSample/$highgradesample/g" $script_path	
  
done < $1

#for script in pbs.script.realign*; do qsub $script; done
