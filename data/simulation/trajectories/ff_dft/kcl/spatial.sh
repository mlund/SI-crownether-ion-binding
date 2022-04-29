#!/bin/bash
gmx spatial -s top_$1.gro -f c$1.xtc -n index_$1.ndx -nab 100 <<EOF
  $2
  2
EOF

