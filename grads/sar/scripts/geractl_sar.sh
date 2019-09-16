#!/bin/bash -x
# Autor: 1T(T) Neris
#
# Exemplo: extraiponto_cosmo_ww3cosmo.sh 00 -25.156 -43.358
#
# Utilidade: Extrair dados de um ponto do modelo atm/ondas num arq .txt
#
# Dependencias:
# 1- Arquivos:
# arqatm=/home/operador/grads/cosmo/cosmosse22/ctl/ctl00/cosmo_sse22_00_M.ctl
# arqatm7=/home/operador/grads/cosmo/cosmomet/ctl/ctl00/cosmo_met5_00_M.ctl
# arqatmz=/home/operador/grads/cosmo/cosmosse22/ctl/ctl00/cosmo_sse22_00_Z.ctl
# arqond=/mnt/nfs/dpns32/data2/operador/mod_ondas/ww3_418/output/ww3icon/wave.20190816/met.t00z.ctl
# arqoce=/mnt/nfs/dpns32/data1/operador/previsao/hycom_2_2/output/Previsao_1_12/Ncdf/20190816/HYCOM_MV_20190816.nc
# (Na duvida, vide raw_extraiponto.gs)
#
# 2- Lista com pontos (vide arquivo lista)
#
# Saida:
# 1- Arquivo meteograma_cosmo_ww3cosmo_${LATI}_${LONG}_${HH}.txt
#
# Obs.:
# 1- A qualquer momento pode-se inserir novas var a serem extraidas.
# 2- A lat/lon deve ser dada em decimos de graus.

if [ $# -ne 1 ];then

	echo "Entre com o horario de referencia (00 ou 12)."
	echo "Exemplo: geratabela_SAR.sh 00"

        exit 12

fi

# Carregando variaveis
HH=$1

datahoje1=`cat ~/datas/datacorrente${HH}`
datahoje=`caldate ${datahoje1} - 30d 'hhZddmmmyyyy' | tr [a-z] [A-Z]`
datahojem=`caldate ${datahoje1} - 732h yyyymmddhh`
ANO=`echo ${datahoje} | cut -c9-12`
MM=`echo ${datahoje} | cut -c6-8`
DD=`echo ${datahoje} | cut -c4-5`

# Definindo caminhos
dirsarctl="/home/operador/grads/sar/ctl"
dirsarbin="/home/operador/grads/sar/bin"

# Verificando se as dependencias do script estao disponiveis antes de prosseguir
arqatm="cosmo_met"
arqond="ww3icon_met"
arqoce="hycom_met"

#####################################################################################
# FOR para gerar CTL de cada modelo ATU com a datahora da ultima rodada disponivel
mods="${arqatm} ${arqond} ${arqoce}"
for mod in ${mods}; do

	echo "Gerando arq CTL para ${mod}..."
	cat ${dirsarctl}/${mod}_template.ctl > ${dirsarctl}/${mod}.ctl
	sed -i 's/ANO/'${ANO}'/g'	${dirsarctl}/${mod}.ctl
	sed -i 's/MM/'${MM}'/g'		${dirsarctl}/${mod}.ctl
	sed -i 's/DD/'${DD}'/g'		${dirsarctl}/${mod}.ctl
	sed -i 's/HH/'${HH}'/g'		${dirsarctl}/${mod}.ctl

	#####################################################################################
	# Removendo binarios anteriores a 30 dias atras

	echo "Removendo binarios anteriores a 30 dias: ${dirsarbin}/${mod}_${datahojem}.bin"
	rm ${dirsarbin}/${mod}_${datahojem}.bin

done

