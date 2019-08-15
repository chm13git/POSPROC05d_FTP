#!/bin/bash

if [ $# -ne 2 ]
then
   echo
   echo "Entre com o horario de referencia (00 ou 12) e com o caminho da máquina (07 ou 31)"
   echo
   exit
fi


# Definindo variaveis e areas

HH=$1
CAMINHO=$2


# COMISSÕES
/home/operador/grads/ww3_418/scripts/ondograma_comissao.sh cosmo $HH met $CAMINHO
/home/operador/grads/ww3_418/scripts/ondograma_comissao.sh icon $HH met $CAMINHO
/home/operador/grads/ww3_418/scripts/ondograma_comissao.sh gfs $HH met $CAMINHO

exit
