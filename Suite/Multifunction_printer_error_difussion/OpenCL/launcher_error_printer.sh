#!/bin/bash

# ./launcher_error_printer.sh error_diffusion errorDiffusion.aocx images

CONFIG="de1_soc-cluster.conf"
RUNPATH="/tmp"


if [ $# != 3 ]; then
  echo "Uso: ./launcher_error_printer.sh [program] [kernel] [images_file]"
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
echo "Reading input images..."
IFS=$'\n' read -d '' -r -a INPUT < $3
NUM_INPUT=${#INPUT[@]}
for ((i=0; i<$NUM_INPUT; i++))
do
  echo " |- image $i: ${INPUT[i]}"
done
echo " |- done"


echo "Procesing images..."
time0=$(get_time)
for ((i=0; i<$NUM_INPUT; i++))
do

   echo " |- Waiting for idle node to process ${INPUT[i]} image..."

	for ((j=0; j<$NUM_NODES;))
	do
	  state=$(ssh root@${NODES[j]} "cat state")
	  if [ $state = "idle" ] || [ $state = "finish" ]; then
	    echo "   |- ${NODES[j]} ready. Copying ${INPUT[i]} and executing..."
            ssh root@${NODES[j]} 'echo "running" > state' &&
            ini=$(get_time) &&
	    scp  -q $1 $2 ${INPUT[i]} root@${NODES[j]}:$RUNPATH &&
            end=$(get_time) &&
            let SCPTIME[i]=$end-$ini &&
            echo -n " |- Time copying to node $j (sec): " &&
            echo "${SCPTIME[i]} * 0.000000001" | bc -l &&
            ssh root@${NODES[j]} "./launch2.sh $OUTPATH $1 -i ${INPUT[i]} -o out/out_${INPUT[i]} -r -v" &
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

echo "  # Execution time (s):"

for ((i=0; i<$NUM_NODES; i++))
do
   node=$(ssh root@${NODES[i]} "cat /etc/hostname") 
   nodeExecTime=$(ssh root@${NODES[i]} "head $1.log -n 1")
   nodeSCPTime=$(ssh root@${NODES[i]} "tail $1.log -n 1")
   echo -ne "     |- $node, execution time (sec): \t"
   echo "$nodeExecTime * 0.000000001" | bc -l
   echo -ne "     |- $node, SCP time (sec): \t"
   echo "$nodeSCPTime * 0.000000001" | bc -l
done


echo ""
echo -n "  TOTAL (s): "
echo "$tiempo_total * 0.000000001" | bc -l
echo ""
echo "#################################################"

exit 0



