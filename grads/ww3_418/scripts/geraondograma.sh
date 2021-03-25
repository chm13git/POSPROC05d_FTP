#!/bin/bash -x

HH=$1
FORC=$2
AREA=$3

# ---------------------
# Definindo os caminhos 

WORKDIR="/home/operador/grads/ww3_418/ww3${FORC}/ww3${AREA}" # da dpns5a
ONDOGDIR="/home/operador/ondogramas/ww3_418/ww3${FORC}" # da dpns5a


if [ $# -ne 3 ]
then
echo " Voce deve entrar com  o horario de referencia HH, forçante (gfs, cosmo ou icon) e area (met, sse, ne, iap ou car)"
exit 12
fi


ln -sf $WORKDIR/work/ww3.ctl .
ln -sf $WORKDIR/work/ww3.grads .

rm -f raw.gs
echo "'reinit'" > raw.gs

#cat ondogramas.gs | sed -e 's|WORKDIR|'$WORKDIR'|g' > raw1

cat ondogramas.gs | sed -e 's|ONDOGDIR|'$ONDOGDIR'|g' > raw2
cat raw2 | sed -e 's|HH|'$HH'|g' > raw3
cat raw3 >> raw.gs


/opt/opengrads/Contents/grads -bpc "run raw.gs"



exit
