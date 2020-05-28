#!/bin/bash -xv
date
################################################################
# Script que realiza o Download da PMSL do Modelo Global ICON  #
# para confeccao da carta sinótica digital                     #
#                                                	       #
# Autora: CT(T) Alana em MAI2020                               #
################################################################

if [ $# -lt 1 ]
   then
   echo "+------------------Utilização-----------------------------+"
   echo " Script para realizar o download da PMSL do ICON 13 km     "
   echo "       ./get_PMSL_icon13.sh HH	                            "
   echo "   ex: ./get_PMSL_icon13.sh 00 	                    "
   echo "+---------------------------------------------------------+"
   exit
fi

HH=$1 #HORARIO DE SIMULAÇÃO 00Z OU 12Z
HSTART=0
HSTOP=12

# Carrega a data
AMD=`cat ~/datas/datacorrente${HH}`

# Carrega caminhos dos diretórios
DIRICON=/home/operador/grads/carta-digital
DIRICONdados=${DIRICON}/dados/dados${HH}

# Informações para interpolação da grade ICOSAHEDRAL para grade regular
# Download dos arquivos abaixo em https://opendata.dwd.de/weather/lib/cdo/
DIRICONfiles=${DIRICON}/files
TARGETICON=${DIRICONfiles}/target_grid_world_0125.txt
GRIDICON=${DIRICONfiles}/icon_grid_0026_R03B07_G.nc
WFILEICON=${DIRICONfiles}/weights_icogl2world_0125.nc


	echo "+----------------------------------------------------+"
	echo "+ Iniciando o Download do Dado da PMSL do ICON 13km  +" 
	echo "+----------------------------------------------------+"  
	date
# A programacao abaixo foi feita para que o diretorio "pmsl" fosse associado a variavel "PMSL"
DIRVAR="pmsl"
VARS="PMSL"
URL="https://data.dwd.de/opendata/weather/nwp/icon/grib/${HH}"
NAME="icon_global_icosahedral_single-level"

        echo "+----------------------------------------------------------------+"
        echo "+ Testando se os dados da PMSL já estão disponivel para download +"
        echo "+----------------------------------------------------------------+"
        date

	ni=0
	flag=1

while [ $flag -eq 1 ];do
	cd ${DIRICONdados}
        wget --user=dhnbrasil --password=_Lv=qT4CVh86zjps0xSOhnJmN --no-check-certificate ${URL}/pmsl/icon_global_icosahedral_single-level_${AMD}${HH}_000_PMSL.grib2.bz2
        ls icon_global_icosahedral_single-level_${AMD}${HH}_000_PMSL.grib2.bz2 | cut -c38-45 > dataana.txt
      
	if [ `cat dataana.txt` = ${AMD} ];then
                echo " OS DADOS DE PMSL JA ESTAO DISPONIVEIS, INICIANDO DOWNLOAD, FIQUE CALMO MILITAR "

	        cd $DIRICONdados
        	rm ${DIRICONdados}/icon* ${DIRICONdados}/dataana.txt

        	NVARS=`echo $VARS | wc -w`
        	echo "$NVARS"

        		for PROG in `seq -s " " -f "%03g" ${HSTART} 6 ${HSTOP}`;do
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
# FIM DO DOWNLOAD DO MODELO MAIS LINDO DO MUNDO!!!!!!!!
date
