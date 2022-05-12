#!/bin/bash

gmx trjconv -s tpr_$1.tpr -f traj_$1.xtc -o b$1.xtc -boxcenter tric -ur compact -pbc mol -n index_$1.ndx <<EOF
  0
EOF
