#!/bin/bash
set -x



if [ $# -ne 1 ];then

	echo "Entre com o horario da rodada (00 ou 12)!!!!"
	exit

fi

HH=$1

LISTA=("WW3GFS" "WW3ICON" "WW3COSMO" "COSMOMET" "COSMOANT" "ICON" "WRFMET" "WRFANT")
HORARIOS00=("07:00" "07:10" "07:20" "03:00" "05:45" "03:40" "03:40" "05:00")
HORARIOS12=("17:30" "17:15" "18:00" "15:00" "17:45" "15:40" "15:40" "17:00")


DATA=`cat /home/operador/datas/datacorrente$HH`
n=0

for MODELO in ${LISTA[@]} 
do 
if [ $HH == "00" ]
then 
HORARIOS=${HORARIOS00[$n]}
else
HORARIOS=${HORARIOS12[$n]}
fi

HORA=$HORARIOS


MSG="O pos-processamento do $MODELO de $DATA, iniciara as $HORA"

let n=n+1

/usr/bin/input_status.php $MODELO $HH Operacional Cinza "$MSG"

sleep 2

done
