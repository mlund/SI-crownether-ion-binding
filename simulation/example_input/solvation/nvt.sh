#!/bin/bash

# set some environment variables 
FREE_ENERGY=/home/eko12vas/crownEthers/gromacs/examples/test/free-energy/neutralCrown/KCl/sepSims/spce/REMD
echo "Free energy home directory set to $FREE_ENERGY"

MDP=$FREE_ENERGY/MDP
echo ".mdp files are stored in $MDP"

LAMBDA=$1
echo $LAMBDA
# A new directory will be created for each value of lambda and
# at each step in the workflow for maximum organization.

cd lambda_$LAMBDA

mkdir NVT
cd NVT
for dir in 298 302 306 310 314 318
do
    echo $dir
    mkdir ${dir}K
    cd ${dir}K
    gmx grompp -f $MDP/NVT/${dir}K/nvt_$LAMBDA.mdp -c ../../EM/${dir}K/min$LAMBDA.gro -r ../../EM/${dir}K/min$LAMBDA.gro -p $FREE_ENERGY/solvated/solvated.top -n $FREE_ENERGY/solvated/index.ndx -o nvt$LAMBDA.tpr -maxwarn 1

    #################################
    # CONSTANT V EQUILIBRATION      #
    #################################
    echo "Starting constant volume equilibration for LAMBDA = $LAMBDA, T = ${dir}K..." 
    cd ..
done  
#gmx grompp -f $MDP/NVT/nvt_$LAMBDA.mdp -c ../EM/min$LAMBDA.gro -r ../EM/min$LAMBDA.gro -p $FREE_ENERGY/solvated/solvated.top -n $FREE_ENERGY/solvated/index.ndx -o nvt$LAMBDA.tpr -maxwarn 1

mpirun -np 6 gmx_mpi mdrun -deffnm nvt${LAMBDA} -v -multidir *K
#gmx mdrun -np 3 -deffnm min$LAMBDA -multidir *K/newTop/const_k/
  
echo "Constant volume equilibration complete."
#sleep 2

pwd 
cd ../../


