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

mkdir NPT
cd NPT
for dir in 298 302 306 310 314 318 
do
    echo $dir
    mkdir ${dir}K
    cd ${dir}K
    gmx grompp -f $MDP/NPT/${dir}K/npt_$LAMBDA.mdp -c ../../NVT/${dir}K/nvt$LAMBDA.gro -r ../../NVT/${dir}K/nvt$LAMBDA.gro -p $FREE_ENERGY/solvated/solvated.top -t ../../NVT/${dir}K/nvt$LAMBDA.cpt -n $FREE_ENERGY/solvated/index.ndx -o npt$LAMBDA.tpr -maxwarn 1
    #################################
    # CONSTANT P EQUILIBRATION      #
    #################################
    echo "Starting constant pressure equilibration for LAMBDA = $LAMBDA, T = ${dir}K..." 
    
    cd ..
done  
# Iterative calls to grompp and mdrun to run the simulations

#gmx grompp -f $MDP/NPT/npt_$LAMBDA.mdp -c ../NVT/nvt$LAMBDA.gro -r ../NVT/nvt$LAMBDA.gro -p $FREE_ENERGY/solvated/solvated.top -t ../NVT/nvt$LAMBDA.cpt -n $FREE_ENERGY/solvated/index.ndx -o npt$LAMBDA.tpr -maxwarn 1

mpirun -np 6 gmx_mpi mdrun -deffnm npt${LAMBDA} -v -multidir *K
#gmx mdrun -np 3 -deffnm min$LAMBDA -multidir *K/newTop/const_k/
  
echo "Constant pressure equilibration complete."
#sleep 2

pwd 
cd ../../


