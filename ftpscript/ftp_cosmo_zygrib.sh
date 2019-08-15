#!/bin/bash -x
#
# Script para ftp_cosmomet.sh
#
# Autor: CT(T) Leandro Machado Cruz 
#==================================================================================

#testando se o paramentro referente o horario da rodada foi passado
#
if [ $# -ne 4 ];then

	echo "Entre com a area modelada (met, sse, ne, pry, ant), com o horario de referencia (00 ou 12) e com o horario inicial e o prognostico final (24, 48, 71, ..)!!!!"
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
	;;
	ant)
	STATUS1=62
	AREA2=antartica
	AREA3=${AREA}
	;;
	ne)
	STATUS1=
	AREA2=ne
	AREA3=${AREA}
	;;
esac

if [ $HH -eq 00 ];then

	STATUS=$STATUS1

fi

if [ $HH -eq 12 ];then

	STATUS=`expr $STATUS1 + 1`

fi

echo " As seguintes variaveis foram carregadas da seguinte forma: "
echo " STATUS=$STATUS - Numero necessario para atualizar pagina de STATUS"
echo " AREA2=$AREA2 - Nome por extenso da AREA que estamos rodando"
echo " AREA3=$AREA3 - Sigla utilizada para composicao do nome do arquivo GRIB cosmo_AREA3_HH_YYYYMMDDprog"

dadossevidor="/home/operador/data/cosmo/${AREA2}/data/prevdata${HH}"
dadosdir="/home/operador/grads/cosmo/cosmo${AREA}/dados${HH}"
dpns5dir="/home/operador/grads/cosmo/cosmo${AREA}"
gifdir="/home/operador/grads/gif/cosmo${AREA}_${HH}"
dpnt02bdir="/home/supervisor/Servico/Modelos/cosmo_${AREA}${HH}"
dpnt02dir="/home/supervisor/Servico/Modelos/cosmo_${AREA}${HH}"
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

/home/operador/grads/faxsimile/scripts/faxsimile.sh cosmo${AREA} ${HH} &

DIG='0'
for HREF in `seq $HSTART 3 $HSTOP`;do

	if [ $HREF -lt 10 ];then

		HORA=0$DIG$HREF

	elif [ $HREF -lt 100 ];then

		HORA=$DIG$HREF

	else

		HORA=$HREF

	fi

	str="${str} ${HORA}"

done

echo "Gerei uma string contendo todos os prognosticos de previsao entre 00 e $HSTOP com intervalo de 3 horas"
echo "Quando a extensao da previsao e maior do que 99h eu devo adcionar um digito a todos os prognosticos, ficando 000, 003 .... 120"
echo " Os prognosticos serao:"
echo "$str"

echo "Apagando as figuras no diretorio local"

