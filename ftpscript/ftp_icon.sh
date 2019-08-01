#!/bin/bash -x

#
# Script para geracao dos produtos do ICON
# Elaborado pela Ten Alana em 18JAN2015 
#

HH=$1
moddir="/home/operador/grads/icon"
arqctls="icon.ctl ventoicon.ctl"
areas="atl met ant"
espvordpnt02b="/home/supervisor/Servico/Modelos/espvor_supsvc${HH}"
espvordpnt02="/home/supervisor/Servico/Modelos/espvor_supsvc${HH}"
RODADA="Operacional"  # trocar p/  operacional quando a pagina status estiver ok
if [ $# -ne 1 ];then

	echo " Voce deve entrar com o horario de referencia"
	exit 12

fi

echo ============================
echo
echo Inicio do ICON ATLANTICO HHZ
date
echo
echo

datacorrente=`cat /home/operador/datas/datacorrente${HH}`
datagrads=`cat /home/operador/datas/datacorrente_grads${HH}| tr '[:upper:]' '[:lower:]'`
dadosdir="/home/operador/data/icon/atl${HH}"
dadosvento="/home/operador/data/icon/wind${HH}"
ICONFILE=icon_reg_to_client_bsm2_${datacorrente}${HH}.grib2.bz2
ICONFILE2=icon_reg_to_client_bsm2_${datacorrente}${HH}.grib2
ICONVENT=icon_reg_to_client_bsm1_${datacorrente}${HH}.grib2.bz2
ICONVENT2=icon_reg_to_client_bsm1_${datacorrente}${HH}.grib2

MSG="INICIO POS-PROCESSAMENTO ICON $datacorrente ${HH}Z"
/usr/bin/input_status.php ICON $HH $RODADA AMARELO "$MSG"

rm /home/operador/grads/icon/vento${HH}/icon_reg_to_client_bsm1_*
ni=0
flag=1

while [ $flag -eq 1 ];do

	if [ -e $dadosdir/${ICONFILE} ] && [ -e $dadosvento/${ICONVENT} ];then

		cp  $dadosvento/${ICONVENT} /home/operador/grads/icon/vento${HH}
		cp $dadosdir/${ICONFILE} /home/operador/grads/icon/dados/dados${HH}
		bunzip2 /home/operador/grads/icon/vento${HH}/${ICONVENT}
		bunzip2 /home/operador/grads/icon/dados/dados${HH}/${ICONFILE}
		nl=`/usr/local/bin/wgrib2 -v /home/operador/grads/icon/vento${HH}/${ICONVENT2} | wc -l`

		# Verificacao para saber se o arquivo tem 42 linhas

		if [ $nl -eq 42 ];then

			flag=0

		else

			k=`expr $ni + 1`
			ni=$k
			echo "AGUARDANDO OS DADOS DO ICON CHEGAREM"
			#rm /home/operador/grads/icon/icon_reg_to_client_bsm1_${datacorrente}${HH}.grib2
			
                        resto=`expr $k % 20`
                        if [ $resto -eq 0 ]; then
                        min=`echo "$k * 30 / 60" | bc`
                        MSG="AGUARDANDO HA $min MIN OS DADOS ICON $datacorrente ${HH}Z"
                        /usr/bin/input_status.php ICON $HH $RODADA AMARELO "$MSG"
                        fi

			sleep 30
		fi

	else

		k=`expr $ni + 1`
		ni=$k
		echo "Aguardando a chegada dos dados de VENTOICON e do ICONMODEL"
		sleep 30

                        resto=`expr $k % 20`
                        if [ $resto -eq 0 ]; then
                        min=`echo "$k * 30 / 60" | bc `
                        MSG="AGUARDANDO HA $min MIN OS DADOS VENTOICON e ICONMODEL $datacorrente ${HH}Z"
                        /usr/bin/input_status.php ICON $HH $RODADA AMARELO "$MSG"
                        fi


	fi

 
	if [ $ni -ge 480 ];then

		if [ -e $dadosdir/${ICONFILE} ];then

			echo "Alguns campos irao falhar pela ausencia do dado de vento"
			flag=3
                        sleep 3
                        MSG="ALGUNS CAMPOS IRAO FALHAR - VENTOICON $datacorrente ${HH}Z AUSENTE"
                        /usr/bin/input_status.php ICON $HH $RODADA VERMELHO "$MSG"
		else
                        sleep 3
                        MSG="FALHA - DADOS VENTOICON E ICONMODEL $datacorrente ${HH}Z AUSENTES"
                        /usr/bin/input_status.php ICON $HH $RODADA VERMELHO "$MSG"
			echo "Apos 4 horas abortei a rodada !!!!"
			exit 12
		fi
	fi

done

#sleep 60

#
#
echo
echo
echo
echo alterando ctl...
echo

cd ${moddir}/ctl

for arqctl in `echo $arqctls`;do

	cat ${arqctl}.raw | sed -e 's|HH|'$HH'|g' > raw
	cat raw | sed -e 's|DATAGRADS|'$datagrads'|g' > raw2
	cat raw2 | sed -e 's|ICONFILE|'$ICONFILE2'|g' > raw
	cat raw | sed -e 's|DATACORRENTE|'$datacorrente'|g' > raw2
	mv raw2 ${moddir}/ctl/ctl${HH}/${arqctl}
	rm raw*
	/usr/local/bin/gribmap -i ${moddir}/ctl/ctl${HH}/${arqctl}
	#/usr/local/bin/gribapi2ctl -i ${moddir}/ctl/ctl${HH}/${arqctl}
	chmod a+w *

done

echo
echo executando GrADs...
echo

/home/operador/grads/icon/scripts/roda.sh ${HH}

for area in `echo $areas`;do

dpnt02bdir="/home/supervisor/Servico/Modelos/icon_${area}${HH}"
	dpnt02dir="/home/supervisor/Servico/Modelos/icon_${area}${HH}"
#	/home/operador/grads/icon/scripts/meteogramas.sh ${area} ${HH} ${datacorrente}
	cd /home/operador/grads/gif/icon${area}${HH}/ 

	for arq in `ls *.gif`;do

		nomeprog=`echo $arq | cut -f1 -d.`
		/usr/bin/convert $arq $nomeprog.png

	done

	chmod -R a+w /home/operador/grads/iconatl/*
	/home/operador/ftp_comissoes/ftp_comissoes.sh ${HH} iconatl
	#/home/operador/ftp_comissoes/ftp_comissoes.sh ${HH} gmemet
	#/home/operador/ftp_comissoes/ftp_comissoes.sh ${HH} gmeant

	echo
	echo FIM ICON ATLANTICO ${HH}Z
	date
	echo
	echo =======================================================================
	# FIM
done

if [ $flag -eq 0 ]; then
MSG="POS-PROC ICONMODEL $datacorrente ${HH}Z finalizado"
/usr/bin/input_status.php ICON $HH $RODADA VERDE "$MSG"
fi
