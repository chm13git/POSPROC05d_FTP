#!/bin/bash
###################################################
# Script que realiza a geração de produtos do WW3 #
# NOV2019                                         #  
# Autora: 1T(RM2-T) Andressa D'Agostini           #
###################################################

# -----------------------------------------
# Definição diretórios raiz e do wavewatch
source ~/grads/ww3/fixos/inicializacao.sh

if [ $# -lt 3 ]

 then
 echo " ---------------------------------------- "
 echo "                                          "
 echo "  Script para execução da rodada do WW3   "
 echo "     wind= gfs, icon ou cosmo             "
 echo "   area= met,sse,ne,ant,iap,lib,car       "
 echo "                                          "
 echo "       ./ftp_ww3.sh wind hh area yyyymmdd "
 echo "   ex: ./ftp_ww3.sh gfs 00 met 20190716   "
 echo "                                          "
 echo " ---------------------------------------- "
 echo
 exit 

fi

######## ARGUMENTO FORÇANTE DE VENTO ########

FORC=$1
case $FORC in
gfs) MOD=gfs ;;
icon) MOD=icon ;;
cosmo) MOD=cosmo ;;
*) 
echo " "
echo "Modelo nao cadastrado"
echo " "
exit 12
;;
esac

######## ARGUMENTO CICLO RODADA ########

HSIM=$2

######## ARGUMENTO ÁREA E A GRADE DO WW3 A SER UTILIZADA ########

AREA=$3
case $AREA in
met) 
GRD=met
;;
sse)
GRD=met
;;
ne)
GRD=met
;;
ant)
GRD=ant
;;
iap) 
GRD=glo
;;
car)
GRD=glo
;;
lib)
GRD=glo
;;
*)
echo " "
echo "Área não cadastrada"
echo " "
exit 12
;;
esac

######## ARGUMENTO DATA ########

if [ $# -eq 3 ]; then
   AMD=`cat ~/datas/datacorrente${HSIM}`
elif [ $# -eq 4 ]; then
   AMD=$4
fi

echo ' Rodada '${AMD}' '${HSIM}

######## DEFININDO DIRETÓRIOS ########

GIFDIR=${GIFDIR}/ww3${FORC}
GRADSDIR=${GRADSDIR}
ONDOGDIR=${ONDOGDIR}
FLAGDIR=${FLAGDIR}
DADODIR=${DADODIR}
CTLDIR=${GRADSDIR}/ctls_grads

DADO="${DADODIR}/ww3${MOD}/${AMD}"
SAFOFLAG=${FLAGDIR}/WW3${MOD}_${AMD}${HSIM}_SAFO
AMDgrads=`cat ~/datas/datacorrente_grads${HSIM} | tr '[:upper:]' '[:lower:]'`

######## VERIFICANDO RODADA DO WW3 ########
######## ARQUIVO SAFO E DATAS DE CONTROLE ########

flag=1; ni=0
while [ $flag -eq 1 ]; do

 rm ${CTLDIR}/ww3${FORC}_${GRD}_${HSIM}.ctl
 ln -sf ${DADO}/${GRD}.t${HSIM}z.ctl ${CTLDIR}/ww3${FORC}_${GRD}_${HSIM}.ctl
 AMDcontrol=`grep TDEF ${CTLDIR}/ww3${FORC}_${GRD}_${HSIM}.ctl | cut -c33-41 | tr '[:upper:]' '[:lower:]'`

 if [ -e ${SAFOFLAG} ] && [ "${AMDcontrol}"==${AMDgrads} ]; then
  echo ""
  echo " Prontificado o "${SAFOFLAG}
  echo ""
  flag=0
  else
  k=`expr $ni + 1`
  ni=$k
  echo ""
  echo " Aguardando o fim da rodada do WW3${FORC} ${AMD} ${HSIM}Z"
  echo ""
  sleep 60 
 fi   
  
 if [ $ni -ge 480 ] ; then
  echo "Apos 8 horas abortei a rodada !!!!"
  exit 12
 fi

done

######## LINKANDO OS ARQUIVOS CTL E GRADS ########

rm ${CTLDIR}/ww3${FORC}_${GRD}_${HSIM}.ctl
ln -sf $DADO/${GRD}.t${HSIM}z.ctl ${CTLDIR}/ww3${FORC}_${GRD}_${HSIM}.ctl
rm ${CTLDIR}/ww3${FORC}_${GRD}_${HSIM}.grads
ln -sf $DADO/${GRD}.t${HSIM}z.grads ${CTLDIR}/ww3${FORC}_${GRD}_${HSIM}.grads

######## CONFECÇÃO CARTA FAX SIMILE ########

if [[ ${AREA} == "iap" && ${FORC} == "icon" ]] || [[ ${AREA} == "iap" && ${FORC} == "gfs" ]]; then

 echo
 echo 'FAZENDO FAXSIMILE '${FORC}': '${AREA}''
 echo
 /home/operador/grads/faxsimile/scripts/faxsimile_newWW3.sh ww3${FORC} ${HSIM}

fi

######## EXECUTANDO A CONFECÇÃO DAS FIGURAS ########

${GRADSDIR}/scripts/roda_figuras.sh ${FORC} ${HSIM} ${AREA}

######## GERANDO OS ONDOGRAMAS ########

if [ ${AREA} == "met" ] || [ ${AREA} == "iap" ]; then

 echo
 echo 'FAZENDO ONDOGRAMA '${AREA}''
 echo
 ${GRADSDIR}/scripts/geraondograma.sh ${FORC} ${HSIM} ${AREA}

fi

######## GERANDO OS ONDOGRAMAS DE COMISSÕES ########

if [ ${AREA} == "iap" ] || [ ${AREA} == "met" ];then

 echo
 echo 'FAZENDO ONDOGRAMA PARA COMISSÕES '${AREA}''
 echo
 ${GRADSDIR}/scripts/geraondograma_comissao.sh ${FORC} ${HSIM} ${AREA}

fi

######## GERANDO AS TABELAS DE DRAKE ########

if [[ ${FORC} == "gfs" && ${AREA} == "ant" ]] || [[ ${FORC} == "icon" && ${AREA} == "ant" ]]; then

 echo
 echo ' FAZENDO A TABELA DE DRAKE '
 echo
 ${p_python} ${GRADSDIR}/scripts/ww3_tabela_Drake_Nelson.py ${FORC} ${HSIM} ${AMD}
 ${p_python} ${GRADSDIR}/scripts/ww3_tabela_Drake_Simpson.py ${FORC} ${HSIM} ${AMD}

fi

######## PRODUTO CCTOM ########

if [[ ${AREA} == "met" && ${FORC} == "gfs" ]] || [[ ${AREA} == "met" && ${FORC} == "icon" ]]; then

  echo
  echo 'FAZENDO CCTOM '${FORC}': '${AREA}''
  echo

  /home/operador/grads/cctom/scripts/cctom_newWW3.sh ww3${FORC} ${HSIM}

fi

######## GERANDO O AUXILIO ########

#if [ ${AREA} == "met" ] || [ ${AREA} == "ant" ] ; then

#  echo
#  echo 'FAZENDO AUXILIO para area '${AREA}''
#  echo
#  /home/operador/grads/auxilio_decisao/scripts/auxilio_newWW3.sh ${HSIM} ww3${AREA}

#fi

######## AUXILIO 2DN ########

if [ ${AREA} == "met" ] ; then

  echo
  echo 'FAZENDO AUXILIO para o 2o DN'
  echo

  ${p_python} /home/operador/grads/auxilio_decisao/scripts/auxilio131_newWW3.py ${FORC} ${HSIM} ${AMD}

fi
