#!/bin/bash -x

#######################################################
# Script para geracao dos produtos do ICON            #
# Elaborado pela CT(T) Alana e Ten Fabíola em OUT2019 #
# O Modelo ICON está com 13km de resolução global     #
#######################################################

HH=$1
HSTART=0
HSTOP=1
moddir="/home/operador/grads/icon_13km"
arqctls="icon13km.ctl"
areas="atl met ant"

if [ $# -ne 1 ];then

	echo " Voce deve entrar com o horario de referencia 00 ou 12"
	exit 12

fi

echo ============================
echo
echo Inicio do ICON ATLANTICO HHZ
date
echo
echo

datacorrente=`cat /home/operador/datas/datacorrente${HH}`
datagrads=`cat /home/operador/datas/datacorrente_grads${HH}| tr '[:upper:]' '[:lower:]'`
dadosdir="/home/operador/grads/icon_13km/dados/dados${HH}"
ctldir="/home/operador/grads/icon_13km/ctl"
scriptdir="/home/operador/grads/icon_13km/scripts"

ni=0
flag=1

echo
echo criando o ctl
echo

	cd ${ctldir}
	for PROG in `seq -s " " -f "%03g" ${HSTART} 1 ${HSTOP}`;do
	echo "${PROG}"
		ICONFILE=icon13km_${HH}.grib2
	
		for arqctl in `echo $arqctls`;do
		        cat ${arqctl}.raw | sed -e 's|HH|'$HH'|g' > raw
			cat raw | sed -e 's|ICONFILE|'${ICONFILE}'|g' > raw2
			cat raw2 | sed -e 's|DATAGRADS|'$datagrads'|g' > raw
			cat raw | sed -e 's|DATACORRENTE|'$datacorrente'|g' > raw2
		       	mv raw2 ${ctldir}/ctl${HH}/${arqctl}
		        rm raw*
		        /usr/local/bin/gribmap -i ${ctldir}/ctl${HH}/${arqctl}
		        chmod a+w *
			${scriptdir}/roda.sh ${HH}
		done
done


#	chmod -R a+w /home/operador/grads/iconatl/*
#	/home/operador/ftp_comissoes/ftp_comissoes.sh ${HH} iconatl
	#/home/operador/ftp_comissoes/ftp_comissoes.sh ${HH} gmemet
	#/home/operador/ftp_comissoes/ftp_comissoes.sh ${HH} gmeant

	echo
	echo FIM ICON ATLANTICO ${HH}Z
	date
	echo
	echo =======================================================================
	# FIM
