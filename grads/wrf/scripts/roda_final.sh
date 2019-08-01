#!/bin/bash -x

###############################################
#
# Este script visa realizar o pos-processamento
# de campos especificos que apresentam problemas
# durante o processo normal de geracao das figuras,
# alem de gerar os campos de tendencia de T que
# necessitam do ctl com todos os tempos disponiveis.
#
# Este script roda no final do ftp_wrf.sh no
# intuito de solucionar os problemas de geracao
# dos campos descritos abaixo.
#
# campos processados: espvor; vor+geo
#
# Autor: CT(T) Alexandre Gadelha
#
# Criado em: 02MAI2016
# Alterado em 24MAI2026 por 1T(T) Neris
###############################################

if [ $# -ne 4 ];then
	echo "Entre com a area modelada (metarea5, antartica e caribe), com o horario de referencia (00 ou 12) e com o prognostico de inicio e de fim da rodada!!!"
	exit 12
fi

AREA=$1
HH=$2
HINI=$3
HFIM=$4

echo "Os seguintes parametros foram passados para o script:"
echo "AREA=$AREA"
echo "HH=$HH - horario de referencia da rodada "
echo "HINI=$HINI"
echo "HFIM=$HFIM - extensao temporal em horas da previsao"

case ${AREA} in
        metarea5)
        STATUS1=50
        AREA2=met
        AREA3=metarea5
        INT=3
        ;;
        met510km)
        STATUS1=51
        AREA2=10km
        AREA3=met510km
        INT=3
        ;;
        antartica)
        STATUS1=52
        AREA2=ant
        AREA3=antartica
        INT=3
        ;;
        cptec)
#        STATUS1=54
        AREA2=cptec
        AREA3=$AREA
        INT=1
	;;
esac

dados_grib="/home/operador/data/wrf/${AREA}/grib_${HH}"
dados_dat="/home/operador/data/wrf/${AREA}/dat_${HH}"

dpns5dir="/home/operador/grads/wrf/wrf_${AREA}"
dadosdir="${dpns5dir}/dados${HH}"
dir_upp="${dpns5dir}/grib_${HH}"
dir_arw="${dpns5dir}/dat_${HH}"
dir_ctl="${dpns5dir}/ctl"

gifdir="/home/operador/grads/gif/wrf_${AREA}_${HH}"

dpnt02bdir="/home/supervisor/Servico/Modelos/wrf_${AREA}${HH}"
dpnt02dir="/home/supervisor/Servico/Modelos/wrf_${AREA}${HH}"
datahoje=`cat /home/operador/datas/datacorrente`
datagrads=`cat /home/operador/datas/datacorrente_grads${HH}`

echo " Li as datas dos arquivos de datacorrente da seguinte forma:"
echo " datahoje=$datahoje"
echo " datagrads=$datagrads"
echo " Se as datas estiverem desatualizadas desconfie que \
       o script ledata.sh nao atualizou os arquivos de datacorrente"

DIG="0"

for HREF in `seq ${HINI} ${INT} ${HFIM}`;do
        if [ $HREF -lt 10 ];then
                HORA=0$DIG$HREF
        elif [ $HREF -lt 100 ];then
                HORA=$DIG$HREF
        else
                HORA=$HREF
        fi
	str="${str} ${HORA}"
done

echo "Gerei uma string contendo todos os prognosticos de previsao \
     entre $HINI e $HFIM com intervalo de 3 horas"
echo "Quando a extensao da previsao e maior do que 99h eu devo \
     adicionar um digito a todos os prognosticos, ficando 000, 003 .... 120"
echo ""
echo " Os prognosticos serao:"
echo "$str"

# Definindo o CABECALHO
#

if [ $AREA == "cptec" ];then

        CABECALHO="Modelo WRF/CPTEC"

elif [ $AREA == "met510km" ];then

        CABECALHO="Modelo WRF10KM/CHM"

else
        CABECALHO="Modelo WRF/CHM"

fi

