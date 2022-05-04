#!/bin/bash

for i in `seq 0 32`
do
  echo $i
  sbatch aurora.sh $i
done
