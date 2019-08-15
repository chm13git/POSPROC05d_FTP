#!/bin/bash -x

AREA=met
HH=00
HSTART=00
HSTOP=120

if [ $AREA == "met" ] ;then
	for areas in met sse nne;do
		/home/operador/grads/cosmo/scripts/roda_final.sh ${areas} ${HH} ${HSTART} ${HSTOP}
	done
fi

