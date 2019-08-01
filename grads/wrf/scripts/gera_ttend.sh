#!/bin/bash -x

AREA=metarea5
HH=00
HSTART=00
HSTOP=120

# Script para gerar os campos de tendencia de T, que precisam do ctl completo.
echo =======================================================================
echo "Script para gerar os campos de tendencia de T, que precisam do ctl completo."
echo

if [ $AREA == "metarea5" ] ;then
        for areas in metarea5 sse nne;do
                /home/operador/grads/wrf/scripts/roda_final.sh ${areas} ${HH} ${HSTART} ${HSTOP}
        done
fi

