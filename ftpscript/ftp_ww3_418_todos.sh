#!/bin/bash
#
#
# Script para rodar o pos-processamento de todas das areas do WW3
# Ultima modificação: 1T(T) Liana 25JAN2021. Argumento para usar 01 ou 31

if [ $# -lt 2 ]

 then
 echo " ----------------------------------------------------------------------------------- "
 echo " Entrar com o modelo (gfs, icon ou cosmo) e o horario da rodada (00 ou 12) "
 echo " Ex1: ./ftp_ww3_todos.sh gfs 00                                                      "
 echo "                                                                                     "
 echo " Opcional: máquina a ser utilizada (31 ou 01)                                        "
 echo " Ex2: ./ftp_ww3_todos.sh gfs 00 31                                                   " 
 echo " ----------------------------------------------------------------------------------- "
 echo
 exit 

fi

mod=$1
cyc=$2
flag=1
ni=0


# Nao usa o argumento da maquina
if [ "$#" -eq 2 ]; then

    while [ $flag -eq 1 ]; 
    do
    
        if [[ -f "/mnt/nfs/dpns32/data2/operador/mod_ondas/ww3_418/output/ww3${mod}/wave.`date +%Y%m%d`/WW3MET_${cyc}_SAFO" ]] || [[ -f "/mnt/nfs/dpns33/data1/ww3desenv/mod_ondas/ww3_418/output/ww3${mod}/wave.`date +%Y%m%d`/WW3MET_${cyc}_SAFO" ]]
            then
                flag=0
                if [[ -f "/mnt/nfs/dpns32/data2/operador/mod_ondas/ww3_418/output/ww3${mod}/wave.`date +%Y%m%d`/WW3MET_${cyc}_SAFO" ]]; then 
                   cam=31
                   echo "O modelo rodou na DPNS31"
                else
                   cam=01
                   echo "O modelo nao rodou na DPNS31, e rodou na DPNS01"
                fi
        else
            k=`expr $ni + 1`
            ni=$k
            echo "O modelo não rodou em nenhuma máquina"
            echo "Aguardando o fim da rodada do ww3${mod} das ${cyc}Z"
            sleep 60

            if [ $ni -ge 480 ] ; then
                echo "Apos 8 horas abortei a rodada !!!!"
                exit 12
            fi
        fi
    done
fi


# Usa o argumento da maquina
if [ "$#" -eq 3 ]; then
    cam=$3
fi

echo "O dado utilizado será o da DPNS${cam}"

cd /home/operador/ftpscript

if [[ $mod == 'gfs' ]] ; then

   /home/operador/ftpscript/ftp_ww3_418.sh $mod $cyc iap $cam
   /home/operador/ftpscript/ftp_ww3_418.sh $mod $cyc ant $cam
   /home/operador/ftpscript/ftp_ww3_418.sh $mod $cyc met $cam
   /home/operador/ftpscript/ftp_ww3_418.sh $mod $cyc sse $cam 
   /home/operador/ftpscript/ftp_ww3_418.sh $mod $cyc  ne $cam 
   /home/operador/ftpscript/ftp_ww3_418.sh $mod $cyc lib $cam
  #Adicionado em 05OUT:
   /home/operador/ftpscript/ftp_ww3_418.sh $mod $cyc car $cam 


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
