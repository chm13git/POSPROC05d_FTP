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

# Gerando arq a serem usados pelo dadosponto_SAR.gs
/usr/bin/caldate ${DI} + 0h 'hhZddMMMyyyy' | tr [a-z] [A-Z] > /home/operador/grads/sar/scripts/dataim
/usr/bin/caldate ${DF} + 0h 'hhZddMMMyyyy' | tr [a-z] [A-Z] > /home/operador/grads/sar/scripts/datafm

# Gerando TXT
/opt/opengrads/opengrads -bpc "/home/operador/grads/sar/scripts/dadosponto_SARant.gs ${DI} ${DF} ${LT} ${LN} ${NS}"

# Gerando HTML
/usr/bin/Rscript /home/operador/grads/sar/scripts/gera_tabelaANT.R ${NS}
