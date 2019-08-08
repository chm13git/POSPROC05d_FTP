set -x
#!/bin/bash

HH=$2
AREA=$1
HSTOP=$3

# ---------------------
# Definindo os caminhos 

GIFDIR="/home/operador/grads/gif/ww3_418/ww3testes"
WORKDIR="/home/operador/grads/ww3_418/ww3testes" # da dpns5a


if [ $# -ne 3 ]
then
echo " Voce deve entrar com a area, o horario de referencia HH  e o tempo final"
exit 12
fi

fim=$(($HSTOP))

if [ $HSTOP -ge 100 ] ;then
  DIG='0'
else
  DIG=''
fi

#if [ $AREA == "iap" ]
#then
#   INI=0
#   DEL=3
#else
#   INI=0
#   DEL=3
#fi

INI=0
DEL=3


   for HREF in `seq $INI $DEL $HSTOP`; do

      if [ $HREF -lt 10 ];then
         HORA=0$DIG$HREF
      elif [ $HREF -lt 100 ];then
         HORA=$DIG$HREF
      else
         HORA=$HREF
      fi

   str="${str} ${HORA}"

done

cd $WORKDIR/ww3${AREA}/work

for arq in `cat $WORKDIR/ww3${AREA}/invariantes/lista`


do
rm -f raw.gs
echo "'reinit'" > raw.gs
echo str=\"$str\" >> raw.gs

cat $arq | sed -e 's|HH|'$HH'|g' > raw1
cat raw1 | sed -e 's|AREA|'$AREA'|g' > raw2
cat raw2 | sed -e 's|WORKDIR|'$WORKDIR'|g' > raw3
cat raw3 | sed -e 's|GIFDIR|'$GIFDIR'|g' > raw4
cat raw4 >> raw.gs
cat titulo >> raw.gs


if [ -e $WORKDIR/ww3${AREA}/invariantes/grad${AREA} ]
then
cat $WORKDIR/ww3${AREA}/invariantes/grad${AREA} >>  raw.gs
fi
echo $arq
if [ $AREA == "car" ] || [ $AREA == "ant" ]
then
/usr/local/bin/grads -blc raw.gs
else
/usr/local/bin/grads -bpc raw.gs
fi
done




