#!/bin/bash

for i in `seq 31 31`
do
  echo $i
  sbatch auroraLU.sh $i
done
