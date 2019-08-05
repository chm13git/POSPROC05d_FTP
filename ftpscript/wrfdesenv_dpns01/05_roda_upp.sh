#!/bin/bash -x 
# 19JUL19 - Comentei o input_status.php pois estava provocando lentidao na rodada. Ass.: 1T(T) Neris.

ulimit -s unlimited
ulimit -v unlimited

/opt/intel/bin/compilervars.sh intel64

mpt=`cat $HOME/wrf/invariantes/mpt_versao | head -1`
. /usr/share/modules/init/bash
module load mpt/${mpt}
export PATH=$PATH:/data1/wrfdesenv/home/local/bin:.
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/data1/wrfdesenv/home/local/lib
mpi=/opt/sgi/mpt/mpt-${mpt}/bin/mpirun

# Verifica argumentos

if ! [ $# -eq 4 ];then

        echo
        echo " Entre com a area (metarea5, antartica, etc.), o horario de simulacao \
(00, 12), o prognostico (00, 03, 06, etc.) e o tempo de integracao (24, 48, 72, 96, etc.). "
        echo

        exit 10
fi

AREA=$1                                                         # AREA de simulacao. ex: metarea5, caribe, etc.
area=`echo $AREA | tr [A-Z] [a-z]`                              # Transforma maiusculas em minusculas.
AREA2=`echo $AREA | cut -c1-3 | tr [a-z] [A-Z]`
HSIM=$2                                                         # Define o horario de simulacao, 00 ou 12.
HPROG=$3							# Define o prognostico a partir do qual a simulacao comecara.
HSTOP=$4                                                        # Define o horario limite de integracao. ex: 24, 48, 72, etc.
HINT="03"							# Intervalo de incremento entre horarios de simulacao.
PENULT_PROG=`expr ${HSTOP} - ${HINT}`				# Calculo do penultimo horario
RODADA="Operacional"                                            # Trocado p/ Operacional (dia 31/08/2017) quando pagina status ok
curr_date0=`cat ~/datas/datacorrente${HSIM}`                     # Pega a data corrente no formato, ex: 20121121
curr_date=${curr_date0}${HSIM}                                   # Transforma o formato acima em,   ex: 2012112100
YYYY=`echo $curr_date | cut -c1-4`                              # Extrai o ano do formato acima,   ex: 2012
MM=`echo $curr_date | cut -c5-6`                                # Extrai o mes do formato acima,   ex: 11
DD=`echo $curr_date | cut -c7-8`                                # Extrai o dia do formato acima,   ex: 21
HH=`echo $curr_date | cut -c9-10`                               # Extrai a hora do formato acima,  ex: 00
YYYY_end=${YYYY}
MM_end=${MM}
DD_end=${DD}
HH_end=${HH}

YYrod=${YYYY}
MMrod=${MM}
DDrod=${DD}

dormir=60 							# numero de segundos para dormir.
HABORT=120                                                      # numero de ciclos para abortar a espera dos dados do GFS.

if [ ${area} == "antartica" ] || [ ${area} == "antarticap" ];then

        raiz="/data1/wrfdesenv/home/wrf"

elif  [ ${area} == "metarea5" ];then

        raiz="/data1/wrfdesenv/home/wrf"

else

        raiz="/data1/wrfdesenv/home/swrf"

fi

dir_scr="${HOME}/scripts"
wrf_out="wrfout_d0"						# modelo BASE do nome do dado de saida do WRF.
dir_simulacao="${raiz}/wrf_${area}"
dir_wrf_comp="${raiz}/WRFV3"
dir_produtos="${dir_simulacao}/produtos"
dir_dados="${dir_produtos}/dados_${HSIM}"
dir_gribs="${dir_produtos}/grib_${HSIM}"
dir_dat="${dir_produtos}/dat_${HSIM}"
dir_tmpl="${raiz}/templates"
dir_wrf="${dir_simulacao}/WRF"
dir_upp="${dir_simulacao}/UPP"
dir_arw="${dir_simulacao}/ARW"
upparg=`cat ${raiz}/invariantes/${area}/${area}_upparg | head -n 1`

if ! [ -d ${dir_simulacao} ];then

        echo
        echo "Esta AREA nao existe! Verifique no diretorio ${raiz}/invariantes "
	echo "o nome correto. Este nome tem que ser o mesmo dos arquivos presentes no "
	echo "diretorio, porem sem o TXT. Ex: arquivo metarea5.txt => AREA = metarea5 "
        echo
        exit 11

fi

####################################################################
#
# Carrega variaveis que serao utilizadas no UPP
#
####################################################################

cd ${dir_upp}/postprd

if [ ${area} == "antartica" ];then

	sed -e "s|RAIZ|${raiz}|g" ${dir_tmpl}/tmpl.run_unipost.antartica 	> temp1

else

	sed -e "s|RAIZ|${raiz}|g" ${dir_tmpl}/tmpl.run_unipost  > temp1

fi

sed -e "s|SIMU|${dir_upp}|g" temp1 				> temp2
sed -e "s|DIRWRF|${dir_wrf_comp}|g" temp2 			> temp1
sed -e "s|SETMPI|${mpi}|g" temp1 				> temp2
sed -e "s|UPPARGS|${upparg}|g" temp2	 			> ${dir_upp}/postprd/semi_template

#rm ${dir_upp}/postprd/temp1 ${dir_upp}/postprd/temp2

####################################################################
#
# Carrega variaveis que serao utilizadas no ARW
#
####################################################################

INT_SEC=`grep INT_SEC ${raiz}/invariantes/${area}.txt | cut -d" " -f2`

###################################################################

for HREF in `seq ${HPROG} ${HINT} ${HSTOP}`;do

	echo " | | | | | | | | | | | | | | | | | | | "
	echo " V V V V V V V V V V V V V V V V V V V "
	echo
	echo " Inicio do LOOP de ${HPROG} ate ${HSTOP}"

	# Ajusta os ZEROS a direita do HREF

        if [ ${HREF} -le 9 ];then

		HREF=0${HREF}

        else

		HREF=${HREF}

	fi

        # Ajuste no HREFalt para salvar os arquivos com PROG em 3 digitos

        DIG="0"

	if [ ${HREF} -le 99 ];then

		HREFalt=${DIG}${HREF}

	else

		HREFalt=${HREF}

	fi

	# Checar arquivos wrfout*** presentes

	# Calcula o horario ATUAL e carrega variaveis

	HREF_DATE=`${HOME}/local/bin/caldate ${curr_date} + ${HREF}h 'yyyymmddhh'`
	echo
	echo  " Horario inicial do processo eh ${HREF_DATE}"

	YYYYi=`echo ${HREF_DATE} | cut -c1-4`                              # Extrai o ano do formato acima,   ex: 2012
	MMi=`echo ${HREF_DATE} | cut -c5-6`                                # Extrai o mes do formato acima,   ex: 11
	DDi=`echo ${HREF_DATE} | cut -c7-8`                                # Extrai o dia do formato acima,   ex: 21
	HHi=`echo ${HREF_DATE} | cut -c9-10`                               # Extrai a hora do formato acima,  ex: 00

	YYYY_end=${YYYYi}
	MM_end=${MMi}
	DD_end=${DDi}
	HH_end=${HHi}

	arq_wrfout1=${wrf_out}1_${YYYYi}-${MMi}-${DDi}_${HHi}:00:00

	FLAG=1
	nt=1

	while [ ${FLAG} -eq 1 ];do

		if [ -e ${dir_dados}/${arq_wrfout1} ];then

			echo
			echo " Encontrei o arquivo ${dir_dados}/${arq_wrfout1} e vou processa-lo."
			echo

			# Substituindo variaveis no semi_template e
			# salvando tais substituicoes no run_unipost

			sed -e 's|HREF_DATE|'${curr_date}'|g' ${dir_upp}/postprd/semi_template > temp1
			sed s/HH.END/${HREF}/g  temp1 > temp2
			sed s/HH.INI/${HREF}/g  temp2 > temp1
			sed s/HINT/${HINT}/g temp1 > temp2
			sed -e 's|PRODUTOS|'${dir_dados}'|g' temp2 > ${dir_upp}/postprd/run_unipost

			rm ${dir_upp}/postprd/temp1 ${dir_upp}/postprd/temp2

			chmod u+x ${dir_upp}/postprd/run_unipost

			echo
			echo " rodando o UNIPOST "
		
			cd ${dir_upp}/postprd

			time ${dir_upp}/postprd/run_unipost
                        

			if [ ${area} == "antartica" ] || [ ${area} == "antarticap" ];then

				mv ${dir_upp}/postprd/wrfprs_d01.${HREF} ${dir_gribs}/wrf_${area}_${HSIM}_${curr_date0}${HREFalt}
                                erro=$?
				rm ${dir_upp}/postprd/WRFPRS_d01.${HREF}


			else
				mv ${dir_upp}/postprd/WRFPRS_d01.${HREF} ${dir_gribs}/wrf_${area}_${HSIM}_${curr_date0}${HREFalt}
				erro=$?
                                rm ${dir_upp}/postprd/wrfprs_d01.${HREF}



			fi

                        if [ $erro -eq 0 ]; then
                           
                           MSG="PROG ${HREFalt} do WRF${AREA2} ${DD}${MM}${YYYY} ${HSIM}Z PRONTO"
                           #/usr/bin/input_status.php WRF${AREA2} ${HSIM} ${RODADA} AMARELO "$MSG" 
                        fi 
			# Substituindo variaveis no tmpl_namelist.arw e
			# salvando tais substituicoes no namelist.arw

#			echo
#			echo " rodando o ARWpost "

#			cd ${dir_arw}

#	                sed s/YYYY.END/${YYYY_end}/g ${dir_tmpl}/tmpl.namelist.ARWpost 	> temp1
#	                sed s/MM.END/${MM_end}/g temp1 					> temp2
#	                sed s/DD.END/${DD_end}/g  temp2 				> temp1
#	                sed s/HH.END/${HH_end}/g  temp1 				> temp2
#			sed s/YYrod/${YYrod}/g temp2 					> temp3
#			sed s/MMrod/${MMrod}/g temp3 					> temp1
#			sed s/DDrod/${DDrod}/g temp1 					> temp2
#	                sed s/YYYY/${YYYYi}/g  temp2 					> temp1
#	                sed s/MM/${MMi}/g temp1 					> temp2
#	                sed s/DD/${DDi}/g temp2 					> temp1
#	                sed s/HH/${HHi}/g temp1 					> temp2
#			sed s/INT_SEC/${INT_SEC}/g temp2 				> temp1
#			sed -e 's|PRODUTOS|'${dir_dados}'|g' temp1 			> temp2
#			sed -e 's|DIRDAT|'${dir_dat}'|g' temp2 				> temp1
#			sed -e 's|DOMAIN|'${area}'|g' temp1 				> temp2
#			sed s/HSIM/${HSIM}/g temp2 					> temp1
#			sed s/HREF/${HREFalt}/g temp1 					> ${dir_arw}/namelist.ARWpost

#			${dir_arw}/ARWpost.exe

			FLAG=0		

		else

			nt=$((nt+1))

			if [ ${nt} == ${HABORT} ];then

				echo
				echo " Esperei por ${HABORT} Ciclos de ${dormir} segundos, mas o arquivo "
				echo " ${dir_dados}/${arq_wrfout1} nao chegou na pasta. Abortando o roda_real_wrf.sh."
				echo

					sleep 5 
                       			MSG="Falha no Processamento do WRF${AREA2} no horario ${HREF} de ${DD}${MM}${YYYY} ${HH}Z"
                   		 	#/usr/bin/input_status.php WRF${AREA2} ${HH} ${RODADA} VERMELHO "${MSG}"

				echo $date

				if [ ${area} == "antartica" ] && [ ${HREF} -le 72 ];then

        				${dir_scr}/05.3_extrai_grib_zygrib.sh antartica ${HSIM} 00 ${HREF} zoom
        				${dir_scr}/05.3_extrai_grib_zygrib.sh antartica ${HSIM} 00 ${HREF} drake

				elif [ ${area} == "antartica" ] && [ ${HREF} -gt 72 ];then

                                        ${dir_scr}/05.3_extrai_grib_zygrib.sh antartica ${HSIM} 00 72 zoom
                                        ${dir_scr}/05.3_extrai_grib_zygrib.sh antartica ${HSIM} 00 72 drake

				else

        				${dir_scr}/05.2_extrai_grib_gempak.sh metarea5  ${HSIM} 00 ${HREF}
					# ${dir_scr}/05.3_extrai_grib_zygrib.sh metarea5  ${HSIM} 00 ${HREF} missilex
        				${dir_scr}/05.4_extrai_grib_valida.sh metarea5  ${HSIM} 00 ${HREF}
				fi

				exit 11

			fi

			echo " Arquivo ${dir_dados}/${arq_wrfout1} nao existe. "

			echo " Esperando ${dormir} segundos "
			sleep ${dormir}
		
		fi
		
	done

nt=$((nt+1))

done

#BOM MOMENTO PARA COLOCAR O VERDE DE FINALIZACAO

if [ ${area} == "metarea5" ];then

	arq_gribver=wrf_metarea5_${HSIM}_${curr_date0}120

else	

	arq_gribver=wrf_antartica_${HSIM}_${curr_date0}096

fi	

if [ -e ${dir_gribs}/${arq_gribver} ];then

	echo " ${dir_gribs}/wrf_${area}_${HSIM}_${arq_gribver}"
	sleep 5
	MSG="Processamento do WRF${AREA2} ${DD}${MM}${YYYY} ${HH}Z encerrado"
	#/usr/bin/input_status.php WRF${AREA2} ${HH} ${RODADA} VERDE "${MSG}"

fi


# Script que extrai os dados de vento a 10 metros
# para inicializacao do WW3 apos o termino da rodada.

${dir_scr}/05.1_extrai_grib_vento.sh ${AREA} ${HSIM} 00 ${HSTOP}
${dir_scr}/05.3_extrai_grib_zygrib.sh metarea5 ${HSIM} 00 120 missilex

# Script que extrai os dados do WRF
# para visualizaç no GEMPAK
.
${dir_scr}/05.2_extrai_grib_gempak.sh ${AREA} ${HSIM} 00 ${HSTOP}

if [ ${area} == "antartica" ]; then 
	${dir_scr}/05.3_extrai_grib_zygrib.sh antartica ${HSIM} 00 72 zoom 
	${dir_scr}/05.3_extrai_grib_zygrib.sh antartica ${HSIM} 00 72 drake
fi
