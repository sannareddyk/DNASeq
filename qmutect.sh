#!/bin/bash

count=1
while IFS=$'\t' read -r f1 f2
do
 echo $f1
 echo $f2
 normalsample=$f1
 tumorsample=$f2

 scripts_dir=path/to/mutect/variantcalls
 script_path=$scripts_dir/"pbs.script.mutect."$count
 #echo $script_path
 ((count+=1))

 cp path/to/cmd/mutect.sh $script_path
 sed -i -e "s/#normalSample/$normalsample/g" $script_path
 sed -i -e "s/#tumorSample/$tumorsample/g" $script_path
  
done < $1

#for script in pbs.script.realign*; do qsub $script; done
