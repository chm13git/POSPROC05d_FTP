#!/bin/bash -x

HH=$1
if [ $# -ne 1 ];then

	echo " Voce deve entrar com o horario de referencia HH"
	exit 12

fi

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
#			rm raw*.gs
	done
