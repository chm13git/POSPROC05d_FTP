#!/bin/bash

if [ $# -ne 4 ]
then
   echo
   echo "Entre com o forçante (gfs,icon,cosmo), horario referencia (00 ou 12), "
   echo " com a area (met, glo ou ant) e com o caminho da maquina (07 ou 31)   "
   echo
   exit
fi


# Definindo variaveis e areas

FORC=$1
HH=$2
AREA=$3
CAMINHO=$4

# ---------------------
# Definindo os caminhos 

ONDOGDIR="/home/operador/ondogramas"
ONDOGSCR="/home/operador/grads/ww3_418/scripts"

case $FORC in

gfs)

WORKDIR="/home/operador/grads/ww3_418/ww3gfs" 
;;

icon)

WORKDIR="/home/operador/grads/ww3_418/ww3icon" 
;;

cosmo)

WORKDIR="/home/operador/grads/ww3_418/ww3cosmo" 
;;

*)
echo "Modelo nao cadastrado"
exit 12
;;
esac

#if [ $CAMINHO -eq 07 ]
#then
#  caminho07="/mnt/nfs/dpns09/data/operador/mod_ondas/ww3_418/output"
#  CAMINHO=$caminho07
#  echo $caminho07
#fi

if [ $CAMINHO -eq 01 ]
then
  caminho01="/mnt/nfs/dpns33/data1/ww3desenv/mod_ondas/ww3_418/output"
  CAMINHO=$caminho01
  echo $caminho01
fi
if [ $CAMINHO -eq 31 ]
then
#  caminho31=/mnt/nfs/dpns32/data/operador/mod_ondas/ww3_418/output
  caminho31="/mnt/nfs/dpns32/data2/operador/mod_ondas/ww3_418/output"
  CAMINHO=$caminho31
  echo $caminho31
fi

/home/operador/datas/ledata_corr.sh ${HH}

datahoje=`cat ~/datas/datacorrente${HH}`


rm /home/operador/grads/ww3_418/scripts/ww3.ctl
rm /home/operador/grads/ww3_418/scripts/ww3.grad
ln -s $CAMINHO/ww3${FORC}/wave.${datahoje}/${AREA}.t${HH}z.ctl $ONDOGSCR/ww3.ctl
ln -s $CAMINHO/ww3${FORC}/wave.${datahoje}/${AREA}.t${HH}z.grads $ONDOGSCR/ww3.grads

cd $ONDOGSCR

#/usr/local/bin/grads -bpc "run ondogramas_met.gs"
/opt/opengrads/Contents/grads -bpc "run ondogramas_comissao.gs"
#/opt/opengrads/Contents/grads -bpc "run ondogramas_comissaoX.gs"
#/opt/opengrads/Contents/grads -bpc "run ondogramas_comissaoY.gs"

if [ $AREA = glo ]
then
   area=iap
else
   area=$AREA
fi

mv *.gif $ONDOGDIR/ww3_418/ww3$FORC/ww3${area}${HH}
mv *.jpg $ONDOGDIR/ww3_418/ww3$FORC/ww3${area}${HH}

rm /home/operador/grads/ww3_418/scripts/ww3.ctl
rm /home/operador/grads/ww3_418/scripts/ww3.grads

exit
