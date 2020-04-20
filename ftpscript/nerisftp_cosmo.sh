#!/bin/bash -x
#
# Script para ftp_cosmomet.sh
#
# Autor: CT(T) Leandro Machado Cruz 
#==================================================================================

###################################################################################
#Variavel Rodada utilizada para atualizar a pagina de status.
#Para as execucoes de desenvolvimento a variavel deve ser setada Teste
#Para as execucoes agendadas ou disparadas pelo OAM a variavel deve ser setada Operacional
#####################################################################

# Variavel criada para o script input_status.php para indicar que e uma rodada real.
RODADA="Operacional"

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
datahoje=`cat /home/operador/datas/datacorrente${HH}`
datagrads=`cat /home/operador/datas/datacorrente_grads${HH}`

MSG="POS-PROC DO COSMO${AREA} ${datahoje} ${HH}Z INICIADO"

/usr/bin/input_status.php cosmo${AREA} ${HH} ${RODADA} AMARELO "${MSG}"

echo 
date
echo

echo "Os seguintes parametros foram passados para o script"
echo "AREA=$AREA"
echo "HH=$HH - horario de referencia da rodada "
echo "HSTOP=$HSTOP - extensao temporal em horas da previsao"

case ${AREA} in
	met)
	STATUS1=60
	dirdadraw="/home/operador/data/cosmo/metarea5/data/prevdata${HH}"
	dirdad="/home/operador/grads/cosmo/cosmomet/dados${HH}"
	dpns5dir="/home/operador/grads/cosmo"
	gifdir="/home/operador/grads/gif/cosmo${AREA}_${HH}"
	RFILE0="cosmo_met5_${HH}_${datahoje}"
	;;
	sse)
	STATUS1=60
	dirdadraw="/home/operador/data/cosmo/metarea5/data/prevdata${HH}"
	dirdad="/home/operador/grads/cosmo/cosmomet/dados${HH}"
	dpns5dir="/home/operador/grads/cosmo"
	gifdir="/home/operador/grads/gif/cosmo${AREA}_${HH}"
	RFILE0="cosmo_met5_${HH}_${datahoje}"
	;;
	nne)
	STATUS1=60
	dirdadraw="/home/operador/data/cosmo/metarea5/data/prevdata${HH}"
	dirdad="/home/operador/grads/cosmo/cosmomet/dados${HH}"
	dpns5dir="/home/operador/grads/cosmo"
	gifdir="/home/operador/grads/gif/cosmo${AREA}_${HH}"
	RFILE0="cosmo_met5_${HH}_${datahoje}"
	;;
	pry)
	STATUS1=60
	dirdadraw="/home/operador/data/cosmo/metarea5/data/prevdata${HH}"
	dirdad="/home/operador/grads/cosmo/cosmomet/dados${HH}"
	dpns5dir="/home/operador/grads/cosmo"
	gifdir="/home/operador/grads/gif/cosmo${AREA}_${HH}"
	RFILE0="cosmo_met5_${HH}_${datahoje}"
	;;
	sse22)
	STATUS1=60
	dirdadraw="/home/operador/data/cosmo/sse/data/prevdata${HH}"
	dirdad="/home/operador/grads/cosmo/cosmosse22/dados${HH}"
	dpns5dir="/home/operador/grads/cosmo"
	gifdir="/home/operador/grads/gif/cosmo${AREA}_${HH}"
	RFILE0="cosmo_sse22_${HH}_${datahoje}"
	;;
	ant)
	STATUS1=62
	dirdadraw="/home/operador/data/cosmo/antartica/data/prevdata${HH}"
	dirventant="/home/operador/data/cosmo/antartica/data/ventogrib${HH}"
	dirdad="/home/operador/grads/cosmo/cosmoant/dados${HH}"
	dpns5dir="/home/operador/grads/cosmo"
	gifdir="/home/operador/grads/gif/cosmo${AREA}_${HH}"
	RFILE0="cosmo_ant_${HH}_${datahoje}"
	;;
esac

# Status para o script input_status.php
if [ $HH -eq 00 ];then

	STATUS=$STATUS1

fi

if [ $HH -eq 12 ];then

	STATUS=`expr $STATUS1 + 1`

fi

echo " As seguintes variaveis foram carregadas da seguinte forma: "
echo " STATUS=$STATUS - Numero necessario para atualizar pagina de STATUS"

