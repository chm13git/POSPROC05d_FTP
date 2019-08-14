#!/bin/bash
set -x
AREA=$1
HH=$2
dataanalise=$3
gsdir="/home/operador/grads/cosmo/cosmo${AREA}/gs"
DIRARQUIVOGIF="/home/operador/grads/gif/cosmo${AREA}_${HH}"

arq="/home/operador/grads/cosmo/cosmo${AREA}/invariantes/listacvert"

nlinhas=`cat $arq | wc -l`

for i in `seq 1 $nlinhas`
do

info=`cat $arq | head -$i | tail -1`
meteo=`echo $info | awk '{ print $1 }'`
lat=`echo $info | awk '{ print $2 }'`
mlat=`echo $info | awk '{ print $3 }'`
lon=`echo $info | awk '{ print $4 }'`
mlon=`echo $info | awk '{ print $5 }'`
meteom=`echo $meteo | tr '[:upper:]' '[:lower:]'`

lat1=`echo "scale=5; (sqrt($lat*$lat)+$mlat/60)*(sqrt($lat*$lat)/$lat)" | bc`
lon1=`echo "scale=5; (sqrt($lon*$lon)+$mlon/60)*(sqrt($lon*$lon)/$lon)" | bc`
          
          cd $gsdir


          cat cvert+neb.raw.gs | sed -e 's|HH|'$HH'|g' > rraw1.gs

          cat rraw1.gs | sed -e 's|lat1|'$lat1'|g' > rraw2.gs

          cat rraw2.gs | sed -e 's|lon1|'$lon1'|g' > rraw1.gs

          cat rraw1.gs | sed -e 's|meteo1|'$meteom'|g' > rraw2.gs

	  cat rraw2.gs | sed -e 's|DIRARQUIVOGIF|'$DIRARQUIVOGIF'|g' > rraw1.gs 

          cat rraw1.gs | sed -e 's|DATAANALISE|'$dataanalise'|g' > rraw2.gs

	  cat rraw2.gs | sed -e 's|AREA|'$AREA'|g' > rraw1.gs

	  cat rraw1.gs | sed -e 's|METEO1|'$meteo'|g' > rraw2.gs

	  cat /home/operador/grads/cosmo/scripts/label2 >> rraw2.gs

          /usr/local/bin/grads -bpc 'run rraw2.gs'

#          rm rraw*


done
