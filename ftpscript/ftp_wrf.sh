#!/bin/bash -x
#
# Script para ftp_wrf.sh
#
#AUTOR CT(T) Leandro Machado
#==================================================================================

#testando se o parametro referente o horario da rodada foi passado
#
if [ $# -ne 4 ];then

     echo "Entre com a area modelada (metarea5 e caribe), com o horario de referencia (00 ou 12) e com o prognostico de inicio e de fim da rodada!!!"
     exit 001
fi

AREA=$1
HH=$2
HSTART=$3
HSTOP=$4

echo "Os seguintes parametros foram passados para o script"
echo "AREA=$AREA"
echo "HH=$HH - horario de referencia da rodada "
echo "HSTOP=$HSTOP - extensao temporal em horas da previsao"

case ${AREA} in

	metarea5)
	STATUS1=50
	AREA2=met
	AREA3=metarea5
	INT=3
	RODADA="Operacional"
	;;
	met510km)
	STATUS1=51
	AREA2=10km
	AREA3=met510km
	INT=3
	RODADA="Teste"
	;;
	antartica)
	STATUS1=52
	AREA2=ant
	AREA3=antartica
	INT=3
	RODADA="Operacional"
	;;
	caribe)
	STATUS1=53
	AREA2=caribe
	AREA3=$AREA
	INT=3
	RODADA="Teste"
	;;
	met507km)
        STATUS1=54
        AREA2=07km
        AREA3=met507km
        INT=3
	RODADA="Teste"
	;;
	cptec)
#       STATUS1=50
        AREA2=cptec
        AREA3=cptec
        INT=1
        RODADA="Operacional"
esac

if [ $HH -eq 00 ];then

	STATUS=$STATUS1

else

	STATUS=`expr $STATUS1 + 1`

fi



echo " As seguintes variaveis foram carregadas da seguinte forma: "
echo " STATUS=$STATUS - Numero necessario para atualizar pagina de STATUS"
echo " AREA2=$AREA2 - sigla utilizada para disparar o script de COMISSOES"
echo " AREA3=$AREA3 - Sigla utilizada para composicao do nome do arquivo GRIB wrf_AREA3_HH_YYYYMMDDprog"

dados_grib="/home/operador/data/wrf/${AREA}/grib_${HH}"

dpns5dir="/home/operador/grads/wrf/wrf_${AREA}"
dadosdir="${dpns5dir}/dados${HH}"
dir_upp="${dpns5dir}/grib_${HH}"
dir_ctl="${dpns5dir}/ctl"

gifdir="/home/operador/grads/gif/wrf_${AREA}_${HH}"

dpnt02bdir="/home/supervisor/Servico/Modelos/wrf_${AREA}${HH}"
dpnt02dir="/home/supervisor/Servico/Modelos/wrf_${AREA}${HH}"
datahoje=`cat /home/operador/datas/datacorrente${HH}`
datagrads=`cat /home/operador/datas/datacorrente_grads${HH}`
datastatus=`cat /home/operador/datas/data_status${HH}`

MSG="POS-PROC DO WRF${AREA2} ${datahoje}${HH} INICIADO"
/usr/bin/input_status.php wrf${AREA2} ${HH} ${RODADA} AMARELO "${MSG}"


echo " Li as datas dos arquivos de datacorrente da seguinte forma:"
echo " datahoje=$datahoje"
echo " datagrads=$datagrads"
echo " Se as datas estiverem desatualizadas desconfie que \
       o script ledata.sh nao atualizou os arquivos de datacorrente"


echo "Removendo os arquivos ctl e dados do dia anterior"

