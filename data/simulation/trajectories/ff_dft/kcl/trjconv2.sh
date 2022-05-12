#!/bin/bash

gmx trjconv -s tpr_$1.tpr -f b$1.xtc -o c$1.xtc -fit rot+trans -n index_$1.ndx <<EOF
  2
  0
EOF

