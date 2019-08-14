#!/bin/bash -x
# Autor: 1T(T) Neris
#
# Exemplo: extraiponto_cosmo_ww3cosmo.sh 00 -25.156 -43.358
#
# Utilidade: Extrair dados de um ponto do modelo atm/ondas num arq .txt
#
# Dependencias:
# 1- Arquivos .ctl c/ caminho completo (vide dadosponto-cosmo-ww3cosmo.gs);
#
# Saida:
# 1- Arquivo meteograma_cosmo_ww3cosmo_${LATI}_${LONG}_${HH}.txt
#
# Obs.:
# 1- A qualquer momento pode-se inserir novas var a serem extraidas.
# 2- A lat/lon deve ser dada em decimos de graus.

if [ $# -ne 3 ];then

        echo "Entre com o horario de referencia (00 ou 12), a LATItude (ex.: -25.156) e a LONGitude (ex.: -43.358)!!!"
	echo "Exemplo: missilex_cosmo_ww3cosmo.sh 00 -25.156 -43.358"

        exit 12

fi

HH=$1
LATI=$2
LONG=$3

sed -i 's/HH/'${HH}'/g' dadosponto-cosmo-ww3cosmo.gs
sed -i 's/LATI/'${LATI}'/g' dadosponto-cosmo-ww3cosmo.gs
sed -i 's/LONG/'${LONG}'/g' dadosponto-cosmo-ww3cosmo.gs

opengrads -bpc dadosponto-cosmo-ww3cosmo.gs

sed -i 's/ //g' meteograma_cosmo_ww3cosmo_${LATI}_${LONG}_${HH}.txt

echo "Abrir o arquivo anexado e colar na tabela" | mail -s "Dados Pontos COSMO/WW3COSMO ${HH}" neris@marinha.mil.br -A meteograma_cosmo_ww3cosmo_${LATI}_${LONG}_${HH}.txt

sed -i 's/'${HH}'/HH/g' dadosponto-cosmo-ww3cosmo.gs
sed -i 's/'${LATI}'/LATI/g' dadosponto-cosmo-ww3cosmo.gs
sed -i 's/'${LONG}'/LONG/g' dadosponto-cosmo-ww3cosmo.gs
