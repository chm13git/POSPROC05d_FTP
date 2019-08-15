#!/bin/bash -x
# --------------------------------------
#
# Script para realizar pos-processamento
# figuras, e ondogramas do WW3 multi
# para forçantes GFS, COSMO e WRF
# 
# Rotina adaptada da rotina ftp_ww3_418testealana.sh
# GM(RM2-T) Andressa D'Agostini e Valquiria Pacheco
# OUTUBRO 2015
# 
# Modificação no CCTOM/FAXSIMILE - 02dez2015 
# 2T(RM2-T) Andressa D'Agostini
# --------------------------------------

if [ $# -ne 4 ]
then
   echo
   echo "Entre com a forcante (gfs, icon ou cosmo), com o horario de referencia (00 ou 12),"
   echo "com a area (glo, iap, met, sse, ne, ant, car e lib), e com o caminho (07 ou 31)  "
   echo
   exit
fi

# ---------------------------
# Definindo variaveis e areas

FORC=$1
HH=$2
AREA=$3
CAMINHO=$4

RODADA="Operacional"

case $FORC in

gfs)

MOD1='ww3gfs'
HSTOP1=120
AREAtemp=' WW3 Global'
fonte1='glo'
FILE1="WW3GLO_${HH}_SAFO"
;;

icon)

MOD1='ww3icon'
HSTOP1=120
AREAtemp=' WW3 Global'
fonte1='glo'
FILE1="WW3GLO_${HH}_SAFO"
;;

wrf)

MOD1='ww3wrf'
HSTOP1=120
AREAtemp=' WW3 Global'
fonte1='glo'
FILE1="WW3GLO_${HH}_SAFO"
;;

cosmo)

MOD1='ww3cosmo'
HSTOP1=96
AREAtemp=' WW3 Metarea'
fonte1='met'
FILE1="WW3MET_${HH}_SAFO"
;;
*)
echo "Modelo nao cadastrado"
exit 12
;;
esac


# ----------------------------------
# definindo caracteristicas das areas

case $AREA in

iap)
FILE=$FILE1
AREA2=$AREAtemp
MOD=$MOD1
fonte=$fonte1
HSTOP=$HSTOP1
STATUS1=30
;;
met)
FILE="WW3MET_${HH}_SAFO"
AREA2="WW3 METAREA"
MOD=$MOD1
fonte='met'
HSTOP=$HSTOP1
STATUS1=32
;;
sse)
FILE="WW3MET_${HH}_SAFO"
AREA2="WW3 SSE"
MOD=$MOD1
fonte='met'
HSTOP=$HSTOP1
STATUS1=34
;;
car)
FILE=$FILE1
AREA2="WW3 CARIBE"
MOD=$MOD1
fonte=$fonte1
HSTOP=$HSTOP1
STATUS1=38
;;
lib)
FILE=$FILE1
AREA2="WW3 LIB"
MOD=$MOD1
fonte=$fonte1
HSTOP=$HSTOP1
;;
ant)
FILE="WW3ANT_${HH}_SAFO"
AREA2="WW3 ANTARTICA"
MOD=$MOD1
fonte='ant'
HSTOP=$HSTOP1
STATUS1=36
;;
ne)
FILE="WW3MET_${HH}_SAFO"
AREA2="WW3 NE"
MOD=$MOD1
fonte='met'
HSTOP=$HSTOP1
STATUS1=28
;;
*)
echo "Modelo nao cadastrado"
exit 12
;;
esac


if [ $CAMINHO -eq 07 ]
then
  caminho07=/mnt/nfs/dpns09/data/operador/mod_ondas/ww3_418/output
  CAMINHO=$caminho07
  echo $caminho07
fi
if [ $CAMINHO -eq 31 ]
then
#  caminho31=/mnt/nfs/dpns32/data/operador/mod_ondas/ww3_418/output
# CT Leandro 13/11/17 modificado para data2
  caminho31=/mnt/nfs/dpns32/data2/operador/mod_ondas/ww3_418/output
  CAMINHO=$caminho31
  echo $caminho31
fi

# ----------------
# pagina de status

if [ $HH -eq 00 ]
then
  STATUS=$STATUS1
fi
if [ $HH -eq 12 ]
then
  STATUS=`expr $STATUS1 + 1`
fi

# ---------------------
# Definindo os caminhos

export WORKDIR="/home/operador/grads/ww3_418/$MOD" # da dpns5a
export GIFDIR="/home/operador/grads/gif/ww3_418/$MOD" 
export ONDOGDIR="/home/operador/ondogramas/ww3_418/$MOD" 

echo $WORKDIR
echo
echo $GIFDIR
echo
echo $ONDOGDIR

#--------------------------------
# Definindo datas e arquivos SAFO

datahoje=`cat ~/datas/datacorrente${HH}`
datagrads=`cat ~/datas/datacorrente_grads${HH} | tr '[:upper:]' '[:lower:]'`
RFILE="$CAMINHO/$MOD/wave.${datahoje}/${FILE}"

flag=1
ni=0

MSG="POS-PROC DO WW3/${FORC} ${datahoje} ${HH}Z INICIADO"

/usr/bin/input_status.php ww3${FORC} ${HH} ${RODADA} AMARELO "${MSG}"


#---------------------------------------
# Verificando existencia do arquivo SAFO
# e comparando datas de arquivos

