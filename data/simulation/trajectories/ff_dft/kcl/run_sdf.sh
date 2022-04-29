#!/bin/bash
i=$1
sh trjconv1.sh $i
sh trjconv2.sh $i
sh spatial.sh $i $2
mv grid.cube grid.cube_$i
