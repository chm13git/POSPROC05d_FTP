#!/bin/bash -x
################################################################
# Script que realiza o Download dos dados do Modelo Global ICON #
# para pos-processamento dos dados                   		#
#                                                		#
# JUN2019                                        		#
# Autoras: Bruna Reis                            		#
#          1T(RM2-T) Andressa D'Agostini         		#     
# Adaptado por 1T(RM2-T) Fabiola                 		#   
# Modified by CT(T) Alana                        		#
################################################################

if [ $# -lt 1 ]
   then
   echo "+------------------Utilização------------------------+"
   echo "   Script para realizar o download do ICON 13 km      "
   echo "                                             	       "
   echo "          ./get_icon13.sh HH	                       "
   echo "                                                      "
   echo "       ex: ./get_icon13.sh 00 	                       "
   echo "+----------------------------------------------------+"
   exit
fi

HH=$1 #HORARIO DE SIMULAÇÃO 00Z OU 12Z
HSTART=0
HSTOP=78

# Carrega a data
AMD=`cat ~/datas/datacorrente${HH}`

# Carrega caminhos dos diretórios
DIRICON=/home/operador/grads/icon_13km
DIRICONdados=${DIRICON}/dados/dados${HH}

# Informações para interpolação da grade ICOSAHEDRAL para grade regular
# Download dos arquivos abaixo em https://opendata.dwd.de/weather/lib/cdo/
DIRICONfiles=${DIRICON}/files
TARGETICON=${DIRICONfiles}/target_grid_world_0125.txt
GRIDICON=${DIRICONfiles}/icon_grid_0026_R03B07_G.nc
WFILEICON=${DIRICONfiles}/weights_icogl2world_0125.nc


	echo "+----------------------------------------+"
	echo "+ Iniciando o Download do Dado do ICON   +" 
	echo "+----------------------------------------+"  
	date
# A programacao abaixo foi feita para que o diretorio "u" fosse associado a
# a variavel "U_10m" e assim por diante com todas as variáveis...

DIRVAR="vmax_10m u u u v v v u_10m v_10m t_2m td_2m fi fi fi pmsl snow_gsp snow_con rain_gsp rain_con"
VARS="VMAX_10M 850_U 500_U 250_U 850_V 500_V 250_V U_10M V_10M T_2M TD_2M 1000_FI 850_FI 500_FI PMSL SNOW_GSP SNOW_CON RAIN_GSP RAIN_CON"
URL="https://data.dwd.de/opendata/weather/nwp/icon/grib/${HH}"
NAME1="icon_global_icosahedral_single-level"
NAME2="icon_global_icosahedral_pressure-level"
NAME3="icon_global_icosahedral_model-level"
NAME="$NAME1 $NAME2 $NAME2 $NAME2 $NAME2 $NAME2 $NAME2 $NAME1 $NAME1 $NAME1 $NAME1 $NAME2 $NAME2 $NAME2 $NAME1 $NAME1 $NAME1 $NAME1 $NAME1 $NAME3 $NAME3"

        echo "+-----------------------------------------+"
        echo "+ Testando se os dados comecaram a chegar +"
        echo "+-----------------------------------------+"
        date

	ni=0
	flag=1

while [ $flag -eq 1 ];do
	cd ${DIRICONdados}
        wget --user=dhnbrasil --password=_Lv=qT4CVh86zjps0xSOhnJmN --no-check-certificate ${URL}/pmsl/icon_global_icosahedral_single-level_${AMD}${HH}_000_PMSL.grib2.bz2
        ls icon_global_icosahedral_single-level_${AMD}${HH}_000_PMSL.grib2.bz2 | cut -c38-45 > dataana.txt
      
	if [ `cat dataana.txt` = ${AMD} ];then
                echo "OS DADOS DE ${AMD} do HORÁRIO DE ${HH}Z COMECARAM A CHEGAR"

	        cd $DIRICONdados
        	rm ${DIRICONdados}/icon*

        	NVARS=`echo $VARS | wc -w`
        	echo "$NVARS"

        		for PROG in `seq -s " " -f "%03g" ${HSTART} 1 ${HSTOP}`;do
                		for VAR in `seq 1 ${NVARS}` ; do
                        	VAR1=`echo ${DIRVAR} | cut -d" " -f${VAR}`
                        	VAR2=`echo ${VARS}   | cut -d" " -f${VAR}`
                        	VAR3=`echo ${NAME}   | cut -d" " -f${VAR}`
                       		 wget --user=dhnbrasil --password=_Lv=qT4CVh86zjps0xSOhnJmN --no-check-certificate ${URL}/${VAR1}/${VAR3}_${AMD}${HH}_${PROG}_${VAR2}.grib2.bz2
                		done
        		done

	flag=0
        else

        	k=`expr $ni + 1`
        	ni=$k
        	echo "AGUARDANDO OS DADOS DO ICON CHEGAREM"
                        resto=`expr $k % 20`
                        if [ $resto -eq 0 ]; then
                        min=`echo "$k * 30 / 60" | bc`
                        MSG="AGUARDANDO HA $min MIN OS DADOS ICON $datacorrente ${HH}Z"
                        fi

                        sleep 30
	fi


        if [ $ni -ge 480 ];then

                        echo "Apos 4 horas abortei a rodada !!!!"
                        exit 12
                fi

done

	cp *.bz2 ${DIRICON}/backup/backup${HH}
	
	/bin/bunzip2 ${DIRICONdados}/*.bz2

############ INTERPOLAÇÃO PARA GRADE REGULAR ##############
# Gera o arquivo com os pesos para interpolação (roda só 1x)
date
cd ${DIRICONfiles} 
#/usr/local/bin/cdo gennn,${TARGETICON} ${GRIDICON} ${WFILEICON}
/usr/bin/cdo gennn,${TARGETICON} ${GRIDICON} ${WFILEICON}

# Gera o arquivo com informação da grade a ser interpolada 
# Informacoes em ${TARGETICON}:
# CDO grid description file for global regular grid of ICON
gridtype=lonlat
xsize=2879
ysize=1441
xfirst=-180
xinc=0.125
yfirst=-90
yinc=0.125

# Interpola todos os arquivos do diretório ---
for in_file in `ls -1 ${DIRICONdados}/*.grib2`; do
	
	out_file="${in_file/.grib2/_regulargrid.grib2}"
	echo " Nome do Arquivo de INPUT  = $in_file  " 
	echo " Nome do Arquivo de OUTPUT = $out_file "
	/usr/bin/cdo -f grb2 remap,${TARGETICON},${WFILEICON} ${in_file} ${out_file}

done
for VAR in $VARS; do
/usr/bin/cdo mergetime ${DIRICONdados}/*${VAR}*_regulargrid.grib2  ${DIRICONdados}/icon13km_${VAR}_${HH}.grib2
done

/usr/bin/cdo merge ${DIRICONdados}/icon13km*.grib2  ${DIRICONdados}/icon13km_${HH}.grib2

	echo "+-------------------------------------+"
	echo "+ Check do Download do Dado do ICON   +"
	echo "+-------------------------------------+"

# Comments:
# O check eh feito pelo numero de registros gravados em icon13km_${HH}.grib2, ou seja, 
# o script cria este arquivo com TODOS os horarios e TODAS as variaveis apenas para contar a quantidade
# total de dados baixados. Caso no futuro se deseje efetuar o download de mais variaveis o valor de referencia
# devera ser ALT.

	num_records_ref=1482
	num_records=`/usr/local/bin/wgrib2 ${DIRICONdados}/icon13km_${HH}.grib2 | wc -l`
	num_tentativas=1
	flag=1

	while [ ${flag} -eq 1 ] && [ ${num_tentativas} -le 10 ]; do
        	if [ ${num_records} -lt ${num_records_ref} ] ;then
        	echo " Arquivo icon13km_${HH}.grib2 menor que o padrao"
	
		cd $DIRICONdados
		rm ${DIRICONdados}/icon*
		NVARS=`echo $VARS | wc -w`
		echo "$NVARS"
			for PROG in `seq -s " " -f "%03g" ${HSTART} 1 ${HSTOP}`;do
				for VAR in `seq 1 ${NVARS}` ; do
				VAR1=`echo ${DIRVAR} | cut -d" " -f${VAR}`
				VAR2=`echo ${VARS}   | cut -d" " -f${VAR}`
				VAR3=`echo ${NAME}   | cut -d" " -f${VAR}`
				wget --user=dhnbrasil --password=_Lv=qT4CVh86zjps0xSOhnJmN --no-check-certificate ${URL}/${VAR1}/${VAR3}_${AMD}${HH}_${PROG}_${VAR2}.grib2.bz2
				done
			done
		num_tentativas=$((num_tentativas+1))
        	sleep 60

		else
                flag=0
                echo "O dado icon13km_${HH}.grib2 esta completo! Bom trabalho"

		fi

	done

#FIM
