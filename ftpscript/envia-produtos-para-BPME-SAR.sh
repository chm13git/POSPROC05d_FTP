#!/bin/bash
###########################################################
# Scripts para copiar figuras para serem usadas nos       #
# Boletins de Previsao Meteorologica Especial (BPME) para #
# Busca e Salvamento					  #
# Feito por CT(T)Alana em 26JUL2018			  #
###########################################################
set -xv
HH=$1

if [ $# -lt 1 ]
then
echo " Entre com o horario de referencia 00 ou 12"
exit 12
fi

### Criando pasta com a data do dia ### 
data=`date +%d%m%Y`
ano=`date +%Y`
mes=`date +%B` 

mkdir -p /home/operador/backup_produtos_modelagem/$ano/$mes/$data

echo "FAZENDO BACKUP DO FAX"


