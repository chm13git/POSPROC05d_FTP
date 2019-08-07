#!/bin/bash
set -x
echo
echo " Aqui comeca o /home/operador/grads/ww3_418/scripts/inc_ondogramas.sh"
AREA=$1
HH=$2
dataanalise=$3
#dataanalise="00Z10FEV2014(Seg)"
gsdir="/home/operador/grads/ww3_418/ww3gfs/ww3${AREA}/gs"
DIRARQUIVOGIF="/home/operador/grads/gif/ww3_418/ww3gfs/ww3${Area}${HH}"

case $AREA in
met)

   AREA3="METAREA_V"
   ;;
sse)
   AREA3="SSE"
;;
esac

arq="/home/operador/grads/ww3_418/ww3gfs/ww3${AREA}/invariantes/listaondo"

tr -d '\r' < $arq > raw.txt

mv raw.txt $arq 

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
latnom=`echo $info | awk '{ print $6 }'`
lonnom=`echo $info | awk '{ print $7 }'`
if [ $AREA == "sse" ] || [ $AREA == "sse_10km" ]
then
meteom=`echo $meteo`
fi

#lat1=`echo "scale=5; (sqrt($lat*$lat)+$mlat/60)*(sqrt($lat*$lat)/$lat)" | bc`
lat1=`awk 'BEGIN { printf("%.4f\n", (sqrt('$lat'*'$lat')+'$mlat'/60)*(sqrt('$lat'*'$lat')/'$lat'))}'`
lon1=`awk 'BEGIN { printf("%.4f\n", (sqrt('$lon'*'$lon')+'$mlon'/60)*(sqrt('$lon'*'$lon')/'$lon'))}'`

#sinal=`echo $lat1 | cut -c1-2`
#ponto=`echo $lat1 | cut -c1`
#decimo=`echo $lat1 | cut -d"." -f2`

#        if [ $sinal == "-." ]
#        then

#        lat1="-0."$decimo

#        fi

#        if [ $ponto == "." ]
#        then

#        lat1="0."$decimo

#        fi

#lon1=`echo "scale=5; (sqrt($lon*$lon)+$mlon/60)*(sqrt($lon*$lon)/$lon)" | bc`

          cd $gsdir


          cat meteograma.gs | sed -e 's|HH|'$HH'|g' > rraw1.gs

          cat rraw1.gs | sed -e 's|lat1|'$lat1'|g' > rraw2.gs

          cat rraw2.gs | sed -e 's|lon1|'$lon1'|g' > rraw1.gs

          cat rraw1.gs | sed -e 's|meteo1|'$meteom'|g' > rraw2.gs

          cat rraw2.gs | sed -e 's|DIRARQUIVOGIF|'$DIRARQUIVOGIF'|g' > rraw1.gs 

          cat rraw1.gs | sed -e 's|DATAANALISE|'$dataanalise'|g' > rraw2.gs

	  cat rraw2.gs | sed -e 's|AREA|'$AREA'|g' > rraw1.gs

	  cat rraw1.gs | sed -e 's|METEO1|'$meteo'|g' > rraw2.gs

	  cat rraw2.gs | sed -e 's|MODELO|'$AREA3'|g' > rraw1.gs

          cat rraw1.gs | sed -e 's|LATNOM|'$latnom'|g' > rraw2.gs

          cat rraw2.gs | sed -e 's|LONNOM|'$lonnom'|g' > rraw1.gs

          /opt/opengrads/opengrads -bpc 'run rraw1.gs'

#          rm rraw*


done
