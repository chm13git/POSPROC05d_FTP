#!/bin/bash
################################################
# Script que extrai as informações dos modelos #
# HYCOM, WW3 e COSMO para subsidiar operações  #
# de SAR                                       #
#                                              #
# SET2019                                      #  
# Autoras: 1T(RM2-T) Andressa D'Agostini       #
#          1T(RM2-T) Fabíola Souza             #     
################################################

if [ $# -lt 1 ]
   then
   echo "+------------------Utilização----------------+"
   echo "    Script para gerar os dados do .bin para   "
   echo "               eventos SAR                    "
   echo "                                              "
   echo "       Entre com o horário e a data           "
   echo "                                              "
   echo "     ex: ./geradados_sar.sh 00 20190904       "
   echo "+--------------------------------------------+"
   exit
fi

HH=$1

#  Definindo informação de datas
if [ $# -eq 1 ]; then
   AMD=`cat ~/datas/datacorrente${HH}`
elif [ $# -eq 2 ]; then
   AMD=$2
fi

p_grads="/opt/opengrads/Contents/grads"
dir="/home/operador/grads/sar/scripts"
workdir="/home/operador/grads/sar/work"
outdir="/home/operador/grads/sar/bin"

for arq in $workdir/*; do
  rm $arq
done


Atmos=cosmo
Ondas=ww3icon
Oceano=hycom

Atmos_ctl="/home/operador/grads/cosmo/cosmomet/ctl/ctl${HH}/cosmo_met5_${HH}_M.ctl"
Atmos_idx="/home/operador/grads/cosmo/cosmomet/ctl/ctl${HH}/cosmo_met_M.idx" 
Ondas_ctl="/mnt/nfs/dpns32/data2/operador/mod_ondas/ww3_418/output/${Ondas}/wave.${AMD}/met.t${HH}z.ctl"
Ondas_grds="/mnt/nfs/dpns32/data2/operador/mod_ondas/ww3_418/output/${Ondas}/wave.${AMD}/met.t${HH}z.grads"
Oceano_dado="/mnt/nfs/dpns32/data1/operador/previsao/hycom_2_2/output/Previsao_1_12/Ncdf/${AMD}/HYCOM_MV_${AMD}.nc"

MODELs=(${Atmos} ${Ondas} ${Oceano})

# Flags de tempo para o while
Abort=480  # minutos - 8 horas de limite na tentativa de rodada do script
Tspended=0

dataprog=`caldate $AMD$HH + 96h yyyymmddhh`
dataprog_hyc=`caldate $AMD$HH + 90h yyyymmddhh`

cd ${workdir}

while [ ${Abort} -gt ${Tspended} ]; do

  for MODEL in "${MODELs[@]}"; do

    if [ ${MODEL} = ${Atmos} ] && [ -e ${Atmos_ctl} ] && [ ! -e ${workdir}/${MODEL}_SAFO ]; then

      echo ' '
      echo ' Preparando .bin do '${MODEL}' da data/hora: '${AMD}${HH}
      echo ' '      
      ln -sf ${Atmos_ctl} cosmo.ctl; ln -sf ${Atmos_idx} cosmo.idx
      var1="u_10m"; var2="v_10m"; var3="t2m";
      nvar=3; tf=33; tint=2
      cp /home/operador/grads/sar/scripts/gerabin_cosmo.gs tmp1
      if [ ${HH} = 00 ]; then
        tz=1; 
        cat tmp1 | sed -e 's|TZ|'$tz'|g' > tmp2
      else
        tz=5; 
        cat tmp1 | sed -e 's|TZ|'$tz'|g' > tmp2
      fi      
      cat tmp2 | sed -e 's|TF|'$tf'|g' > tmp1
      cat tmp1 | sed -e 's|MODEL|'$MODEL'|g' > tmp2
      cat tmp2 | sed -e 's|HH|'$HH'|g' > tmp1
      cat tmp1 | sed -e 's|AMD|'$AMD'|g' > tmp2
      cat tmp2 | sed -e 's|VAR1|'$var1'|g' > tmp1
      cat tmp1 | sed -e 's|VAR2|'$var2'|g' > tmp2
      cat tmp2 | sed -e 's|VAR3|'$var3'|g' > tmp1
      cat tmp1 | sed -e 's|TINT|'$tint'|g' > tmp2
      mv tmp2 raw.gs
      ${p_grads} -bpc "run raw.gs"
      mv $workdir/cosmo*bin $outdir/ 

      if [ -e ${outdir}/${MODEL}_met_$dataprog.bin ]; then
        touch ${workdir}/${MODEL}_SAFO
      fi
    elif [ ${MODEL} = ${Ondas} ] && [ -e ${Ondas_ctl} ] && [ ! -e ${workdir}/${MODEL}_SAFO ]; then

      echo ' '
      echo ' Preparando .bin do '${MODEL}' da data/hora: '${AMD}${HH}
      echo ' '      
      ln -sf ${Ondas_ctl} ww3icon.ctl; ln -sf ${Ondas_grds} ww3.grads
      cp /home/operador/grads/sar/scripts/gerabin_ww3.gs tmp1
      var1="hs"; var2="dp";
      nvar=2; tf=33; tint=2
      if [ ${HH} = 00 ]; then
        tz=1; 
        cat tmp1 | sed -e 's|TZ|'$tz'|g' > tmp2
      else
        tz=5; 
        cat tmp1 | sed -e 's|TZ|'$tz'|g' > tmp2
      fi      
      cat tmp2 | sed -e 's|TF|'$tf'|g' > tmp1
      cat tmp1 | sed -e 's|MODEL|'$MODEL'|g' > tmp2
      cat tmp2 | sed -e 's|HH|'$HH'|g' > tmp1
      cat tmp1 | sed -e 's|AMD|'$AMD'|g' > tmp2
      cat tmp2 | sed -e 's|VAR1|'$var1'|g' > tmp1
      cat tmp1 | sed -e 's|VAR2|'$var2'|g' > tmp2
      cat tmp2 | sed -e 's|VAR3|'$var3'|g' > tmp1
      cat tmp1 | sed -e 's|TINT|'$tint'|g' > tmp2
      mv tmp2 raw.gs
      ${p_grads} -bpc "run raw.gs"
      mv $workdir/ww3*bin $outdir/

      if [ -e ${outdir}/${MODEL}_met_$dataprog.bin ]; then
        touch ${workdir}/${MODEL}_SAFO
      fi
    elif [ ${MODEL} = ${Oceano} ] && [ ${HH} = 00 ] && [ -e ${Oceano_dado} ] && [ ! -e ${workdir}/${MODEL}_SAFO ]; then

      echo ' '
      echo ' Preparando .bin do '${MODEL}' da data/hora: '${AMD}${HH}
      echo ' '      
      ln -sf ${Oceano_dado} hycom.nc
      cp /home/operador/grads/sar/scripts/gerabin_hycom.gs tmp1
      var1="U"; var2="V"; var3="TEMPERATURE";
      nvar=3; tf=16; tint=1
      cat tmp1 | sed -e 's|MODEL|'$MODEL'|g' > tmp2
      cat tmp2 | sed -e 's|HH|'$HH'|g' > tmp1
      cat tmp1 | sed -e 's|AMD|'$AMD'|g' > tmp2
      cat tmp2 | sed -e 's|VAR1|'$var1'|g' > tmp1
      cat tmp1 | sed -e 's|VAR2|'$var2'|g' > tmp2
      cat tmp2 | sed -e 's|VAR3|'$var3'|g' > tmp1
      cat tmp1 | sed -e 's|TF|'$tf'|g' > tmp2
      cat tmp2 | sed -e 's|TINT|'$tint'|g' > tmp1
      mv tmp1 raw.gs
      ${p_grads} -bpc "run raw.gs"
      mv $workdir/hycom*bin $outdir/
      if [ -e ${outdir}/${MODEL}_met_$dataprog_hyc.bin ]; then
        touch ${workdir}/${MODEL}_SAFO
      fi
    elif [ ${HH} = 00 ] && [ -e ${workdir}/${Atmos}_SAFO ] && [ -e ${workdir}/${Ondas}_SAFO ] && [ -e ${workdir}/${Oceano}_SAFO ]; then
      echo ' '
      echo ' Foram atualizados e gerados os .bin dos modelos: '${Atmos}' ' ${Ondas}' '${Oceano}' '$AMD' '$HH
      echo ' Limpando workdir e saindo...'
      echo ' '
      for arq in $workdir/*; do
        rm $arq
      done
      exit 1
    elif [ ${HH} = 12 ] && [ -e ${workdir}/${Atmos}_SAFO ] && [ -e ${workdir}/${Ondas}_SAFO ]; then
      echo ' '
      echo ' Foram atualizados e gerados os .bin dos modelos: '${Atmos}' ' ${Ondas}' '$AMD' '$HH
      echo ' Limpando workdir e saindo...'
      echo ' '
      for arq in $workdir/*; do
        rm $arq
      done
      exit 1
    else
      echo ' '
      echo ' Aguardando modelos terminarem de rodar... sleep: '${Tspended}
      echo ' '      
      sleep 60
      Aux=`expr ${Tspended} + 1`
      Tspended=${Aux}
    fi
  done
done
