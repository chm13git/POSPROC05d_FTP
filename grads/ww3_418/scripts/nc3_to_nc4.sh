#!/bin/bash -x

FORC=$1
HH=$2
AREA=$3

WND=$FORC

source /home/operador/.bashrc

RAIZ="/home/operador/grads/ww3_418"
case $FORC in
gfs) 
     AREAS="iap ant met"
;;
icon)
     AREAS="iap ant met"
;;
cosmo)
     AREAS="met"
;;
*)
     echo "Forcante nao existente"
     exit 12
;;
esac

# VERIFICANDO SE A AREA SOLICITADA EXISTE PARA FORCANTE DEFINIDA

echo $AREAS | grep $AREA > /dev/null
erro=$?

if [ $erro -ne 0 ]
then
echo "PARA FORCANTE $FORC as seguintes AREAS ESTAO DISPONIVEIS: $AREAS"
exit 12
fi

WORKDIR=$RAIZ/ww3${FORC}/ww3${AREA}/work
cd $WORKDIR

rm ww3.nc
rm raw.gs

cat >> raw.gs <<eof
'open ww3.ctl'
dados=result
linha6=sublin(dados,6)
tempo=subwrd(linha6,4)
'! echo 'tempo' > tempo.txt'
'quit'
eof


/usr/local/bin/grads -bpc raw.gs
rm raw.gs
tempo=`cat tempo.txt`
rm tempo.txt

A=`echo $tempo | cut -f1 -d:`
M=`echo $tempo | cut -f2 -d:`
if [ $M -le 9 ]
then
M="0${M}"
fi
D=`echo $tempo | cut -f3 -d:`
if [ $D -le 9 ]
then
D="0${D}"
fi
AMD=${A}${M}${D}
HH=`echo $tempo | cut -f4 -d:`


cdo -f nc import_binary ww3.ctl ww3.nc


if [ ${WND} == 'gfs' ]; then

if [ $AREA == 'met' ]; then
 echo 'set mem/size=1500' > temp_nc.jnl
 echo 'use ww3.nc' >> temp_nc.jnl
 echo 'save/clobber/ncformat=4/deflate=1/shuffle=1/file="ww3'$WND'_'$AREA'_'$AMD$HH'.nc" uwnd, vwnd, hs, t02, t01, t0m1, fp, dir, spr, dp' >> temp_nc.jnl
 /home/operador/local/bin/ferret/bin/ferret -gif -nojnl << eof
go temp_nc.jnl
exit
eof
fi

#if [ $AREA == 'ant' ]; then
 #echo 'set mem/size=1500' > temp_nc.jnl
# echo 'use ww3.nc' >> temp_nc.jnl
# echo 'save/clobber/ncformat=4/deflate=1/shuffle=1/file="ww3'$WND'_'$AREA'_'$AMD$HH'.nc" UWND, VWND, HS, T02, T0M1, T01, FP, DIR, SPR, DP' >> temp_nc.jnl
# /home/operador/local/bin/ferret/bin/ferret -gif -nojnl << eof
#go temp_nc.jnl
#exit
#eof
#fi


fi

if [ ${WND} == 'icon' ]; then

if [ $AREA == 'met' ]
then
 echo 'set mem/size=1500' > temp_nc.jnl
 echo 'use ww3.nc' >> temp_nc.jnl
 echo 'save/clobber/ncformat=4/deflate=1/shuffle=1/file="ww3'$WND'_'$AREA'_'$AMD$HH'.nc" UWND, VWND, HS, T02, T0M1, T01, FP, DIR, SPR, DP' >> temp_nc.jnl
 /home/operador/local/bin/ferret/bin/ferret -gif -nojnl << eof
go temp_nc.jnl
exit
eof
fi

#if [ $AREA == 'ant' ]
#then
# echo 'set mem/size=1500' > temp_nc.jnl
# echo 'use ww3.nc' >> temp_nc.jnl
# echo 'save/clobber/ncformat=4/deflate=1/shuffle=1/file="ww3'$WND'_'$AREA'_'$AMD$HH'.nc" UWND, VWND, HS, T02, T0M1, T01, FP, DIR, SPR, DP' >> temp_nc.jnl
# /home/operador/local/bin/ferret/bin/ferret -gif -nojnl << eof
#go temp_nc.jnl
#exit
#eof
#fi

fi

if [ ${WND} == 'cosmo' ]; then

if [  $AREA == 'met' ]
then
 echo 'set mem/size=1500' > temp_nc.jnl
 echo 'use ww3.nc' >> temp_nc.jnl
 echo 'save/clobber/ncformat=4/deflate=1/shuffle=1/file="ww3'$WND'_'$AREA'_'$AMD$HH'.nc" UWND, VWND, HS, T02, T0M1, T01, FP, DIR, SPR, DP' >> temp_nc.jnl
 /home/operador/local/bin/ferret/bin/ferret -gif -nojnl << eof
go temp_nc.jnl
exit
eof
fi

fi

rm ww3.nc
rm temp_nc.jnl

mv ww3${WND}_${AREA}_${AMD}${HH}.nc /home/operador/grads/ww3_418/nc4

/usr/bin/ftp -i -n dpas06 << endftp1
user petrobras p&tr0br@s
binary
cd WW3 

lcd /home/operador/grads/ww3_418/nc4 
mput ww3${WND}_${AREA}_${AMD}${HH}.nc 
bye
endftp1


find /home/operador/grads/ww3_418/nc4 -mtime +7 -exec rm {} \; 

exit
