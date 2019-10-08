#!/bin/bash -x

if [ $# -ne 5 ];then

        echo "Entre com a data inicial, a data final, a latitude, a longitude e o nome do SAR, conforme SOL pelo pedido de abertura de SAR."
	echo "Ex.: geratabela_sar.sh 2019083000 2019090100 -23.4 -43.1 SSE023"

        exit 12

fi

# Carregando variaveis
DI=$1
DF=$2
LT=$3
LN=$4
NS=$5

/usr/bin/caldate ${DI} + 0h 'hhZddMMMyyyy' | tr [a-z] [A-Z] > /dados/grads/sar/scripts/dataim

#ssh operador@localhost " /opt/opengrads/opengrads -bpc \"/home/operador/grads/sar/scripts/dadosponto_SAR.gs ${DI} ${DF} ${LT} ${LN} ${NS}\" "
/opt/opengrads/opengrads -bpc "/home/operador/grads/sar/scripts/dadosponto_SAR.gs ${DI} ${DF} ${LT} ${LN} ${NS}"
#ssh operador@10.13.50.14 " /opt/opengrads/opengrads -bpc \"/home/operador/grads/sar/scripts/dadosponto_SAR.gs ${DI} ${DF} ${LT} ${LN} ${NS} \" "

