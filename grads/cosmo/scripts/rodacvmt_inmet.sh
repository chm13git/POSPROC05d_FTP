#!/bin/bash

set -x

if [ $# -ne 2 ];then

	echo "Entre com  area (met, sse, ne, inmet ou ant) e o horario de referencia (00 ou 12) !!!"

	exit 12
fi

AREA=$1

HH=$2

case $AREA in
	met)
	gsdir="/home/operador/grads/cosmo/cosmo${AREA}/gs"
	AREA3=${AREA}5
	;;
	sse)
	gsdir="/home/operador/grads/cosmo/cosmo${AREA}/gs"
	AREA3=${AREA}
	;;
	ne)
	gsdir="/home/operador/grads/cosmo/cosmo${AREA}/gs"
	AREA3=${AREA}   
	;;
	ant)
	gsdir="/home/operador/grads/cosmo/cosmo${AREA}/gs"
	AREA3=${AREA}
	;;
	inmet)
	gsdir="/home/operador/grads/cosmo/cosmo${AREA}/gs"
	AREA3=${AREA}
esac

gifdir="/home/operador/grads/gif/cosmo${AREA}_${HH}"
gifdirdpnt02b="/home/supervisor/Servico/Modelos/cosmo_${AREA}${HH}"
gifdirdpnt02="/home/supervisor/Servico/Modelos/cosmo_${AREA}${HH}"
datahoje=`cat /home/operador/datas/datacorrente$HH`
dataanalise=`/usr/bin/caldate ${datahoje}${HH} + 000h 'hhZddmmmyyyy(sd)'`
meses="JAN;FEV;MAR;ABR;MAI;JUN;JUL;AGO;SET;OUT;NOV;DEZ"
months="Jan;Feb;Mar;Apr;May;Jun;Jul;Ago;Sep;Oct;Nov;Dec"
dias="Dom;Seg;Ter;Qua;Qui;Sex;Sab"
diasp="Domingo;Segunda-feira;Terca-feira;Quarta-feira;Quinta-feira;Sexta-feira;Sabado"

for j in `seq 1 7`;do

	dia=`echo $dias | cut -f$j -d";"`
	day=`echo $diasp | cut -f$j -d";"`
	dataraw=`echo $dataanalise | sed -e 's/'$day'/'$dia'/'`
	dataanalise=$dataraw

done

for j in `seq 1 12`;do

	mes=`echo $meses | cut -f$j -d";"`
	month=`echo $months | cut -f$j -d";"`
	dataraw=`echo $dataanalise | sed -e 's/'$month'/'$mes'/'`
	dataanalise=$dataraw

done

if ! [ $AREA == "sse" ] && ! [ $AREA == "ne" ] && ! [ $AREA == "pry" ];then

	/home/operador/grads/cosmo/scripts/geractl_progfinal_inmet.sh  ${AREA} ${HH} 

fi

if ! [ $AREA == "inmet" ];then

	/home/operador/grads/cosmo/scripts/cortevertical.sh $AREA $HH $dataanalise

fi

/home/operador/grads/cosmo/scripts/meteogramas_inmet.sh $AREA $HH $dataanalise

meteos=`cat /home/operador/grads/cosmo/cosmo${AREA}/invariantes/listameteo | awk '{ print "*"$1"*.gif" }' | tr '\012' ' '`
cverts=`cat /home/operador/grads/cosmo/cosmo${AREA}/invariantes/listacvert | awk '{ print "*"$1"*.gif" }' | tr '\012' ' '`

cd $gifdir

if [ $AREA == "sse_10km" ];then

	AREAN="sse"

elif [ $AREA == "ne_10km" ];then

	AREAN="ne"

elif [ $AREA == "10km" ];then

	AREA="met"

else

	AREAN=$AREA

fi

for arq in `ls cvert+neb*.gif ${AREAN}_*.gif`
do  

	nomeprog=`echo $arq | cut -f1 -d.`
	/usr/bin/convert $arq $nomeprog.png

done 

meteopng=`cat /home/operador/grads/cosmo/cosmo${AREA}/invariantes/listameteo | awk '{ print "*"$1"*.png" }' | tr '\012' ' '`
cvertpng=`cat /home/operador/grads/cosmo/cosmo${AREA}/invariantes/listacvert | awk '{ print "*"$1"*.png" }' | tr '\012' ' '`
