#!/bin/sh
#SBATCH -J f_dft_wCounterions_REMD
#SBATCH -N 1
#SBATCH --tasks-per-node=20
#SBATCH -t 100:00:00
#SBATCH -A lu2021-2-39
#SBATCH --partition=lu

i=$1
# filenames stdout and stderr - customise, include %j
#SBATCH -o crownether_$i.out
#SBATCH -e crownether_$i.err

module purge
module load GCC/7.3.0-2.30  OpenMPI/3.1.1
module load GROMACS/2019

sh min.sh $i
sh nvt.sh $i
sh npt.sh $i
sh prod.sh $i
