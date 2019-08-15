#!/bin/bash -x
# Autor: 1T(T) Neris
#
# Exemplo: extraiponto_cosmo_ww3cosmo.sh 00 -25.156 -43.358
#
# Utilidade: Extrair dados de um ponto do modelo atm/ondas num arq .txt
#
# Dependencias:
# 1- Arquivos .ctl c/ caminho completo (vide raw_extraiponto.gs);
#
# Saida:
# 1- Arquivo meteograma_cosmo_ww3cosmo_${LATI}_${LONG}_${HH}.txt
#
# Obs.:
# 1- A qualquer momento pode-se inserir novas var a serem extraidas.
# 2- A lat/lon deve ser dada em decimos de graus.

if [ $# -ne 2 ];then

	echo "Entre com o horario de referencia (00 ou 12) e o tipo de rodada (ope ou con)."
	echo "Exemplo: extraiponto_UNITAS.sh 00 ope"

        exit 12

fi

# Carregando variaveis
HH=$1
PREV=$2

datahoje=`cat ~/datas/datacorrente${HH}`
ANO=`echo ${datahoje} | cut -c1-4`
MM=`echo ${datahoje} | cut -c5-6`
DD=`echo ${datahoje} | cut -c7-8`


if [ ${PREV} == "ope" ];then

	rodada="OPE"

elif [ ${PREV} == "con" ];then

	rodada="CON"

else

	echo " Segundo parametro errado!"
	exit 13

fi


# Verificando se as dependencias do script estao disponiveis antes de prosseguir
arqatm="/home/operador/grads/cosmo/cosmosse22/ctl/ctl${HH}/cosmo_sse22_${HH}_M.ctl"
arqatm7="/home/operador/grads/cosmo/cosmomet/ctl/ctl${HH}/cosmo_met5_${HH}_M.ctl"
arqatmz="/home/operador/grads/cosmo/cosmosse22/ctl/ctl${HH}/cosmo_sse22_${HH}_Z.ctl"
arqond="/mnt/nfs/dpns32/data2/operador/mod_ondas/ww3_418/output/ww3icon/wave.${ANO}${MM}${DD}/met.t${HH}z.ctl"
arqoce="/mnt/nfs/dpns32/data1/operador/previsao/hycom_2_2/output/Previsao_1_12/Ncdf/${ANO}${MM}${DD}/HYCOM_MV_${ANO}${MM}${DD}.nc"

# Definindo caminhos
dir_unitas="/home/operador/ftp_comissoes/UNITAS"

#####################################################################################
# Gera S4_UNITAS TXT
# Testa por 360 ciclos de 30s (3h) se o arqatm7 e o arqond existem e se sao do dia correto
n=0
while [ $n -le 360 ]; do

	if [ `head -1 $arqatm7 | cut -d_ -f 4 | cut -c 7-8` = $DD ] && \
	[ `head -9 $arqond | tail -1 | cut -d: -f 2 | cut -c 4-5` = $DD ]; then

		echo "Arquivos ${arqatm7} e ${arqond} encontrados e do dia corrente. Vou prosseguir com a execucao do script!..."
		echo ""
		sleep 120

		# Criando link
		ln -sf /mnt/nfs/dpns32/data2/operador/mod_ondas/ww3_418/output/ww3icon/wave.${ANO}${MM}${DD}/met.t${HH}z.grads  ww3.grads

		# Gerando arq raw para rodar no GrADS

		arq="${dir_unitas}/lista"
		tr -d '\r' < $arq > raw.txt
		mv raw.txt $arq

		nlinhas=`cat $arq | wc -l`

		for i in `seq 1 $nlinhas`;do

			info=`cat $arq | head -$i | tail -1`
			loca=`echo ${info} | awk '{print $1}'`
			LATI=`echo ${info} | awk '{print $2}'`
			LONG=`echo ${info} | awk '{print $3}'`

			rm raw_extraiponto.gs

			if [ ${rodada} == "OPE" ];then
		
				cat ${dir_unitas}/dadosponto7km_UNITAS_OPE.gs > raw_extraiponto.gs
				RR=48

			else

				cat ${dir_unitas}/dadosponto7km_UNITAS_CON.gs > raw_extraiponto.gs
				RR=60
	
			fi

			sed -i 's/ANO/'${ANO}'/g'	raw_extraiponto.gs
			sed -i 's/MM/'${MM}'/g'		raw_extraiponto.gs
			sed -i 's/DD/'${DD}'/g'		raw_extraiponto.gs
			sed -i 's/HH/'${HH}'/g'		raw_extraiponto.gs
			sed -i 's/LOCAL/'${loca}'/g'	raw_extraiponto.gs
			sed -i 's/LATI/'${LATI}'/g'	raw_extraiponto.gs
			sed -i 's/LONG/'${LONG}'/g'	raw_extraiponto.gs
			sed -i 's/RODA/'${rodada}'/g'	raw_extraiponto.gs

			# Roda o script que gera o txt
			/opt/opengrads/Contents/opengrads -bpc raw_extraiponto.gs

			sed -i 's/ //g' S4_UNITAS_${loca}_${HH}.txt
			mv S4_UNITAS_${loca}_${HH}.txt ${dir_unitas}/S4_UNITAS_${loca}_${HH}_${rodada}.txt

			# Testando se o tamanho e a data dos arquivos estao corretos
			if [ `ls -l ${dir_unitas}/S4_UNITAS_${loca}_${HH}_${rodada}.txt | awk '{ print $5 }'` -ge 200 ] && \
			[ `cat ${dir_unitas}/S4_UNITAS_${loca}_${HH}_${rodada}.txt | head -1 | cut -f4 -d","` == \
			`caldate ${datahoje}${HH} + ${RR}h 'hhZddMMMyyyy' | tr [a-z] [A-Z]` ]; then
				
				echo "Arquivo ${dir_unitas}/S4_UNITAS_${loca}_${HH}_${rodada}.txt gerado corretamente. Prosseguindo... "
				scp ${dir_unitas}/S4_UNITAS_${loca}_${HH}_${rodada}.txt previsor@10.12.101.2:/home/previsor/UNITAS/
				scp ${dir_unitas}/S4_UNITAS_${loca}_${HH}_${rodada}.txt previsor@10.12.70.75:/home/previsor/UNITAS/
			
			else

				echo "Arquivo ${dir_unitas}/S4_UNITAS_${loca}_${HH}_${rodada}.txt NAO foi gerado corretamente! ***VERIFICAR PROBLEMA!***"
				echo "Tamanho do arq (Ref.: 200): `ls -l ${dir_unitas}/S4_UNITAS_${loca}_${HH}_${rodada}.txt | awk '{ print $5 }'`"
				echo "Horario do arq (Ref.: `caldate ${datahoje}${HH} + ${RR}h 'hhZddMMMyyyy' | tr [a-z] [A-Z]`): \
					`cat ${dir_unitas}/S4_UNITAS_${loca}_${HH}_${rodada}.txt | head -1 | cut -f4 -d","`"
				echo "Verificar erro!" | mail -s "Erro na geracao arquivo UNITAS ${dir_unitas}/S4_UNITAS_${loca}_${HH}_${rodada}.txt" \
					felipenc2@gmail.com

			fi

		done

		rm ww3.grads
		break
		#echo "Abrir o arquivo anexado e colar na tabela" | mail -s "Dados Pontos COSMO/WW3COSMO ${HH}" neris@marinha.mil.br -A meteograma_cosmo_ww3cosmo_${LATI}_${LONG}_${HH}.txt

	else
		if [ `head -1 $arqatm7 | cut -d_ -f 4 | cut -c 7-8` != $DD ]; then
			
			echo "Arquivo $arqatm7 NAO foi gerado corretamente (`head -1 $arqatm7 | cut -d_ -f 4 | cut -c 7-8`). Vou aguardar 30s..."
			echo ""

		elif [ `head -9 $arqond | tail -1 | cut -d: -f 2 | cut -c 4-5` != $DD ]; then

			echo "Arquivo $arqond NAO foi gerado corretamente (`head -9 $arqond | tail -1 | cut -d: -f 2 | cut -c 4-5`). Vou aguardar 30s..."
			echo ""

		fi

		sleep 30

	fi

	if [ $n -gt 360 ]; then

		echo "Esperei por *** 3hrs *** mas alguns arquivos NAO foram encontrados. Vou ABORTAR script!"
		echo ""
		rm ww3.grads
		exit 1
	fi
	n=$(( $n+1 ))
done

#####################################################################################
# Gera S3_UNITAS TXT
# Testa por 360 ciclos de 30s se os arq dos modelos existem e se sao do dia correto
n=0
while [ $n -le 360 ]; do

	if [ `head -1 $arqatm | cut -d_ -f 4 | cut -c 7-8` = $DD ] && \
	[ `head -1 $arqatmz | cut -d_ -f 4 | cut -c 7-8` = $DD ] && \
	[ `head -9 $arqond | tail -1 | cut -d: -f 2 | cut -c 4-5` = $DD ] && \
	[ `/home/operador/local/bin/ncdump -h $arqoce| tail -3 | head -1 | cut -d" " -f7 | cut -c 1-2` = $DD ]; then

		echo "Arquivos encontrados e do dia corrente. Vou prosseguir com a execucao do script!..."
		echo ""
		sleep 120

		# Criando link
		ln -sf /mnt/nfs/dpns32/data2/operador/mod_ondas/ww3_418/output/ww3icon/wave.${ANO}${MM}${DD}/met.t${HH}z.grads  ww3.grads

		# Gerando arq raw para rodar no GrADS

		arq="${dir_unitas}/lista"
		tr -d '\r' < $arq > raw.txt
		mv raw.txt $arq

		nlinhas=`cat $arq | wc -l`

		for i in `seq 1 $nlinhas`;do

			info=`cat $arq | head -$i | tail -1`
			loca=`echo ${info} | awk '{print $1}'`
			LATI=`echo ${info} | awk '{print $2}'`
			LONG=`echo ${info} | awk '{print $3}'`

			rm raw_extraiponto.gs

			if [ ${rodada} == "OPE" ];then
		
				cat ${dir_unitas}/dadosponto_UNITAS_OPE.gs > raw_extraiponto.gs
				RR=12

			else

				cat ${dir_unitas}/dadosponto_UNITAS_CON.gs > raw_extraiponto.gs
				RR=24
	
			fi

			sed -i 's/ANO/'${ANO}'/g'	raw_extraiponto.gs
			sed -i 's/MM/'${MM}'/g'		raw_extraiponto.gs
			sed -i 's/DD/'${DD}'/g'		raw_extraiponto.gs
			sed -i 's/HH/'${HH}'/g'		raw_extraiponto.gs
			sed -i 's/LOCAL/'${loca}'/g'	raw_extraiponto.gs
			sed -i 's/LATI/'${LATI}'/g'	raw_extraiponto.gs
			sed -i 's/LONG/'${LONG}'/g'	raw_extraiponto.gs
			sed -i 's/RODA/'${rodada}'/g'	raw_extraiponto.gs

			# Roda o script que gera o txt
			/opt/opengrads/Contents/opengrads -bpc raw_extraiponto.gs

			sed -i 's/ //g' meteograma_UNITAS_${loca}_${HH}.txt
			mv meteograma_UNITAS_${loca}_${HH}.txt ${dir_unitas}/UNITAS_${loca}_${HH}_${rodada}.txt

			# Testando se o tamanho e a data dos arquivos estao corretos
			if [ `ls -l ${dir_unitas}/UNITAS_${loca}_${HH}_${rodada}.txt | awk '{ print $5 }'` -gt 1000 ] && \
			[ `cat ${dir_unitas}/UNITAS_${loca}_${HH}_${rodada}.txt | head -1 | cut -f4 -d","` == \
			`caldate ${datahoje}${HH} + ${RR}h 'hhZddMMMyyyy' | tr [a-z] [A-Z]` ]; then
				echo "Arquivo ${dir_unitas}/UNITAS_${loca}_${HH}_${rodada}.txt gerado corretamente. Prosseguindo... "
				scp ${dir_unitas}/UNITAS_${loca}_${HH}_${rodada}.txt previsor@10.12.101.2:/home/previsor/UNITAS/
				scp ${dir_unitas}/UNITAS_${loca}_${HH}_${rodada}.txt previsor@10.12.70.75:/home/previsor/UNITAS/
			else
				echo "Arquivo ${dir_unitas}/UNITAS_${loca}_${HH}_${rodada}.txt NAO foi gerado corretamente! ***VERIFICAR PROBLEMA!***"
				echo "Tamanho do arq (Ref.: 1000): `ls -l ${dir_unitas}/UNITAS_${loca}_${HH}_${rodada}.txt | awk '{ print $5 }'`"
				echo "Horario do arq (Ref.: `caldate ${datahoje}${HH} + ${RR}h 'hhZddMMMyyyy' | tr [a-z] [A-Z]`): \
					`cat ${dir_unitas}/UNITAS_${loca}_${HH}_${rodada}.txt | head -1 | cut -f4 -d","`"
				echo "Verificar erro!" | mail -s "Erro na geracao arquivo UNITAS ${dir_unitas}/UNITAS_${loca}_${HH}_${rodada}.txt" \
					felipenc2@gmail.com
				rm ww3.grads
				exit 1
			fi

		done

		rm ww3.grads
		exit 00
		#echo "Abrir o arquivo anexado e colar na tabela" | mail -s "Dados Pontos COSMO/WW3COSMO ${HH}" neris@marinha.mil.br -A meteograma_cosmo_ww3cosmo_${LATI}_${LONG}_${HH}.txt

	else
		if [ `head -1 $arqatm | cut -d_ -f 4 | cut -c 7-8` != $DD ]; then

			echo "Arquivo $arqatm NAO foi gerado corretamente (`head -1 $arqatm | cut -d_ -f 4 | cut -c 7-8`). Vou aguardar 30s..."
			echo ""

		elif [ `head -1 $arqatmz | cut -d_ -f 4 | cut -c 7-8` != $DD ]; then

			echo "Arquivo $arqatmz NAO foi gerado corretamente (`head -1 $arqatmz | cut -d_ -f 4 | cut -c 7-8`). Vou aguardar 30s..."
			echo ""

		elif [ `head -9 $arqond | tail -1 | cut -d: -f 2 | cut -c 4-5` != $DD ]; then

			echo "Arquivo $arqond NAO foi gerado corretamente (`head -9 $arqond | tail -1 | cut -d: -f 2 | cut -c 4-5`). Vou aguardar 30s..."
			echo ""

		elif [ `/home/operador/local/bin/ncdump -h $arqoce| tail -3 | head -1 | cut -d" " -f7 | cut -c 1-2` != $DD ]; then

			echo "Arquivo $arqoce NAO foi gerado corretamente (`head -9 $arqoce | tail -1 | cut -d: -f 2 | cut -c 4-5`). Vou aguardar 30s..."
			echo ""

                fi
			
		sleep 30

	fi

	if [ $n -gt 360 ]; then

		echo "Esperei por *** 3hrs *** mas alguns arquivos NAO foram encontrados. Vou ABORTAR script!"
		echo ""
		rm ww3.grads
		exit 11
	fi
	n=$(( $n+1 ))
done
