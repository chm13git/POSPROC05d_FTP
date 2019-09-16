#!/bin/bash
#
#
# Script para rodar o pos-processamento de 
# todas das areas do WW3

if [ $# -ne 3 ]

 then
 echo " ---------------------------------------- "
 echo " Voce deve entrar com o modelo(gfs, icon  "
 echo " ou cosmo), o horario da rodada(00 ou 12) "
 echo " e o caminho do output (01 e 07 ou 31)    "
 echo "                                          "
 echo " ex:./ftp_ww3_todos.sh gfs 00 31          "
 echo " ---------------------------------------- "
 echo
 exit 

fi

mod=$1
cyc=$2
cam=$3

cd /home/operador/ftpscript


if [[ $mod == 'gfs' ]] ; then

   /home/operador/ftpscript/ftp_ww3_418.sh $mod $cyc iap $cam
   /home/operador/ftpscript/ftp_ww3_418.sh $mod $cyc ant $cam
   /home/operador/ftpscript/ftp_ww3_418.sh $mod $cyc met $cam
   /home/operador/ftpscript/ftp_ww3_418.sh $mod $cyc sse $cam 
   /home/operador/ftpscript/ftp_ww3_418.sh $mod $cyc ne $cam 
   /home/operador/ftpscript/ftp_ww3_418.sh $mod $cyc lib $cam 


fi

if [[ $mod == 'icon' ]] ; then

   /home/operador/ftpscript/ftp_ww3_418.sh $mod $cyc iap $cam 
   /home/operador/ftpscript/ftp_ww3_418.sh $mod $cyc ant $cam 
   /home/operador/ftpscript/ftp_ww3_418.sh $mod $cyc met $cam 
   /home/operador/ftpscript/ftp_ww3_418.sh $mod $cyc sse $cam 
   /home/operador/ftpscript/ftp_ww3_418.sh $mod $cyc ne $cam 
   /home/operador/ftpscript/ftp_ww3_418.sh $mod $cyc lib $cam 


fi


if [[ $mod == 'cosmo' ]] ; then

   /home/operador/ftpscript/ftp_ww3_418.sh $mod $cyc met $cam 
   /home/operador/ftpscript/ftp_ww3_418.sh $mod $cyc sse $cam 
   /home/operador/ftpscript/ftp_ww3_418.sh $mod $cyc ne $cam 

fi


if [[ $cyc == '00' ]] && [[ $mod != 'cosmo' ]] ; then

   /home/operador/ftpscript/ftp_ww3_418.sh gfs  $cyc car $cam
   /home/operador/ftpscript/ftp_ww3_418.sh icon $cyc car $cam 

else
   exit
fi



