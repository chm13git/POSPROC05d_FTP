#!/bin/bash -x

# Esse script verifica qual o ultimo prognostico do COSMO que foi prontificado

if [ $# -ne 2 ];then

	echo "Entre com a area modelada (met, ant, inmet), com o horario de referencia (00 ou 12)"
	exit

fi

AREA=$1
HH=$2
HSTART="00"
dadosdir="/home/operador/grads/cosmo/cosmo${AREA}/dados${HH}"
dpns5dir="/home/operador/grads/cosmo/cosmo${AREA}"
datahoje=`cat /home/operador/datas/datacorrente${HH}`
datagrads=`/usr/bin/caldate $datahoje$HH + 0h 'hhZddmmmyyyy'`

echo "Os seguintes parametros foram passados para o script"
echo "AREA=$AREA"
echo "HH=$HH - horario de referencia da rodada "

case ${AREA} in
	met)
	HSTOP=78
	AREA2="met5"
	AREA3="met"
	ctls="M P Z"
	DIVS="3 3 3"
	INT="3" 
	;;
	ant)
	HSTOP=78
	AREA2="ant"
	ctls="M P V unrotV PDEF_M unrotPDEF"
	DIVS="3 3 1 1 3 3"
	INT="3" 
	;;
	inmet)
	HSTOP=27
	AREA2="inmet"
	ctls="M P"
	DIVS="1 1 1"
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
	cat ${dpns5dir}/ctl/cosmo_${AREA2}_HH_$L.ctl | sed -e 's|HH|'$HH'|' > raw
	RFILE=cosmo_${AREA2}_${HH}_${datahoje}${prog}
	cat raw | sed -e 's|DATAGRADS|'$datagrads'|'> raw2
	cat raw2 | sed -e 's|NOMEGRIB|cosmo_'$AREA2'_'$HH'_'$datahoje'|' > raw
	cat raw | sed -e 's|PROGFINAL|'$tt'|' > raw2
	mv raw2 cosmo_${AREA2}_${HH}_$L.ctl
	rm raw raw2 
	n=`grep -c "dtype grib" cosmo_${AREA2}_${HH}_$L.ctl`
   
	if [ $n != 0 ];then

		/usr/local/bin/gribmap -i cosmo_${AREA2}_${HH}_$L.ctl

	fi

	if ! [ -z $AREA3 ];then

	ln -sf  ${dpns5dir}/ctl/ctl${HH}/cosmo_${AREA2}_${HH}_${L}.ctl ${dpns5dir}/ctl/ctl${HH}/cosmo_${AREA3}_${HH}_${L}.ctl
	ln -sf  ${dpns5dir}/ctl/ctl${HH}/cosmo_${AREA2}_${HH}_c.ctl ${dpns5dir}/ctl/ctl${HH}/cosmo_${AREA3}_${HH}_c.ctl

	fi
i=$((i+1))

done