for prog in `echo ${str}`;do
	deltat=`echo "( $prog + 0 )" | bc`
	datacorrente=`cat /home/operador/datas/datacorrente$HH`
	#datacorrente="20141125"
	dataanalise=`/usr/bin/caldate $datacorrente$HH + 000h 'hhZddmmmyyyy(sd)'`
	dataprev=`/usr/bin/caldate $datacorrente$HH + ${deltat}h 'hhZddmmmyyyy(sd)'`
	meses="JAN;FEV;MAR;ABR;MAI;JUN;JUL;AGO;SET;OUT;NOV;DEZ"
	months="Jan;Feb;Mar;Apr;May;Jun;Jul;Ago;Sep;Oct;Nov;Dec"
	dias="Dom;Seg;Ter;Qua;Qui;Sex;Sab"
	diasp="Domingo;Segunda-feira;Terca-feira;Quarta-feira;Quinta-feira;Sexta-feira;Sabado"

	for j in `seq 1 7`;do
		dia=`echo $dias | cut -f$j -d";"`
		day=`echo $diasp | cut -f$j -d";"`
		dataraw=`echo $dataanalise | sed -e 's/'$day'/'$dia'/'`
		dataanalise=$dataraw
		dataraw=`echo $dataprev | sed -e 's/'$day'/'$dia'/'`
		dataprev=$dataraw
	done

	for j in `seq 1 12`;do
		mes=`echo $meses | cut -f$j -d";"`
		month=`echo $months | cut -f$j -d";"`
		dataraw=`echo $dataanalise | sed -e 's/'$month'/'$mes'/'`
		dataanalise=$dataraw
		dataraw=`echo $dataprev | sed -e 's/'$month'/'$mes'/'`
		dataprev=$dataraw
	done

	cd /home/operador/grads/wrf/wrf_${AREA}/gs

	#echo Usando a seguinte lista p/ geracao de campos:
	#echo "`cat /home/operador/grads/wrf/wrf_${AREA}/invariantes/lista_final`"

	for tarq in `cat /home/operador/grads/wrf/wrf_${AREA}/invariantes/lista_final`;do
		rm -f raw_final.gs
		echo "'reinit'" > raw_final.gs
		echo str=\"$str\" >> raw_final.gs
		cat $tarq > temp1

		prefixgs=`echo ${tarq} | cut -c1-3`
		echo Prefixo = ${prefixgs}

		# Este Primeiro IF serve para trabalhar o ZOOM da METAREA5
		# que tem o foco somente na regiao SUL e SUDESTE do pais.
		# Ele procura o termo SSE no inicio dos arquivos CTL dentro 
		# do diretorio INVARIANTES da METAREA5 e configura caminhos 
		# especificos para realizar o pos processamento SSE.

		if [ $prefixgs == "sse" ];then
		

                	if [ ${AREA} == "cptec" ];then

                        	DIRARQGIF="/home/operador/grads/gif/wrf_cptecsse_${HH}"
                        	DIRCOMGIF="/home/operador/ftp_comissoes/gif/wrf_cptecsse_${HH}"

                	elif [ ${AREA} == "met510km" ];then

                        	DIRARQGIF="/home/operador/grads/gif/wrf_sse10km_$HH"
                       		DIRCOMGIF="/home/operador/ftp_comissoes/gif/wrf_sse10km_$HH"
                	else

                        	DIRARQGIF="/home/operador/grads/gif/wrf_ssudeste_$HH"
                        	DIRCOMGIF="/home/operador/ftp_comissoes/gif/wrf_ssudeste_$HH"

	        	fi
	
			DIRINVPNG="/home/operador/grads/wrf/wrf_${AREA}/invariantes"
			DIMLAT=`cat ~/grads/wrf/wrf_${AREA}/invariantes/dims_ssudeste | head -1`
			DIMLON=`cat ~/grads/wrf/wrf_${AREA}/invariantes/dims_ssudeste | tail -1`

			# Este IF serve para escolher a figura correta para fazer o composite
			if [ ${tarq} == "sse_nebulos_internet2.gs" ];then
				FIGPNG="fundoverde_sse.png"
			else
				FIGPNG="fundo2_sse.png"
			fi

                	# Este IF verifica se a area tem o arquivo GRADE.
                	# Caso afirmativo, copia seu conteudo para o arquivo temp1

			if [ -s /home/operador/grads/wrf/wrf_${AREA}/invariantes/gradssudeste ];then
				cat /home/operador/grads/wrf/wrf_${AREA}/invariantes/gradssudeste >> temp1
			fi

		# Este Segundo IF serve para trabalhar o ZOOM da METAREA5
		# que tem o foco somente na região nordeste e norte do pais
		# Ele procura o termo NNE no inicio dos arquivos CTL dentro 
	        # do diretorio GS da METAREA5 e configura caminhos 
	        # especificos para realizar o pos processamento NNE.

		elif [ $prefixgs == "nne" ];then

			DIRARQGIF="/home/operador/grads/gif/wrf_nnordeste_$HH"
			DIRCOMGIF="/home/operador/ftp_comissoes/gif/wrf_nnordeste_$HH"
			DIRINVPNG="/home/operador/grads/wrf/wrf_${AREA}/invariantes"
			DIMLAT=`cat ~/grads/wrf/wrf_${AREA}/invariantes/dims_nne | head -1`
			DIMLON=`cat ~/grads/wrf/wrf_${AREA}/invariantes/dims_nne | tail -1`

			# Este IF serve p/ escolher a fig correta p/ fazer o composite

			if [ ${tarq} == "nne_nebulos_internet2.gs" ];then
				FIGPNG="fundoverde_nne.png"
			else
				FIGPNG="fundo2_nne.png"
			fi

			# Este IF verifica se a area tem o arquivo GRADE.
			# Caso afirmativo, copia seu conteudo para o arquivo temp1

			if [ -s /home/operador/grads/wrf/wrf_${AREA}/invariantes/gradnne ];then
				cat /home/operador/grads/wrf/wrf_${AREA}/invariantes/gradnne >> temp1
			fi

		# Este Segundo IF serve para trabalhar o ZOOM da ANTARTICA
		# que tem o foco somente na regiao da passagem do DRAKE..
		# Ele procura o termo DRK no inicio dos arquivos CTL dentro 
		# do diretorio INVARIANTES da ANTARTICA e configura caminhos 
		# especificos para realizar o pos processamento DRK.

		elif [ $prefixgs == "drk" ];then

			DIRARQGIF="/home/operador/grads/gif/wrf_drakeant_$HH"
			DIRCOMGIF="/home/operador/ftp_comissoes/gif/wrf_drakeant_$HH"
			DIRINVPNG="/home/operador/grads/wrf/wrf_${AREA}/invariantes"
			DIMLAT=`cat ~/grads/wrf/wrf_${AREA}/invariantes/dims_drakeant | head -1`
			DIMLON=`cat ~/grads/wrf/wrf_${AREA}/invariantes/dims_drakeant | tail -1`
			# Este IF serve p/ escolher a fig correta p/ fazer o composite

			if [ ${tarq} == "drk_neve.gs" ] || [ ${tarq} == "drk_nevoeiro.gs" ] || [ ${tarq} == "drk_precneb.gs" ];then
				FIGPNG="fundoverde_drk.png"
			else
	                	FIGPNG="fundo2_drk.png"
			fi

			# Este IF verifica se a area tem o arquivo GRADE.
			# Caso afirmativo, copia seu conteudo para o arquivo temp1

			if [ -s /home/operador/grads/wrf/wrf_${AREA}/invariantes/gradsdrake ];then
			cat /home/operador/grads/wrf/wrf_${AREA}/invariantes/gradsdrake >> temp1
			fi

		# Este Else serve para trabalhar as outras areas que nao precisam de ZOOM

		else
			DIRARQGIF="/home/operador/grads/gif/wrf_${AREA}_$HH"
			DIRCOMGIF="/home/operador/ftp_comissoes/gif/wrf_${AREA}_$HH"

			if [ -s /home/operador/grads/wrf/wrf_${AREA}/invariantes/grad$AREA ];then
			cat /home/operador/grads/wrf/wrf_${AREA}/invariantes/grad$AREA >> temp1
			fi
		fi

		# Alterando as var dos scripts .gs para cada area.

		cat temp1 | sed -e 's|ARQUIVOCTL|/home/operador/grads/wrf/wrf_'$AREA'/ctl/ctl'$HH'/wrf'_${AREA}_${HH}'|g' 	> temp2

		if [ $prefixgs == "sse" ];then
			cat temp2 | sed -e 's|DIMLAT|'"${DIMLAT}"'|g' > temp1
			cat temp1 | sed -e 's|DIMLON|'"${DIMLON}"'|g' > temp2
			cat temp2 | sed -e 's|DIRINVPNG|/home/operador/grads/wrf/wrf_'$AREA'/invariantes|g' > temp1
			cat temp1 | sed -e 's|FIGSSEPNG|'${FIGPNG}'|g' > temp2
		fi

		if [ $prefixgs == "nne" ];then

			cat temp2 | sed -e 's|DIMLAT|'"${DIMLAT}"'|g' > temp1
                        cat temp1 | sed -e 's|DIMLON|'"${DIMLON}"'|g' > temp2
			cat temp2 | sed -e 's|DIRINVPNG|/home/operador/grads/wrf/wrf_'$AREA'/invariantes|g' > temp1
                        cat temp1 | sed -e 's|FIGNNEPNG|'${FIGPNG}'|g' > temp2
		fi

		if [ $prefixgs == "drk" ];then
			cat temp2 | sed -e 's|DIMLAT|'"${DIMLAT}"'|g' > temp1
			cat temp1 | sed -e 's|DIMLON|'"${DIMLON}"'|g' > temp2
			cat temp2 | sed -e 's|DIRINVPNG|/home/operador/grads/wrf/wrf_'$AREA'/invariantes|g' > temp1
			cat temp1 | sed -e 's|FIGNDRKPNG|'${FIGPNG}'|g' > temp2
		fi

		cat temp2 | sed -e 's|DIRARQUIVOGIF|'$DIRARQGIF'|g' > temp1
		cat temp1 | sed -e 's|MODELO|'${CABECALHO}'|g' > temp2
		cat temp2 | sed -e 's|brmap_hires.dat|hires|g' > temp1
		cat temp1 | sed -e 's|hires|brmap_hires.dat|g' > temp2
		cat temp2 | sed -e 's|mres|brmap_hires.dat|g' > temp1
		cat temp1 | sed -e 's|HH|'$HH'|g' > temp2
		cat temp2 | sed -e 's|AREA|'${AREA}'|g' > temp1
		cat temp1 | sed -e 's|DATAPREV|'$dataprev'|g' > temp2
		cat temp2 | sed -e 's|DATAANALISE|'$dataanalise'|g' > temp1
		cat temp1 | sed -e 's|PROGN|'$prog'|g' > temp2
		cat temp2 | sed -e 's|DIRCOMISSAOGIF|'$DIRCOMGIF'|g' > temp1
		echo 
		echo Acabei de escrever o arquivo: ${tarq}
		cat temp1 >> raw_final.gs
		echo 
		echo Inserindo script que gera cabecalho...
		cat /home/operador/grads/wrf/scripts/label >> raw_final.gs

		if [ $AREA == "antartica" ];then
			/opt/opengrads/opengrads -blc "run raw_final.gs"
		else
			/opt/opengrads/opengrads -bpc "run raw_final.gs"
		fi

		echo Terminei de rodar o arquivo: ${tarq}

		echo
		echo Gerando png do ttend...
		echo


		gifdir="/home/operador/grads/gif/wrf_${AREA}_${HH}"
                cd $gifdir

                for arq in `ls ttend*${prog}.gif`;do

                        nomeprog=`echo $arq | cut -f1 -d.`
                        /usr/bin/convert $arq $nomeprog.png

                done
		cd /home/operador/grads/wrf/wrf_${AREA}/gs
	done
done
