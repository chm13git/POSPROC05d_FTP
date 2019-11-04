#!/bin/bash -xv

#######################################################
# Script para geracao dos produtos do ICON            #
# Elaborado pela CT(T) Alana e Ten Fabíola em OUT2019 #
# O Modelo ICON está com 13km de resolução global     #
#######################################################

HH=$1
HSTART=0
HSTOP=1
moddir="/home/operador/grads/icon_13km"
arqctls="icon13km_1000_FI.ctl icon13km_500_FI.ctl icon13km_850_FI.ctl icon13km_U_10M.ctl icon13km_V_10M.ctl icon13km_T_2M.ctl icon13km_TD_2M.ctl icon13km_850_U.ctl icon13km_850_V.ctl icon13km_500_U.ctl icon13km_500_V.ctl icon13km_250_U.ctl icon13km_250_V.ctl icon13km_PMSL.ctl icon13km_RAIN_CON.ctl icon13km_RAIN_GSP.ctl icon13km_SNOW_CON.ctl icon13km_SNOW_GSP.ctl"
areas="atl met ant"

if [ $# -ne 1 ];then

	echo " Voce deve entrar com o horario de referencia 00 ou 12"
	exit 12

fi

datacorrente=`cat /home/operador/datas/datacorrente${HH}`
datagrads=`cat /home/operador/datas/datacorrente_grads${HH}| tr '[:upper:]' '[:lower:]'`
dadosdir="/home/operador/grads/icon_13km/dados/dados${HH}"
ctldir="/home/operador/grads/icon_13km/ctl"
scriptdir="/home/operador/grads/icon_13km/scripts"

date

	echo =========================================================================
	echo Iniciando o ICON 13km .............
	echo Começando pelo Script "get_icon13.sh" que faz download dos dados de ${HH}Z
	echo ==========================================================================

#	/home/operador/grads/icon_13km/scripts/get_icon13.sh ${HH}

	echo
	echo criando o ctl
	echo

	cd ${ctldir}
#	for PROG in `seq -s " " -f "%03g" ${HSTART} 1 ${HSTOP}`;do

	for arqctl in `echo ${arqctls}`; do
	        cat ${arqctl}.raw | sed -e 's|HH|'${HH}'|g' > raw
		cat raw | sed -e 's|DATAGRADS|'${datagrads}'|g' > raw2
	       	mv raw2 ${ctldir}/ctl${HH}/${arqctl}
	        /usr/local/bin/gribmap -i ${ctldir}/ctl${HH}/${arqctl}
	done


	echo =========================================================================
	echo Criando as figuras a partir da lista de GSs.............
	echo ==========================================================================


	cd /home/operador/grads/icon_13km/gs

        for arq in `cat /home/operador/grads/icon_13km/invariantes/lista`;do
                        rm -f raw.gs
                        echo "'reinit'" > raw.gs
                        cat $arq | sed -e 's|HH|'$HH'|g' > raw1
                        cat raw1 >> raw.gs
                        cat titulo >> raw.gs
                        cat raw.gs | sed -e 's|mres|brmap_hires.dat|g' > raw1
                        mv raw1 raw.gs
                        /opt/opengrads/Contents/grads -bpc raw.gs
                        /usr/local/bin/grads -bpc raw.gs
        done


	echo
	echo FIM ICON ATLANTICO ${HH}Z
	date
	echo
	echo =======================================================================
	# FIM
