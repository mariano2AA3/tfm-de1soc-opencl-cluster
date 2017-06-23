#!/bin/bash

function get_time(){
  echo `date +%s%N`
}


N=8


time0=$(get_time)

for((i=0;i<N-1;i++))
do

./$1 $2 $3 $4

done

time1=$(get_time)


let total=$time1-$time0

echo -n "TOTAL (segundos): "
echo "$total * 0.000000001" | bc -l
