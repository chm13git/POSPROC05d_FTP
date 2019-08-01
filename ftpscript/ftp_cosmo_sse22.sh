#!/bin/bash
#
# Script para ftp_cosmomet.sh
#
# Autor: CT(T) Leandro Machado Cruz 
#==================================================================================
set -x

#testando se o paramentro referente o horario da rodada foi passado
#
if [ $# -ne 4 ]
then
     echo "Entre com a area modelada (met, sse, sse22 e ant), com o horario de referencia (00 ou 12) e com o horario inicial e o prognostico final (24, 48, 71, ..)!!!!"
     exit
fi
AREA=$1
HH=$2
HSTART=$3
HSTOP=$4

date

echo "Os seguintes parametros foram passados para o script"
echo "AREA=$AREA"
echo "HH=$HH - horario de referencia da rodada "
echo "HSTOP=$HSTOP - extensao temporal em horas da previsao"

case ${AREA} in
	met)
	STATUS1=60
	AREA2=metarea5
	AREA3=${AREA}5
	HINT=3
	;;
	ant)
	STATUS1=62
	AREA2=antartica
	AREA3=${AREA}
	HINT=3
	;;
	sse22)
	STATUS1=20
	AREA2=sse
	AREA3=${AREA}
	HINT=1
	;;
esac

if [ $HH -eq 00 ];then

	STATUS=$STATUS1
fi

if [ $HH -eq 06 ];then

        STATUS=`expr $STATUS1 + 2`
fi

if [ $HH -eq 12 ];then

	STATUS=`expr $STATUS1 + 1`

fi

if [ $HH -eq 18 ];then

        STATUS=`expr $STATUS1 + 3`

fi


echo " As seguintes variaveis foram carregadas da seguinte forma: "
echo " STATUS=$STATUS - Numero necessario para atualizar pagina de STATUS"
echo " AREA2=$AREA2 - Nome por extenso da AREA que estamos rodando"
echo " AREA3=$AREA3 - Sigla utilizada para composicao do nome do arquivo GRIB cosmo_AREA3_HH_YYYYMMDDprog"

dadossevidor="/home/operador/data/cosmo/${AREA2}/data/prevdata${HH}"
dadosdir="/home/operador/grads/cosmo/cosmo${AREA}/dados${HH}"
dpns5dir="/home/operador/grads/cosmo/cosmo${AREA}"
gifdir="/home/operador/grads/gif/cosmo${AREA}_${HH}"
datahoje=`cat /home/operador/datas/datacorrente${HH}`
datagrads=`cat /home/operador/datas/datacorrente_grads${HH}`

echo " Li as datas dos arquivos de datacorrente da seguinte forma:"
echo " datahoje=$datahoje"
echo " datagrads=$datagrads"
echo " Se as datas estiverem desatualizadas desconfie que o script ledata.sh nao atualizou os arquivos de datacorrente"


echo "Removendo os arquivos ctl e dados do dia anterior"

