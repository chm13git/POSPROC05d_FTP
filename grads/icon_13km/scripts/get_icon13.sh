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
#HSTOP=1

# Carrega a data
AMD=`cat ~/datas/datacorrente${HH}`

# Carrega CDO
source ~/.bashrc

# Carrega caminhos dos diretórios
DIRICON=/home/operador/grads/icon_13km
DIRICONdados=${DIRICON}/dados/dados${HH}
WORKDIRICON=${DIRICONdados}/work

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

DIRVAR="u u u v v v u_10m v_10m t_2m td_2m fi fi fi pmsl snow_gsp snow_con rain_gsp rain_con"
VARS="850_U 500_U 250_U 850_V 500_V 250_V U_10M V_10M T_2M TD_2M 1000_FI 850_FI 500_FI PMSL SNOW_GSP SNOW_CON RAIN_GSP RAIN_CON"
URL="https://data.dwd.de/opendata/weather/nwp/icon/grib/${HH}"
NAME1="icon_global_icosahedral_single-level"
NAME2="icon_global_icosahedral_pressure-level"
NAME3="icon_global_icosahedral_model-level"
NAME="$NAME2 $NAME2 $NAME2 $NAME2 $NAME2 $NAME2 $NAME1 $NAME1 $NAME1 $NAME1 $NAME2 $NAME2 $NAME2 $NAME1 $NAME1 $NAME1 $NAME1 $NAME1 $NAME3 $NAME3"

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
	
	/bin/bunzip2 ${DIRICONdados}/*.bz2

	echo ""

	############################################
	######## CHECAGEM DO DOWNLOAD
	###########################################	
	
#	Nvar=`/usr/local/bin/wgrib2 ${DIRICONdados}/icon13_${PROG}.grib2 | wc -l`	
#	Flag=0
#	Nref=16
#	
#	if [ ${Nvar} -lt ${Nref} ];then
#        
#	Flag=1 
#	nt=0   		#### Numero de Tentativas 
#	Abort=300	#### Numero de Tentativas em minutos ate abortar
#
#		while [ "${Flag}" = "1" ] || [${Abort} -gt ${nt}]; do
#        	
#			for PROG in `seq -s " " -f "%03g" ${HSTART} 1 ${HSTOP}`;do
#		      		for VAR in `seq 1 ${NVARS}` ; do
#					VAR1=`echo ${DIRVAR} | cut -d" " -f${VAR}`
#					VAR2=`echo ${VARS}   | cut -d" " -f${VAR}`
#					VAR3=`echo ${NAME}   | cut -d" " -f${VAR}`
#
#        				wget --user=dhnbrasil --password=_Lv=qT4CVh86zjps0xSOhnJmN ${URL}/${VAR1}/${VAR3}_${AMD}${HH}_${PROG}_${VAR2}.grib2.bz2
#        		done
#		done
#
#             		nt=$((nt+1))
#        	done       
#	else
#		echo " "
#		echo "Dado icon13_${HH}.grib2 OK"
#		echo " "
#      	fi
      	#########################################
	##### Termina a Checagem do download 
	#########################################

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
	#/usr/local/bin/cdo -f grb2 remap,${TARGETICON},${WFILEICON} ${in_file} ${out_file}
	/usr/bin/cdo -f grb2 remap,${TARGETICON},${WFILEICON} ${in_file} ${out_file}

done
for VAR in $VARS; do
/usr/bin/cdo mergetime ${DIRICONdados}/*${VAR}*_regulargrid.grib2  ${DIRICONdados}/icon13km_${VAR}_${HH}.grib2
done

#/usr/bin/cdo merge ${DIRICONdados}/icon13km*.grib2  ${DIRICONdados}/icon13km_${HH}.grib2
#FIM
