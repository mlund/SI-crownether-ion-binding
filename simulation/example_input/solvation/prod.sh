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

mkdir Production_MD
cd Production_MD
for dir in 298 302 306 310 314 318
do
    echo $dir
    mkdir ${dir}K
    cd ${dir}K
    gmx grompp -f $MDP/Production_MD/${dir}K/md_$LAMBDA.mdp -c ../../NPT/${dir}K/npt$LAMBDA.gro -r ../../NPT/${dir}K/npt$LAMBDA.gro -p $FREE_ENERGY/solvated/solvated.top -t ../../NPT/${dir}K/npt$LAMBDA.cpt -n $FREE_ENERGY/solvated/index.ndx -o md$LAMBDA.tpr -maxwarn 1
    cd ..
    #################################
    # PRODUCTION RUN                #
    #################################
    echo "Starting production MD simulation for LAMBDA = $LAMBDA, T = ${dir}K..." 
done  
# Iterative calls to grompp and mdrun to run the simulations
## Changed to start from last md simulation state
#gmx grompp -f $MDP/Production_MD/md_$LAMBDA.mdp -c ../Production_MD/md$LAMBDA.gro -p $FREE_ENERGY/solvated/solvated.top -t ../Production_MD/md$LAMBDA.cpt -n $FREE_ENERGY/solvated/index.ndx -o md$LAMBDA.tpr -maxwarn 1
#gmx grompp -f $MDP/Production_MD/md_$LAMBDA.mdp -c ../NPT/npt$LAMBDA.gro -r ../NPT/npt$LAMBDA.gro -p $FREE_ENERGY/solvated/solvated.top -t ../NPT/npt$LAMBDA.cpt -n $FREE_ENERGY/solvated/index.ndx -o md$LAMBDA.tpr -maxwarn 1
mpirun -np 6 gmx_mpi mdrun -deffnm md${LAMBDA} -v -multidir *K -replex 500

#gmx mdrun -np 3 -deffnm min$LAMBDA -multidir *K/newTop/const_k/
  
echo "Production MD complete."
#sleep 2

pwd 
cd ../../


