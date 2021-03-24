#!/bin/bash
#
#
# Script para VRF se os dados do WW3
# rodaram na DPNS31 na DPNS01
#

if [ $# -ne 3 ]

 then
 echo " ---------------------------------------- "
 echo " Voce deve entrar com o modelo(gfs, icon  "
 echo " ou cosmo), o horario da rodada(00 ou 12) "
 echo " e o caminho do output (01 ou 31)         "
 echo "                                          "
 echo " ex:./checar_ww3.sh gfs 00 31              "
 echo " ---------------------------------------- "
 echo
 exit
fi

mod=$1
cyc=$2
cam=$3


if [ $cam -eq 01 ]
then
  caminho01="/mnt/nfs/dpns33/data1/ww3desenv/mod_ondas/ww3_418/output/ww3${mod}/wave.$(cat /home/operador/datas/datacorrente00)"
  cam=$caminho01
  #echo $caminho01
fi

if [ $cam -eq 31 ]
then
  caminho31="/mnt/nfs/dpns32/data2/operador/mod_ondas/ww3_418/output/ww3${mod}/wave.$(cat /home/operador/datas/datacorrente00)"
  cam=$caminho31
  #echo $caminho31
fi

for area in GLO MET ANT; do
	FILE=${cam}/WW3${area}_${cyc}_SAFO	

	if test -f "$FILE"; then
		echo "$FILE exists."
	else
		echo "$FILE error"
	fi
done
