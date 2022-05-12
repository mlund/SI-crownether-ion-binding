#!/bin/bash

# set some environment variables 
FREE_ENERGY=/home/eko12vas/crownEthers/gromacs/examples/test/free-energy/neutralCrown/sepSims/first/fixedK/k1_4000/dftCharges/spce/REMD/newTop/const_k/equalVolume/2ndRun
echo "Free energy home directory set to $FREE_ENERGY"

MDP=$FREE_ENERGY/MDP
echo ".mdp files are stored in $MDP"

LAMBDA=$1
#Nlambdas=`expr $Nlambdas - 2`
echo $LAMBDA
# A new directory will be created for each value of lambda and
# at each step in the workflow for maximum organization.

mkdir lambda_$LAMBDA
cd lambda_$LAMBDA

mkdir EM
cd EM

for dir in 298 302 306 310 314 318
do
    echo $dir
    mkdir ${dir}K
    cd ${dir}K 
    gmx grompp -f $MDP/EM/em_steep_$LAMBDA.mdp -c $FREE_ENERGY/solvated/solvated.gro -r $FREE_ENERGY/solvated/solvated.gro -p $FREE_ENERGY/solvated/solvated.top -n $FREE_ENERGY/solvated/index.ndx -o min$LAMBDA.tpr -maxwarn 1
    cd ..
    
    #################################
    # ENERGY MINIMIZATION 1: STEEP  #
    #################################
    echo "Starting minimization for lambda = ${LAMBDA}, T = ${dir}K..." 
    
done  

mpirun -np 6 gmx_mpi mdrun -deffnm min${LAMBDA} -v -multidir *K
#sleep 2
# Iterative calls to grompp and mdrun to run the simulations


#gmx mdrun -np 3 -deffnm min$LAMBDA -multidir *K

#sleep 2

pwd 
cd ../../