while [ $flag -eq 1 ];
do 

 rm $WORKDIR/ww3${AREA}/work/ww3.ctl
 ln -s $CAMINHO/$MOD/wave.${datahoje}/${fonte}.t${HH}z.ctl $WORKDIR/ww3${AREA}/work/ww3.ctl
 datacontrole=`grep TDEF $WORKDIR/ww3${AREA}/work/ww3.ctl  | cut -c33-41 | tr '[:upper:]' '[:lower:]'`


 echo
 echo $RFILE 
 echo
 echo $datacontrole 
 echo
 echo $datagrads 
 echo


# if  [ -e ${RFILE} ] && [ ${datacontrole} == ${datagrads} ] ; then 
 if [ -e "${RFILE}" ] && [ "${datacontrole}"==${datagrads} ]; then
  echo "Prontificado o ${AREA2} ${HH}Z"
  COR=1 # Amarelo
  flag=0
  else
  k=`expr $ni + 1`
  ni=$k
  echo "Aguardando o fim da rodada do ${AREA2} ${HH}Z"
  sleep 60 
 fi   
  
 if [ $ni -ge 480 ] ; then
  echo "Apos 8 horas abortei a rodada !!!!"
  COR=2 #Vermelho
  ##/usr/local/bin/atualiza_status.pl ${STATUS} ${COR} "FALHA NO POS-PROCESSAMENTO - FALTANDO ARQUIVO SAFO"
  exit 12
 fi

done

rm  $WORKDIR/ww3${AREA}/work/ww3.grads
ln -sf $CAMINHO/$MOD/wave.${datahoje}/${fonte}.t${HH}z.grads $WORKDIR/ww3${AREA}/work/ww3.grads   

##/usr/local/bin/atualiza_status.pl ${STATUS} 1 "FAZENDO FIGURAS"

# --------------------------------
# Executando a confeccao de figuras 

$WORKDIR/scripts/roda.sh ${AREA} ${HH} ${HSTOP}


# ----------------------
# Convertendo gif em png

cd $GIFDIR/ww3${AREA}${HH}/

for arq in `ls *.gif`
do  
nome=`echo $arq | cut -f1 -d.`
/usr/bin/convert $arq $nome.png 
done 
#----------------------
# Gerando a cartinha do fax

if [ \( "${AREA}" == "iap" -a "${FORC}" == "gfs" \) ]; then

	/home/operador/grads/faxsimile/scripts/faxsimile.sh ww3${AREA} ${HH}

 echo
 echo 'FAZENDO FAXSIMILE '${FORC}': '${AREA}''
 echo

fi


#-----------------------------
# Gerando produtos do cctom

if [ \( "${AREA}" == "met" -a "${FORC}" == "gfs" \) ]; then

        /home/operador/grads/cctom/scripts/cctom.sh ww3${FORC} ${HH}

 echo
 echo 'FAZENDO CCTOM '${FORC}': '${AREA}''
 echo

fi

if [ \( "${AREA}" == "met" -a "${FORC}" == "icon" \) ]; then

        /home/operador/grads/cctom/scripts/cctom_teste.sh ww3${FORC} ${HH}

 echo
 echo 'FAZENDO CCTOM '${FORC}': '${AREA}''
 echo

fi

if [ \( "${AREA}" == "met" -a "${FORC}" == "cosmo" \) ]; then

        /home/operador/grads/cctom/scripts/cctom_teste.sh ww3${FORC} ${HH}

 echo
 echo 'FAZENDO CCTOM '${FORC}': '${AREA}''
 echo

fi

# ------------------
# Gerando Ondogramas


if [ $AREA == "iap" ] || [ $AREA == "met" ]  || [ $AREA == "sse" ]  || [ $AREA == "ne" ]  || [ $AREA == "car" ]
then

 cd $WORKDIR/ww3${AREA}/ondogramas/scripts
 ##/usr/local/bin/atualiza_status.pl ${STATUS} 1 "FAZENDO ONDOGRAMAS"


 echo
 echo 'FAZENDO ONDOGRAMA '${AREA}''
 echo

 $WORKDIR/ww3${AREA}/ondogramas/scripts/geraondograma_${AREA}.sh $HH 

fi

# --------------------
# Ondogramas Comissoes

/home/operador/ftpscript/geraondograma_comissao.sh $HH $CAMINHO

rm /home/operador/grads/ww3_418/scripts/ww3.ctl
rm /home/operador/grads/ww3_418/scripts/ww3.grads

# ---------------------
# Ondogramas Dinamicos #2017NOV23

#if [ \( "${AREA}" == "iap" -a "${FORC}" == "gfs" \) ]; then

if [ \( "${FORC}" == "gfs" -a "${AREA}" == "ant" \) ] || [ \( "${FORC}" == "icon" -a "${AREA}" == "ant" \) ]; then
 /home/operador/anaconda3/bin/python /home/operador/grads/ww3_418/scripts/ww3_tabela_Drake.py $FORC $HH
fi

# echo
# echo 'FAZENDO AUXILIO para area '${AREA}''
# echo

#/home/operador/grads/auxilio_decisao/scripts/auxilio.sh $HH ww3${AREA}

MSG="ENCERRADO POS-PROC WW3/${FORC} ${datahoje} ${HH}Z"

/usr/bin/input_status.php ww3${FORC} ${HH} ${RODADA} VERDE "${MSG}"
