#!/bin/bash

# ./launcher_sobel-laplace_filter.sh [sobel_filter | laplace_filter] [sobel.aocx | laplace.aocx] 1_butterflies_1080.ppm 1920 1080

CONFIG="de1_soc-cluster.conf"
RUNPATH="/tmp"

if [ $# != 5 ]; then
  echo "Uso: ./launcher_sobel-laplace_filter.sh [program] [kernel] [image] [width] [height]"
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


# Divide el argumento (una imagen) en NUM_NODOS trozos
echo "Spliting $3 in $NUM_NODES part(s)..."
time0=$(get_time)
WIDTH=$(($4/$NUM_NODES))
HEIGHT=$5
pamdice $3 -outstem=imageIn -width=$WIDTH -height=$HEIGHT
echo " |- done"
time1=$(get_time)


# Copia el ejecutable y el argumento a cada nodo
echo "Copying $1, $2 and $3 and executing..."
for ((i=0; i<$NUM_NODES; i++))
do
  echo -n " |- ${NODES[i]}:$RUNPATH ..."
  ssh root@${NODES[i]} 'echo "running" > state' &&
  ini=$(get_time) &&
  scp  -q $1 $2 imageIn_00_0$i.ppm root@${NODES[i]}:$RUNPATH &&
  end=$(get_time) &&
  let SCPTIME[i]=$end-$ini &&
  echo -n " |- Time copying to node $i (sec): " &&
  echo "${SCPTIME[i]} * 0.000000001" | bc -l &&
  ssh root@${NODES[i]} "./launch2.sh $OUTPATH/out $1 -img=imageIn_00_0$i.ppm -w=$WIDTH -h=$HEIGHT" -thresh=32 &
  echo "done"
done
echo " |- done"
time2=$(get_time)


# Espera a que se envien los resultados
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
time3=$(get_time)

# Une las imagenes de resultado
echo "Concating images..."
  pnmcat -leftright out/imageIn_00_0*.ppm > out/out_$6_$3
  rm out/imageIn_*.ppm
  rm imageIn_*.ppm
echo " |- done" 
time4=$(get_time)



echo ""
echo "#################################################"
echo ""
echo "                 EXECUTION TIME"
echo ""

let tiempo_total=$time4-$time0
let tiempo_dividir=$time1-$time0
let tiempo_ejecutar=$time3-$time1
let tiempo_juntar=$time4-$time3

echo -ne "  # Split input data (ms): \t\t"
echo "$tiempo_dividir * 0.000001" | bc -l

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
echo -ne "     |- TOTAL (sec):\t\t\t"
echo "$tiempo_ejecutar * 0.000000001" | bc -l


echo -ne "  # Join output (ms): \t\t\t"
echo "$tiempo_juntar * 0.000001" | bc -l

echo ""
echo "        ----------------------------- "
echo ""
echo -n "  TOTAL (s): "
echo "$tiempo_total * 0.000000001" | bc -l
echo ""
echo "#################################################"