rm ${dir_ctl}/ctl${HH}/*
rm ${dir_upp}/wrf_${AREA}_*
rm ${dir_arw}/wrf_${AREA}_*

echo "Apagando as figuras no diretorio local"

#if [ $HSTART == "00" ];then
#
#	
#		rm -f ${gifdir}/*.gif
#		rm -f ${gifdir}/*.png
#		rm -f ${gifdir}/internet/*
#
#	if [ $AREA == "metarea5" ];then
#
#		# Remove os arquivos antigos da METAREA5
#		# e do ZOOM da area SSUDESTE.
#
#		rm -f /home/operador/grads/gif/wrf_ssudeste_${HH}/*
#		rm -f /home/operador/grads/gif/wrf_nnordeste_${HH}/*
#
#        elif [ $AREA == "antartica" ];then
#
#		# Remove os arquivos antigos da ANTARTICA
#		# e do ZOOM da area DRAKE.
#
#		rm -f /home/operador/grads/gif/wrf_drakeant_${HH}/*
#
#        elif [ $AREA == "met510km" ];then
#
#		# Remove os arquivos antigos da MET510KM
#		# e do ZOOM da area SSUDESTE.
#
#		rm -f /home/operador/grads/gif/wrf_sse10km_${HH}/*
#
#        elif [ $AREA == "cptec" ];then
#
#                # Remove os arquivos antigos da CPTEC
#                # e do ZOOM da area SSUDESTE.
#
#                rm -f /home/operador/grads/gif/wrf_cptecsse_${HH}/*
#
#	fi
#
#fi

DIG='0'

for HREF in `seq $HSTART $INT $HSTOP`;do

	if [ $HREF -lt 10 ];then

		HORA=0$DIG$HREF

	elif [ $HREF -lt 100 ];then

		HORA=$DIG$HREF

	else

		HORA=$HREF

	fi

	str="${str} ${HORA}"

done

echo "Gerei uma string contendo todos os prognosticos de previsao \
     entre $HSTART e $HSTOP com intervalo de 3 horas"
echo "Quando a extensao da previsao e maior do que 99h eu devo \
     adicionar um digito a todos os prognosticos, ficando 000, 003 .... 120"

echo " Os prognosticos serao:"
echo "$str"

#*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.

# Passo 0 - Verifica se o WRF da Area e horario especificado terminou a rodada
#          senao espera ateh 2 horas
#
#
for prog in `echo ${str}`;do

	flag=1
	ni=0

	dados=${dados_grib}
	RFILE=wrf_${AREA3}_${HH}_${datahoje}${prog} 


	# Testa se o UPP ja rodou o horario 

	while [ $flag -eq 1 ];do

		if  [ -e ${dados}/${RFILE} ] ; then

			echo "Prontificado o prognostico de ${prog}h do WRF ${AREA}"
			MSG="INICIANDO POS-PROC DO PROG ${prog}h WRF${AREA2} ${datahoje} ${HH}Z"
                       /usr/bin/input_status.php wrf${AREA2} ${HH} ${RODADA} AMARELO "${MSG}"

                        flag=0


		else

			echo "Prognostico de ${prog}h do WRF ${AREA} ainda nao foi prontificado"
			k=`expr $ni + 1`
			ni=$k
			sleep 30
                        resto=`expr $k % 20`
                        if [ $resto -eq 0 ]; then
                        min=`echo "$k * 30 / 60" | bc`
                        MSG="AGUARDANDO HA $min MIN PROG ${prog}h DO WRF${AREA2} ${datastatus} ${HH}Z A SER PRONTIFICADO"
                        /usr/bin/input_status.php WRF${AREA2} $HH $RODADA AMARELO "$MSG"
                        fi
 

			if [ $ni -ge 480 ] ; then
# editado hoje 123   25082017
#				echo "Apos 4 horas abortei a rodada !!!!"
#				MSG="FALHA NO POS-PROC - PROG ${prog}h WRF${AREA2} ${datastatus} ${HH}Z AUSENTE"
#				/usr/bin/input_status.php wrf${AREA2} ${HH} ${RODADA} VERMELHO "${MSG}"
                                progant=$((prog-$INT))
				echo $progant > /home/operador/grads/wrf/wrf_${AREA}/ctl/ctl${HH}/progfinal 

				# o cvmt roda corte vertical e meteogramas

				/home/operador/grads/wrf/scripts/rodacvmt.sh 		${AREA}		${HH} 
				/home/operador/grads/cctom/scripts/cctom.sh 		wrf${AREA}	${HH} 
				/home/operador/grads/wrf/scripts/monta_meteogramas.sh   ${AREA} wrf     ${HH} 
				#/home/operador/grads/asafixa/scripts/asafixanew.sh 	wrf${AREA}	${HH}
				#/home/operador/grads/asafixa/scripts/asafixanew.sh 	wrfsse_10km	${HH}

			exit 12

			fi
		fi
  
	done

	#*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.


	echo =======================================================================
	echo
	echo POS-PROCESSAMENTO DO WRF ${AREA} ${HH}Z Prognostico de $prog h 
	date
	echo

	ln -sf ${dados_grib}/${RFILE} 		${dir_upp}

        # Executa o script para criacao do FAXSIMILE

       if [ ${prog} -eq 000 ] && [ ${AREA} == "metarea5" ];then

		echo " Entrando no script de execucao do faxsimile."

		/home/operador/grads/faxsimile/scripts/faxsimile.sh wrfmet ${HH}

	fi

	temp=1

	echo
	echo executando GrADs...
	date
	echo
	
	if [ $temp -ne 0 ];then

		${dpns5dir}/../scripts/geractl_prog.sh 		${AREA} ${HH} ${prog}
		${dpns5dir}/../scripts/roda.sh 		        ${AREA} ${HH} ${prog}
		${dpns5dir}/../scripts/rodacarta_extremos.sh    ${AREA} ${HH} ${prog} 

		echo
		echo transferindo gif...
		echo

		cd $gifdir

		for arq in `ls *${prog}.gif`;do

			nomeprog=`echo $arq | cut -f1 -d.`
			/usr/bin/convert $arq $nomeprog.png 

		done 

		/usr/bin/convert tempmar.gif tempmar.png

		cd /home/operador/grads/gif/wrf_drakeant_${HH}/

                for arq in `ls *${prog}.gif`;do

                        nomeprog=`echo $arq | cut -f1 -d.`
                        /usr/bin/convert $arq $nomeprog.png

                done


		cd /home/operador/grads/gif/wrf_ssudeste_${HH}/
		
		for arq in `ls *${prog}.gif`;do

                        nomeprog=`echo $arq | cut -f1 -d.`
                        /usr/bin/convert $arq $nomeprog.png

                done

		
	fi

	echo $prog > /home/operador/grads/wrf/wrf_${AREA}/ctl/ctl${HH}/progfinal

done

rm *raw*

# Script para criacao de meteogramas a partir de arquivos txt
# Ainda nao implementado. Scrit comentado

#/home/operador/grads/wrf/wrf_${AREA}/meteogramas/scripts/gerameteogramas.sh ${HH} ${AREA}


/home/operador/grads/wrf/scripts/rodacvmt.sh	 			${AREA} ${HH} ${HSTOP}
/home/operador/grads/wrf/scripts/monta_meteogramas.sh                   ${AREA} wrf   ${HH}
/home/operador/grads/auxilio_decisao/scripts/auxilio.sh 		${HH} ww3${AREA2}

# Script para gerar os campos de tendencia de T, que precisam do ctl completo.
echo =======================================================================
echo "Script para gerar os campos de tendencia de T, que precisam do ctl completo."
echo

if [ $AREA == "metarea5" ] ;then
	/home/operador/grads/wrf/scripts/roda_final.sh ${AREA} ${HH} ${HSTART} ${HSTOP}
fi

if [ ${AREA} == "metarea5" ];then

	/home/operador/grads/cctom/scripts/cctom.sh 				wrf${AREA} ${HH} 

# Comentei o script abaixo pois o BNDO solicitou que todas
# as figuras tivessem tres digitos. No entanto vou deixar o script
# para um possivel uso futuro.
#
# 1T(T) Alexandre Gadelha 09NOV15
#	${dpns5dir}/../scripts/converte_internet.sh 				${HH} ${HSTART} ${HSTOP}

	/home/operador/grads/asafixa/scripts/asafixa.sh 			wrf${AREA} ${HH}

	/home/operador/ftp_comissoes/ftp_comissoes.sh 				${HH} wrf${AREA2}

	ssh gempak@dpns27 /home/gempak/wrf/scripts/dispara_geradados.sh 	${HH} &

fi

if [ ${AREA} == metarea5 ]
	then
		if [ -e ${dados_grib}/wrf_metarea5_${HH}_${datahoje}120 ] 
			then 
				sleep 5 
				MSG="POS-PROC WRF${AREA2} ${datastatus} ${HH}Z FINALIZADO"
				/usr/bin/input_status.php wrf${AREA2} ${HH} ${RODADA} VERDE "${MSG}"
			else 
				sleep 5 
				MSG="FALHA NO POS-PROC - PROG ${prog}h WRF${AREA2} ${datastatus} ${HH}Z AUSENTE"
               			/usr/bin/input_status.php wrf${AREA2} ${HH} ${RODADA} VERMELHO "${MSG}"
        	fi                        
	else 
 		if [ -e  ${dados_grib}/wrf_antartica_${HH}_${datahoje}096 ]
			then 
				sleep 5 
				MSG="POS-PROC WRF${AREA2} ${datastatus} ${HH}Z FINALIZADO"
        			/usr/bin/input_status.php wrf${AREA2} ${HH} ${RODADA} VERDE "${MSG}"  		
			else
				sleep 5 
				 MSG="FALHA NO POS-PROC - PROG ${prog}h WRF${AREA2} ${datastatus} ${HH}Z AUSENTE"
                                /usr/bin/input_status.php wrf${AREA2} ${HH} ${RODADA} VERMELHO "${MSG}"
		fi
fi 

