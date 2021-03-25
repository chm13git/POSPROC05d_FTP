#!/bin/bash
#
######################################################
#                                                    #
# Script para gerar tabela para comparação com boias #
# Ex: boias_ww3_hycom.sh ww3                         #
#                                                    #
# Ultima modificação: 1T(T) Liana 12FEV2021          #
######################################################

HOME=/home/operador
DIR_SCRIPT=${HOME}/grads/ww3_418/scripts

#DISPLAY=:0
#export DISPLAY


if [ $# -ne 1 ]
then
   echo
   echo "Entre com o modelo (ww3, hycom)"
   echo
   exit
fi


mod=$1

### WW3 ###
if [[ $mod == 'ww3' ]] ; then
    
    # Boia da Antartica
    for model in gfs icon; do
        flag=1
        ni=0
        while [ $flag -eq 1 ]; do
            if [[ -f "/mnt/nfs/dpns32/data2/operador/mod_ondas/ww3_418/output/ww3${model}/wave.`date +%Y%m%d`/WW3MET_00_SAFO" ]]; then

                # Boia da Antartica
                echo 
                echo "Rodando: Boia da Antartica"
                flag=0
                ${DIR_SCRIPT}/boia_ant_ww3.py ${model}
            else
                k=`expr $ni + 1`
                ni=$k
                echo "Aguardando o fim da rodada do ww3${model} das 00Z"
                sleep 60
            fi

            if [ $ni -ge 240 ] ; then
                echo "Apos 4 horas a rodada foi abortada!"
                exit 12
            fi
        done
    done

    # Boia de Santos
    for model in gfs icon cosmo; do
        flag=1
        ni=0
        while [ $flag -eq 1 ]; do
            if [[ -f "/mnt/nfs/dpns32/data2/operador/mod_ondas/ww3_418/output/ww3${model}/wave.`date +%Y%m%d`/WW3MET_00_SAFO" ]]; then
                echo
                echo "Rodando: Boia de Santos"
                flag=0
                ${DIR_SCRIPT}/boia_santos_ww3.py ${model} met
            else
                k=`expr $ni + 1`
                ni=$k
                echo "Aguardando o fim da rodada do ww3${model} das 00Z"
                sleep 60
            fi

            if [ $ni -ge 240 ] ; then
                echo "Apos 4 horas a rodada foi abortada!"
                exit 12
            fi
        done
    done
fi


### HYCOM ###
# BOIA DE SANTOS
if [[ $mod == 'hycom' ]] ; then
    ni=0
    flag=1
    while [ $flag -eq 1 ]; do
        if [[ -f "/mnt/nfs/dpns32/data1/operador/previsao/hycom_2_2/output/Previsao_1_24_nova/Ncdf/`date +%Y%m%d`/hycom124_3zu_`date +%Y%m%d`.md5" ]]; then
            echo
            echo 'Rodando: Boia de Santos'
            flag=0
            ${DIR_SCRIPT}/boia_santos_hycom.py met
        else
            k=`expr $ni + 1`
            ni=$k
            echo "Aguardando o fim da rodada do ${mod} das 00Z"
            sleep 60
        fi

        if [ $ni -ge 240 ] ; then
            echo "Apos 4 horas a rodada foi abortada!"
            exit 12
        fi
    done
fi
