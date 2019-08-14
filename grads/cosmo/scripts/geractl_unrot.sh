#!/bin/bash -x

# Esse script verifica qual o ultimo prognostico do COSMO que foi prontificado

if [ $# -ne 2 ];then

	echo "Entre com a area modelada (met, ant, inmet), com o horario de referencia (00 ou 12)"
	exit

fi

AREA=$1
HH=$2
HSTART="00"
dadosdir="/home/operador/grads/cosmo/cosmo${AREA}/ww3_unrot${HH}"
dpns5dir="/home/operador/grads/cosmo/cosmo${AREA}"
datahoje=`cat /home/operador/datas/datacorrente${HH}`
datagrads=`/usr/bin/caldate $datahoje$HH + 0h 'hhZddmmmyyyy'`
echo "Os seguintes parametros foram passados para o script"
echo "AREA=$AREA"
echo "HH=$HH - horario de referencia da rodada "

case ${AREA} in
	ant)
	HSTOP=96
	AREA2="ant"
	ctls="zygribBINunrot PDEF_M_unrot"
	DIVS="1 1"
	INT="1" 
	;;
esac

# Gerando o string com os prognosticos na ordem decrescente
DIG='0'
for HREF in `seq $HSTOP -$INT $HSTART`;do

	if [ $HREF -lt 10 ];then

		HORA=0$DIG$HREF

	elif [ $HREF -lt 100 ];then

		HORA=$DIG$HREF

	else

		HORA=$HREF

	fi
	str="${str} ${HORA}"

done


# Verificando o ultimo prognostico gerado. Em situacoes normais sera o HSTOP
flag=1
for prog in `echo ${str}`;do

	RFILE=cosmo_${AREA2}_${HH}_${datahoje}${prog}

	while [ $flag -eq 1 ];do

		if  [ -e ${dadosdir}/${RFILE} ] ; then

			flag=0
			PROGFINAL=$prog

		else

			break
		fi
	done
done

# Gerando os ctls para todos os horarios
cd  ${dpns5dir}/ctl/ctl${HH}
i=1
for L in `echo $ctls`;do

	DIV=`echo $DIVS | cut -f$i -d" "`
	tt=`echo "$PROGFINAL / $DIV + 1" | bc`
	rm -f cosmo_${AREA2}_${HH}_$L.ctl
	cat ${dpns5dir}/ctl/cosmo_${AREA2}_HH_$L.ctl | sed -e 's|HH|'$HH'|g' > raw
	RFILE=cosmo_${AREA2}_${HH}_${datahoje}${prog}
	cat raw  | sed -e 's|DATAGRADS|'$datagrads'|'> raw2
	cat raw2 | sed -e 's|NOMEGRIB|cosmo_'$AREA2'_'$HH'_'$datahoje'|' > raw
	cat raw  | sed -e 's|PROGFINAL|'$tt'|' > raw2
	cat raw2 | sed -e 's|DATAHOJE|'$datahoje'|' > raw
	mv raw cosmo_${AREA2}_${HH}_$L.ctl
	rm raw raw2 
	n=`grep -c "dtype grib" cosmo_${AREA2}_${HH}_$L.ctl`
   
	if [ $n != 0 ];then

		/usr/local/bin/gribmap -i cosmo_${AREA2}_${HH}_$L.ctl

	fi


done
