#!/bin/bash

# ./launcher_optical_flow.sh optical_flow optical_flow.aocx input 3

CONFIG="de1_soc-cluster.conf"
RUNPATH="/tmp"
INPUTPATH="input/"


if [ $# != 4 ]; then
  echo "Uso: ./launcher_image_filter.sh [program] [kernel] [images_prefix] [N]"
  exit -1
fi


function get_time(){
  echo `date +%s%N`
}

OUTPATH=$(pwd)


# Lee la configuracion del cluster
echo -n "Reading cluster config..."
IFS=$'\n' read -d '' -r -a NODES < $CONFIG

NUM_NODES=${#NODES[@]}

echo "(num nodes: $NUM_NODES)"

for ((i=0; i<$NUM_NODES; i++))
do
  echo " |- Node $i: ${NODES[i]}"
done
echo " |- done"


# Lee las imagenes a procesar
INPUT=$3
EXT=".raw"
NUM_INPUT=$4

echo "Procesing images..."
time0=$(get_time)
for ((i=0, k=1; i<$NUM_INPUT-1; i++, k++))
do

   echo " |- Waiting for idle node to process $INPUTPATH$INPUT$i$EXT and $INPUTPATH$INPUT$k$EXT..."

	for ((j=0; j<$NUM_NODES;))
	do
	  state=$(ssh root@${NODES[j]} "cat state")
	  if [ $state = "idle" ] || [ $state = "finish" ]; then
	    echo "   |- ${NODES[j]} ready. Copying input files and executing..."
            ssh root@${NODES[j]} 'echo "running" > state' &&
	    scp  -q $1 $2 $INPUTPATH$INPUT$i$EXT $INPUTPATH$INPUT$k$EXT root@${NODES[j]}:$RUNPATH &&
            ssh root@${NODES[j]} "./launch2.sh $OUTPATH $1 -input1=$INPUT$i$EXT -input2=$INPUT$k$EXT" >> log.log &
	    sleep 0.25
            break
          else
	   j=$(((j + 1) % NUM_NODES))
          fi
	done

done


echo "Waiting for termination..."
for ((i=0; i<$NUM_NODES;))
do
  state=$(ssh root@${NODES[i]} "cat state")
  if [ $state = "finish" ]; then
    echo " |- ${NODES[i]} finished"
    ssh root@${NODES[i]} 'echo "idle" > state' &
    i=$((i + 1))
  fi
done
echo " |- done"

time1=$(get_time)

echo ""
echo "#################################################"
echo ""
echo "                 EXECUTION TIME"
echo ""

let tiempo_total=$time1-$time0

echo ""
echo -n "  TOTAL (s): "
echo "$tiempo_total * 0.000000001" | bc -l
echo ""
echo "#################################################"

exit 0