echo " Li as datas dos arquivos de datacorrente da seguinte forma:"
echo " datahoje=$datahoje"
echo " datagrads=$datagrads"
echo " Se as datas estiverem desatualizadas desconfie que o script ledata.sh nao atualizou os arquivos de datacorrente"


if [ $HSTART == "00" ] && [ $HSTOP == "96" ];then

	echo Removendo os arquivos ctl, dados e figuras supostamente antigas...
	echo rm /home/operador/grads/cosmo/cosmo${AREA}/ctl/ctl${HH}/*
	echo rm /home/operador/grads/cosmo/cosmo${AREA}/dados${HH}/*
	echo rm -f ${gifdir}/*.gif
	echo rm -f ${gifdir}/*.png
	echo rm -f ${gifdir}/internet/*
	
fi


#*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.

# Passo 0 - Verifica se o COSMO da Area e horario especificado terminou a rodada
#          senao espera ateh 2 horas
#
#
for prog in `seq -f "%03g" $HSTART 3 $HSTOP`;do

	flag=1
	ni=0
	RFILE=${RFILE0}${prog}

	while [ $flag -eq 1 ];do 

		if  [ -e ${dirdadraw}/${RFILE} ] ; then

			echo "Prontificado o prognostico de ${prog}h do COSMO ${AREA}"
			
		
			echo cp ${dirdadraw}/${RFILE}* ${dirdad}
			flag=0
                        MSG="INICIANDO POS-PROC PROG ${prog}h COSMO${AREA} ${datahoje} ${HH}Z"
                       #/usr/bin/input_status.php cosmo${AREA} ${HH} ${RODADA} AMARELO "${MSG}"

		else

			echo "Prognostico de ${prog}h do COSMO ${AREA} ainda nao foi prontificado"
			k=`expr $ni + 1`
			ni=$k
		        resto=`expr $k % 20`
                        if [ $resto -eq 0 ]; then
                        min=`echo "$k * 30 / 60" | bc`
                        MSG="AGUARDANDO HA $min MIN PROG ${prog}h DO COSMO${AREA} ${datahoje} ${HH}Z"
                        #/usr/bin/input_status.php COSMO${AREA} $HH $RODADA AMARELO "$MSG"
                        fi
	

                        sleep 30 

		fi   
  
  		if [ $ni -ge 480 ] ; then

			echo "Apos 4 horas abortei a rodada !!!!"
			MSG="FALHA NO POS-PROC - PROG ${prog}h COSMO${AREA} ${datahoje} ${HH}Z AUSENTE"
			#/usr/bin/input_status.php cosmo${AREA} ${HH} ${RODADA} VERMELHO "${MSG}"
			progfinal=$((prog-3))
			echo $progfinal > /home/operador/grads/cosmo/cosmo${AREA}/ctl/ctl${HH}/progfinal 

			# o cvmt roda corte vertical e meteogramas

			echo /home/operador/grads/cosmo/scripts/rodacvmt.sh ${AREA} ${HH} 

			echo /home/operador/grads/cctom/scripts/cctom.sh cosmo${AREA} ${HH} 

			echo /home/operador/grads/asafixa/scripts/asafixa.sh cosmo${AREA} ${HH}

			exit 12

		fi

	done

	# Isso pertence ao pos do ww3? Como ele nao remove os dados de vento anteriores, talvez ele esteja fazendo o ww3 para previsoes errados
        if [ $AREA == "ant" ];then
                echo cp ${dirventant}/lfff*  ${dpns5dir}/ww3_unrot${HH}
        fi

	#*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.


	echo =======================================================================
	echo
	echo POS-PROCESSAMENTO DO COSMO ${AREA} ${HH}Z Prognostico de $prog h 
	date
	echo

	sleep 3
	echo
	echo 

	# gerando o CTL do prognostico PROG
	echo /home/operador/grads/cosmo/scripts/nerisgeractl_prog.sh $AREA $HH $prog

	echo rm *raw*

	echo
	echo executando GrADs...
	date
	echo

	echo ${dpns5dir}/scripts/roda.sh.neris ${AREA} ${HH} ${prog}

        echo ${dpns5dir}/scripts/roda_carta_automatica.sh ${AREA} ${HH} ${prog}

	if [ $AREA == "ant" ];then

		echo ${dpns5dir}/scripts/roda_zoom_ant.sh 	${AREA} ${HH} ${prog}

	fi

        echo
        echo transferindo gif...
        echo

        cd $gifdir

        for arq in `ls *${prog}.gif`;do

                echo nomeprog=`echo $arq | cut -f1 -d.`
                echo /usr/bin/convert $arq $nomeprog.png

        done

done


echo
echo =======================================================================
echo " Terminei a parte dos campos 2D. Vou comecar a parte dos"
echo " meteogramas, cortes verticais, asafixa, etc."
echo

echo "$prog > /home/operador/grads/cosmo/cosmo${AREA}/ctl/ctl${HH}/progfinal"

echo /home/operador/grads/cosmo/cosmo${AREA}/meteogramas/scripts/gerameteogramas.sh ${AREA} ${HH}

echo /home/operador/grads/cosmo/scripts/rodacvmt.sh ${AREA} ${HH} 

echo /home/operador/grads/faxsimile/scripts/faxsimile.sh cosmo${AREA} ${HH}

echo /home/operador/grads/cctom/scripts/cctom.sh cosmo${AREA} ${HH}

echo /home/operador/grads/asafixa/scripts/asafixa.sh cosmo${AREA} ${HH}

echo /home/operador/ftp_comissoes/ftp_comissoes.sh ${HH} cosmo${AREA}

####### O script do auxilio foi comento porque o processamento do ww3 fica 
####### pronto depois que o pos do cosmo termina. Esse e o motivo de gerar
####### a figura em branco
#/home/operador/grads/auxilio_decisao/scripts/auxilio.sh ${HH} ww3${AREA}

# Script para gerar os campos de tendencia de T, que precisam do ctl completo.
echo =======================================================================
echo "Script para gerar os campos de tendencia de T, que precisam do ctl completo."
echo

if [ $AREA == "met" ];then
	for areas in met sse ne;do
		echo /home/operador/grads/cosmo/scripts/roda_final.sh ${areas} ${HH} ${HSTART} ${HSTOP}
		
	done
	
fi

echo ========================================================================
echo Copiando as figuras para a pasta internet
echo ========================================================================
echo "/home/operador/ftpscript/ftp_internet.sh $HH cosmo     > /home/operador/ftpscript/logs/cosmo_internet.log"


if [ $AREA == "ant" ];then

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH

	echo Gerando ZYGRIB para comissoes na ANTARTICA...
	echo /opt/opengrads/opengrads -bpc "run /home/operador/grads/cosmo/scripts/unrotwind.gs ${AREA} ${HH}"
	echo /opt/opengrads/opengrads -bpc "run /home/operador/grads/cosmo/scripts/unrotauxilio.gs ${AREA} ${HH}"
	echo /home/operador/grads/auxilio_decisao/scripts/auxilio.sh ${HH} ww3${AREA} # 10out18 Subst 'cosmo' por 'ww3' CFM esperado pelo script
        #/home/operador/grads/cosmo/scripts/zygrib_cosmo.sh ${AREA} drakefull ${HH} ${HSTART} 72
        #/home/operador/grads/cosmo/scripts/zygrib_cosmo.sh ${AREA} drakecut ${HH} ${HSTART} 72
        #/home/operador/grads/cosmo/scripts/zygrib_cosmo.sh ${AREA} zoom ${HH} ${HSTART} 72
else

	echo Gerando ZYGRIB para comissoes na METAREA5...
	#/home/operador/grads/cosmo/scripts/zygrib_cosmomet.sh ${AREA} metnne ${HH} ${HSTART} ${HSTOP}
	#/home/operador/grads/cosmo/scripts/zygrib_cosmomet.sh metarea5 aderex ${HH} ${HSTART} ${HSTOP}
	#/home/operador/grads/cosmo/scripts/zygrib_cosmomet.sh met opamazonia ${HH} ${HSTART} 72
	#/home/operador/grads/cosmo/scripts/zygrib_cosmomet.sh met priesq ${HH} ${HSTART} 72
	#/home/operador/grads/cosmo/scripts/zygrib_cosmomet.sh met pirata ${HH} ${HSTART} 72

fi

MSG="ENCERRADO POS-PROC COSMO${AREA} ${datahoje} ${HH}Z"
/usr/bin/input_status.php cosmo${AREA} ${HH} ${RODADA} VERDE "${MSG}"