if [ $HSTART == "00" ];then

	rm -f ${gifdir}/*.gif
	rm -f ${gifdir}/*.png
	rm -f ${gifdir}/internet/*

fi

#*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.

# Passo 0 - Verifica se o COSMO da Area e horario especificado terminou a rodada
#          senao espera ateh 2 horas
#
#
for prog in `echo ${str}`;do

	flag=1
	ni=0
	RFILE=cosmo_${AREA3}_${HH}_${datahoje}${prog} 

	while [ $flag -eq 1 ];do 

		if  [ -e ${dadossevidor}/${RFILE} ] ; then

			echo "Prontificado o prognostico de ${prog}h do COSMO ${AREA}"
			COR=1 # Amarelo
			/usr/local/bin/atualiza_status.pl ${STATUS} ${COR} "RODANDO - PRONTIFICADA A PREVISAO PARA ${prog}h"
			/usr/local/bin/atualiza_status.pl ${STATUS2} ${COR} "RODANDO - PRONTIFICADA A PREVISAO PARA ${prog}h"
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
			COR=2 #Vermelho
			/usr/local/bin/atualiza_status.pl ${STATUS} ${COR} "FALHA NO POS-PROCESSAMENTO - CRASH IN POST-PROCESSING"
			/usr/local/bin/atualiza_status.pl ${STATUS2} ${COR} "FALHA NO POS-PROCESSAMENTO - CRASH IN POST-PROCESSING"
			progant=$((prog-3))
			echo $progant > /home/operador/grads/cosmo/cosmo${AREA}/ctl/ctl${HH}/progfinal 

			# o cvmt roda corte vertical e meteogramas

			/home/operador/grads/cosmo/scripts/rodacvmt.sh ${AREA} ${HH} 

			/home/operador/grads/cctom/scripts/cctom.sh cosmo${AREA} ${HH} 

			/home/operador/grads/asafixa/scripts/asafixanew.sh cosmo${AREA} ${HH}

			#/home/operador/grads/asafixa/scripts/asafixanew.sh cosmosse_ ${HH}

			exit 12

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
	/home/operador/grads/cosmo/scripts/geractl_prog.sh $AREA $HH $prog

	rm *raw*

	echo
	echo executando GrADs...
	date
	echo

	${dpns5dir}/../scripts/roda.sh ${AREA} ${HH} ${prog}

	echo
	echo transferindo gif...
	echo

	cd $gifdir

	for arq in `ls *${prog}.gif`;do  

		nomeprog=`echo $arq | cut -f1 -d.`
		/usr/bin/convert $arq $nomeprog.png 

	done 

	/usr/bin/convert tempmar.gif tempmar.png


        ${dpns5dir}/../scripts/roda_carta_automatica.sh ${AREA} ${HH} ${prog}
	${dpns5dir}/../scripts/roda_zoom_ant.sh ${AREA} ${HH} ${prog}

        echo
        echo transferindo gif...
        echo

        cd $gifdir

        for arq in `ls *${prog}.gif`;do

                nomeprog=`echo $arq | cut -f1 -d.`
                /usr/bin/convert $arq $nomeprog.png

        done


##############################################################
# Mudar aki pra voltar de 2 digitos para 3
      if [ $AREA == "met" ] ;then

		progb=`echo "$prog * 1" | bc`

#		if [ $progb -le 99 ];then
#
#			prog=`echo $prog | cut -c2-3`
#
#		fi

		###########Cosmo Sul-Sudeste###########
		${dpns5dir}/../scripts/roda.sh sse ${HH} ${prog}
  		${dpns5dir}/../scripts/roda_carta_automatica.sh sse ${HH} ${prog}

		AREAN="sse"
		gifdirn="/home/operador/grads/gif/cosmo${AREAN}_${HH}"

		cd $gifdirn

		for arq in `ls *${prog}.gif`;do

			nomeprog=`echo $arq | cut -f1 -d.`
			/usr/bin/convert $arq $nomeprog.png
		done

		###########Cosmo Paraguai###############
		${dpns5dir}/../scripts/roda.sh pry ${HH} ${prog}

		AREAN="pry"
		gifdirn="/home/operador/grads/gif/cosmo${AREAN}_${HH}"

		cd $gifdirn

		for arq in `ls *${prog}.gif`;do

			nomeprog=`echo $arq | cut -f1 -d.`
			/usr/bin/convert $arq $nomeprog.png

		done

		###########Cosmo Nordeste###########
		${dpns5dir}/../scripts/roda.sh ne ${HH} ${prog}
  		${dpns5dir}/../scripts/roda_carta_automatica.sh ne ${HH} ${prog}

		AREAN="ne"
		gifdirn="/home/operador/grads/gif/cosmo${AREAN}_${HH}"

		cd $gifdirn

		for arq in `ls *${prog}.gif`;do

			nomeprog=`echo $arq | cut -f1 -d.`
			/usr/bin/convert $arq $nomeprog.png

		done

	fi


done
echo
echo =======================================================================

/home/operador/grads/cosmo/cosmo${AREA}/meteogramas/scripts/gerameteogramas.sh ${AREA} ${HH}

echo $prog > /home/operador/grads/cosmo/cosmo${AREA}/ctl/ctl${HH}/progfinal

MSG="ENCERRADO - FINISHED"
COR=0
/usr/local/bin/atualiza_status.pl $STATUS $COR "$MSG"
/usr/local/bin/atualiza_status.pl $STATUS2 $COR "$MSG"

/home/operador/grads/cosmo/scripts/rodacvmt.sh ${AREA} ${HH} 

# Script para gerar os campos de tendencia de T, que precisam do ctl completo.
echo =======================================================================
echo "Script para gerar os campos de tendencia de T, que precisam do ctl completo."
echo

if [ $AREA == "met" ] ;then
	for areas in met sse ne;do
		/home/operador/grads/cosmo/scripts/roda_final.sh ${areas} ${HH} ${HSTART} ${HSTOP}
	done
fi

if [ $AREA == "ant" ];then

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH

	/opt/opengrads/opengrads -bpc "run /home/operador/grads/cosmo/scripts/unrotwind.gs ${AREA} ${HH}"
	/opt/opengrads/opengrads -bpc "run /home/operador/grads/cosmo/scripts/unrotauxilio.gs ${AREA} ${HH}"
	/home/operador/grads/auxilio_decisao/scripts/auxilio.sh ${HH} cosmo${AREA}

#        ${dpns5dir}/../scripts/roda_zoom_ant.sh ${AREA} ${HH} ${prog}

fi

#/home/operador/grads/cosmo/scripts/rodacvmt.sh sse_ ${HH}

/home/operador/grads/cctom/scripts/cctom.sh cosmo${AREA} ${HH} 

/home/operador/grads/asafixa/scripts/asafixa.sh cosmo${AREA} ${HH}

/home/operador/ftp_comissoes/ftp_comissoes.sh ${HH} cosmo${AREA}

#Comentei em 28102014 para teste lembrar de descomentar

/home/operador/grads/auxilio_decisao/scripts/auxilio.sh ${HH} cosmo${AREA}

if [ $AREA == "met" ];then

	ssh gempak@dpns27 /home/gempak/cosmo/scripts/geradados.sh ${HH} &

fi

/home/operador/grads/faxsimile/scripts/faxsimile.sh cosmo${AREA} ${HH} &

