#!/bin/bash
set -x
# Este script gera o ctl para um prognostico especifico

AREA=$1
HH=$2
prog=$3

if [ $# -ne 3 ];then

	echo "Voce deve entrar com a area com o horario de referencia e com o prognostico"

	exit 12
fi 


case $AREA in

	met)
	AREA2="met5"
	HSTOP=78
	ctls0="c m p z"
	HINT=3
	;;

	ant)
	AREA2="ant"
	HSTOP=78
	ctls0="c m p z PDEF_c"
	HINT=3
	;;

	sse22)
	AREA2="sse22"
	HSTOP=48
	ctls0="c m p z"
	HINT=1
	;;

esac

dpns5dir=/home/operador/grads/cosmo/cosmo${AREA}
datahoje=`cat /home/operador/datas/datacorrente${HH}`
DIG='0'

for HREF in `seq 0 ${HINT} $HSTOP`;do

	if [ $HREF -lt 10 ];then

		HORA=0$DIG$HREF

	elif [ $HREF -lt 100 ];then

		HORA=$DIG$HREF

	else

		HORA=$HREF

	fi

	str="${str} ${HORA}"

done

cd ${dpns5dir}/ctl/ctl${HH}

deltat=`echo "($prog + $HH)" | bc`
datagrads=`/usr/bin/caldate $datahoje + ${deltat}h 'hhZddmmmyyyy'`

if [ $prog == "000" ];then

	ctls=$ctls0

else

	if [ ${AREA} == "sse22" ];then

		ctls="m p z 1 3 6 12 24"

	else

		ctls="m p z 3 6 12 24"

	fi
fi

cd  ${dpns5dir}/ctl/ctl${HH}

for L in `echo $ctls`
do

rm -f cosmo_${AREA2}_${HH}_$L.ctl
cat ${dpns5dir}/ctl/cosmo_${AREA2}_HH_$L.ctl | sed -e 's|HH|'$HH'|g' > raw
x=$((L+0))


	if [ $x -eq 0 ];then

		RFILE=cosmo_${AREA2}_${HH}_${datahoje}${prog}
		cat raw | sed -e 's|DATAGRADS|'$datagrads'|'> raw2
		cat raw2 | sed -e 's|NOMEGRIB|'$RFILE'|' > raw
		mv raw cosmo_${AREA2}_${HH}_$L.ctl
		/usr/local/bin/gribmap -i cosmo_${AREA2}_${HH}_$L.ctl

	else

		resto=`echo "( $prog % $L )" | bc`

		if [ $resto -eq 0 ] && [ $prog -gt 0 ] ;then

			cont=`echo "( $prog - $L ) / $HINT + 1 " | bc`
			progt=`echo ${str} | cut -f$cont -d" "`
			RFILEt=cosmo_${AREA2}_${HH}_${datahoje}${progt}
			deltat2=`echo "( $deltat - $L )" | bc`
			datagradst=`/usr/bin/caldate $datahoje + ${deltat2}h 'hhZddmmmyyyy'`
			cat raw | sed -e 's|DATAGRADS'$L'|'$datagradst'|'> raw2
			cat raw2 | sed -e 's|NOMEGRIB'$L'|'$RFILEt'|' > raw
			mv raw cosmo_${AREA2}_${HH}_$L.ctl
			/usr/local/bin/gribmap -i cosmo_${AREA2}_${HH}_$L.ctl
		fi

	fi

done

rm raw*
