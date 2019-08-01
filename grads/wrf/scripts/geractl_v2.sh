#!/bin/bash -x

if [ $# -ne 2 ];then

	echo "Entre com  area (metarea5, sse, ne ou ant) e o horario de referencia (00 ou 12) !!!"
	exit 12

fi

AREA=$1
HH=$2

case $AREA in
	metarea5)
	AREA3=${AREA}
	;;
	antartica)
	AREA3=${AREA}
	;;
	met510km)
	AREA3=${AREA}
	;;
	cptec)
	AREA3=${AREA}
	;; 
esac

ctldir="/home/operador/grads/wrf/wrf_${AREA}/ctl"
n=0

datahoje=`cat /home/operador/datas/datacorrente$HH`

cd /home/operador/grads/wrf/wrf_${AREA}/ctl

datagrads=`/usr/bin/caldate $datahoje + ${HH}h 'hhZddmmmyyyy'`

#### ALTERADO HOJE 28/02/2019 ######


RFILE="wrf_${AREA3}_${HH}_${datahoje}"


if [ ${AREA} = "cptec" ];then 

	ctls="U"
	echo "${RFILE}"
	t=`cat /home/operador/grads/wrf/wrf_${AREA}/ctl/ctl${HH}/progfinal`
	t=`echo "($t + 1)" | bc`

else 
	
	ctls="U Uaux"
	t=`cat /home/operador/grads/wrf/wrf_${AREA}/ctl/ctl${HH}/progfinal`
	t=`echo "(($t + 3) / 3)" | bc`
fi

for L in `echo $ctls`;do

	cat wrf_${AREA}_HH_$L.ctl | sed -e 's|HH|'$HH'|g' 	> raw
	cat raw | sed -e 's|DATAGRADS|'$datagrads'|' 		> raw2
	cat raw2 | sed -e 's|NOMEGRIB|'$RFILE'|' 		> raw
	cat raw | sed -e 's|QT|'$t'|' 				> raw2
	cat raw2 | sed -e 's|AREA|'$AREA'|g' 			> raw
	cat raw | sed -e 's|HH|'$HH'|g' 			> raw2

	mv raw2 ctl${HH}/wrf_${AREA}_${HH}_$L.ctl 

	if ! [ $L == A ];then

		/usr/local/bin/gribmap -i  ctl${HH}/wrf_${AREA}_${HH}_$L.ctl 

	fi

	chmod a+w ctl${HH}/wrf_${AREA}_${HH}_$L.ctl
#	rm raw*
done