if [ $HSTART == "00" ];then

	rm /home/operador/grads/cosmo/cosmo${AREA}/ctl/ctl${HH}/*
	rm /home/operador/grads/cosmo/cosmo${AREA}/dados${HH}/*

fi

echo "Executando a geracao da carta de TSM para o faxsimile"
echo "Rodarei o script /home/operador/grads/faxsimile/scripts/faxsimile.sh em background colocando um & apos chamar o script"
echo "Este script recebe o parametro cosmoAREA e HH "

#	if ! [ $AREA == "sse" ];then

#	/home/operador/grads/faxsimile/scripts/faxsimile.sh cosmo${AREA} ${HH} &

#	fi

DIG='0'
for HREF in `seq ${HSTART} ${HINT} ${HSTOP}`;do

	if [ $HREF -lt 10 ];then

		HORA=0$DIG$HREF

	elif [ $HREF -lt 100 ];then

		HORA=$DIG$HREF

	else

		HORA=$HREF

	fi

	str="${str} ${HORA}"
done

echo "Gerei uma string contendo todos os prognosticos de previsao entre 00 e $HSTOP com intervalo de ${HINT} horas"
echo "Quando a extensao da previsao e maior do que 99h eu devo adcionar um digito a todos os prognosticos, ficando 000, 003 .... 120"
echo " Os prognosticos serao:"
echo "$str"

echo "Apagando as figuras no diretorio local"

	if [ $HSTART == "00" ];then

		if [ $AREA == "sse22" ];then

			rm -f ${gifdir}/*.gif
			rm -f ${gifdir}/*.png
			rm -f /home/operador/grads/gif/cosmo_sse22zoom_${HH}/*

		else

		        rm -f ${gifdir}/*.gif
                        rm -f ${gifdir}/*.png
                        rm -f ${gifdir}/internet/*

		fi

	fi
#*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.

# Passo 0 - Verifica se o COSMO da Area e horario especificado terminou a rodada
#          senao espera ateh 2 horas
#
#
for prog in `echo ${str}`
do

	flag=1
	ni=0
	RFILE=cosmo_${AREA}_${HH}_${datahoje}${prog} 

	while [ $flag -eq 1 ];
	do 

		if  [ -e ${dadossevidor}/${RFILE} ] ; then

			echo "Prontificado o prognostico de ${prog}h do COSMO ${AREA}"
#			COR=1 # Amarelo
#			/usr/local/bin/atualiza_status.pl ${STATUS}  ${COR} "RODANDO - PRONTIFICADA A PREVISAO PARA ${prog}h"
#			/usr/local/bin/atualiza_status.pl ${STATUS2} ${COR} "RODANDO - PRONTIFICADA A PREVISAO PARA ${prog}h"
			cp ${dadossevidor}/${RFILE}* ${dadosdir}
			flag=0

		else

			echo "Prognostico de ${prog}h do COSMO ${AREA} ainda nao foi prontificado"
			k=`expr $ni + 1`
			ni=$k
			sleep 30 

		fi
  
		if [ $ni -ge 480 ] ; then

			echo "Apos 4 horas abortei a rodada !!!!"
#			COR=2 #Vermelho
#			/usr/local/bin/atualiza_status.pl ${STATUS}  ${COR} "FALHA NO POS-PROCESSAMENTO - CRASH IN POST-PROCESSING"
#			/usr/local/bin/atualiza_status.pl ${STATUS2} ${COR} "FALHA NO POS-PROCESSAMENTO - CRASH IN POST-PROCESSING"
			progant=$((prog-3))
			echo $progant > /home/operador/grads/cosmo/cosmo${AREA}/ctl/ctl${HH}/progfinal 

 #                        	if ! [ ${AREA} == "sse22" ];then
#
				# o cvmt roda corte vertical e meteogramas
#				/home/operador/grads/cctom/scripts/cctom.sh cosmo${AREA} ${HH} 
#				/home/operador/grads/asafixa/scripts/asafixanew.sh cosmo${AREA} ${HH}
				#/home/operador/grads/asafixa/scripts/asafixanew.sh cosmosse_ ${HH}

		# 	 	fi
		exit 33

		fi
  
	done 

	#*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.


	echo =======================================================================
	echo
	echo POS-PROCESSAMENTO DO COSMO ${AREA2} ${HH}Z Prognostico de $prog h 
	date
	echo
	
	sleep 3
	echo
	echo

	# gerando o CTL do prognostico PROG
	/home/operador/grads/cosmo/scripts/geractl_prog_sse22.sh $AREA $HH $prog
	rm *raw*

	echo
	echo executando GrADs...
	date
	echo

	${dpns5dir}/../scripts/roda_sse22.sh ${AREA} ${HH} ${prog}

	echo
	echo transferindo gif...
	echo

	cd $gifdir

	for arq in `ls *${prog}.gif`
	do  

		nomeprog=`echo $arq | cut -f1 -d.`
		/usr/bin/convert $arq $nomeprog.png 

	done

#	/usr/bin/convert tempmar.gif tempmar.png

	if [ $AREA == "sse22" ];then

		progb=`echo "$prog * 1" | bc`

			if [ $progb -le 99 ];then

				prog=`echo $prog | cut -c2-3`

			fi


	fi

done

echo
echo =======================================================================


# Ofuturo chegou ja geramos meteorgramas!!!!!

if  [ ${AREA} == "sse22" ];then
	/home/operador/grads/cosmo/scripts/geractl_progfinal.sh sse22 ${HH}
	/home/operador/grads/cosmo/cosmo${AREA}/meteogramas/scripts/gerameteogramas.sh sse22 ${HH}

#	MSG="ENCERRADO - FINISHED"
#	COR=0
#	/usr/local/bin/atualiza_status.pl $STATUS $COR "$MSG"
#	/usr/local/bin/atualiza_status.pl $STATUS2 $COR "$MSG"
#	/home/operador/grads/cosmo/scripts/rodacvmt.sh ${AREA} ${HH} 

fi
