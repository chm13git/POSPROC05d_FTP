#!/bin/bash

if [ $# -ne 1 ]
then
echo "entre com o horario de referencia"
exit 12
fi

HH=$1

echo "'reinit'" > /home/operador/grads/cosmo/cosmomet/gs/raw.gs
echo "_HH=$HH" >>  /home/operador/grads/cosmo/cosmomet/gs/raw.gs
cat /home/operador/grads/cosmo/cosmomet/gs/AREPS.gs >> /home/operador/grads/cosmo/cosmomet/gs/raw.gs
/opt/opengrads/opengrads -bpc /home/operador/grads/cosmo/cosmomet/gs/raw.gs
rm /home/operador/grads/cosmo/cosmomet/gs/raw.gs 

for arq in `find /home/operador/grads/gif/cosmomet_$HH/ -atime +7`
do
rm $arq
done
