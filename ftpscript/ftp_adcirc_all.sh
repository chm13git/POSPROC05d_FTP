#!/bin/bash -x
#
###################################################
#						  #
# Script para rodar o pos-processamento do ADCIRC #
#						  #
###################################################

HOME=/home/operador
DIR_SCRIPT=${HOME}/ftpscript
DIR_GIF=${HOME}/grads/gif/adcirc
#~ DIR_INTERNET=${HOME}/grads/gif/adcirc/internet

DISPLAY=:0
export DISPLAY

if [ $# -eq 6 ]; then
	VAR=$1
	PROG=$2
	AREA=$3
	ANO=$4
	MES=$5
	DIA=$6
	${DIR_SCRIPT}/ftp_adcirc.py ${VAR} ${PROG} ${AREA} ${ANO} ${MES} ${DIA}

elif [ $# -eq 1 ]; then
        AREA=$1
        ${DIR_SCRIPT}/ftp_adcirc.py hs 69 ${AREA}
        ${DIR_SCRIPT}/ftp_adcirc.py tps 69 ${AREA}

else
	for AREA in bg sig ssib
	do
		rm ${DIR_GIF}/${AREA}/*.gif
		rm ${DIR_GIF}/${AREA}/*.png
	
		cd ${DIR_SCRIPT}

		${DIR_SCRIPT}/ftp_adcirc.py hs 69 ${AREA}
		${DIR_SCRIPT}/ftp_adcirc.py tp 69 ${AREA}
		#${DIR_SCRIPT}/ftp_adcirc.py tmm 69 ${AREA}
		#${DIR_SCRIPT}/ftp_adcirc.py zeta 69 ${AREA}
		#${DIR_SCRIPT}/ftp_adcirc.py curr 69 ${AREA}
	done

fi

