#!/bin/bash -x

export WRF_EM_CORE=1
export WRF_NMM_CORE=0
export WRF_DA_CORE=0
export WRFIO_NCD_LARGE_FILE_SUPPORT=1

mpt=`cat $HOME/wrf/invariantes/mpt_versao | head -1`
ulimit -s unlimited
ulimit -v unlimited

source /opt/intel/bin/compilervars.sh intel64
. /usr/share/modules/init/bash
module load mpt/${mpt}

export NETCDF="/data1/wrfdesenv/home/local"
export WRFIO_NCD_LARGE_FILE_SUPPORT="1"

export PATH=$PATH:/data1/wrfdesenv/home/local/bin:.
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/data1/wrfdesenv/home/local/lib

mpi=/opt/sgi/mpt/mpt-${mpt}/bin/mpirun
dplace=/usr/bin/dplace
time=/usr/bin/time

# Verifica argumentos

if ! [ $# -eq 4 ]
then

        echo
        echo " Entre com a area (metarea5, antartica, etc.), o horario de simulacao \
(00, 12), o prognostico (00, 03, 06, etc.) e o tempo de integracao (24, 48, 72, 96, etc.). "
        echo

        exit 10
fi

AREA=$1                                                         # AREA de simulacao. ex: metarea5, caribe, etc.
area=`echo $AREA | tr [A-Z] [a-z]`                              # Transforma maiusculas em minusculas.
HSIM=$2                                                         # Define o horario de simulacao, 00 ou 12.
HPROG=$3							# Define o prognostico a partir do qual a simulacao comecara.
HSTOP=$4                                                        # Define o horario limite de integracao. ex: 24, 48, 72, etc.
HINT="03"							# Intervalo de incremento entre horarios de simulacao.
PENULT_PROG=`expr ${HSTOP} - ${HINT}`				# Calculo do penultimo horario

if [ ${PENULT_PROG} -le 9 ];then
        PENULT_PROG=0${PENULT_PROG}
else
        PENULT_PROG=${PENULT_PROG}
fi

curr_date=`cat ~/datas/datacorrente${HSIM}`                     # Pega a data corrente no formato, ex: 20121121
curr_date=${curr_date}${HSIM}                                   # Transforma o formato acima em,   ex: 2012112100
YYYY=`echo $curr_date | cut -c1-4`                              # Extrai o ano do formato acima,   ex: 2012
MM=`echo $curr_date | cut -c5-6`                                # Extrai o mes do formato acima,   ex: 11
DD=`echo $curr_date | cut -c7-8`                                # Extrai o dia do formato acima,   ex: 21
HH=`echo $curr_date | cut -c9-10`                               # Extrai a hora do formato acima,  ex: 00
YYYY_end=${YYYY}
MM_end=${MM}
DD_end=${DD}
HH_end=${HH}

dormir=60							# numero de segundos para dormir.
HABORT=500                                                      # numero de ciclos para abortar a espera dos dados do GFS.

if [ ${area} == "antartica" ] || [ ${area} == "antarticap" ];then

        raiz="/data1/wrfdesenv/home/wrf"

elif  [ ${area} == "metarea5" ];then

        raiz="/data1/wrfdesenv/home/wrf"

else

        raiz="/data1/wrfdesenv/home/swrf"

fi

dir_inv="${raiz}/invariantes"
dir_scr="${raiz}/scripts"
arq="met_em.d0"							# modelo BASE do nome do dado do metgrid. ex: met_em.d01.2012-11-24_03:00:00.nc
wrf_out="wrfout_d0"						# modelo BASE do nome do dado de saida do WRF.
dir_gfs="${raiz}/DATA"						# diretorio onde os dados do GFS chegam. 
dir_simulacao="${raiz}/wrf_${area}"
dir_produtos="${dir_simulacao}/produtos/dados_${HSIM}"
dir_tmpl="${raiz}/templates"
dir_wrf="${dir_simulacao}/WRF"
dir_wps="${dir_simulacao}/WPS"
dir_temp="${dir_simulacao}/temporarios/dados_${HSIM}"

# Verifica se a maquina eh de memoria
# DISTRIBUIDA ou COMPARTILHADA atraves do IP

#maquina=`/sbin/ifconfig | grep 10.13.100.1 | head -n 1 | awk ' { print $2 } ' | cut -d":" -f2`
#maquina=`/sbin/ifconfig | grep 10.13.100.1 | head -n 1 | awk ' { print $3 } '`
maquina=`hostname`

if [ ${maquina} == "dpns01" ]
then

        echo
        echo " Maquina de memoria COMPARTILHADA."
        MAQUINA="COMPARTILHADA"
        export MPI_GROUP_MAX=1024
        export MPI_BUFS_PER_PROC=1024
        export MPI_BUFS_PER_HOST=1024
        export MPI_DSM_DISTRIBUTE=1

else

        echo
        echo " Maquina de memoria DISTRIBUIDA."
        MAQUINA="DISTRIBUIDA"

        # A linha abaixo serve pois sem ela
        # o WRF nao roda na ICE para resolucao
        # maior que 20 km.
        # Eu tentei 1000 mas ainda n funcionou
        # Dai eu tentei 10000 e o WPS rodou.
        export MPI_GROUP_MAX=1024
        export MPI_BUFS_PER_PROC=1024
        export MPI_BUFS_PER_HOST=1024
	export MPI_DSM_DISTRIBUTE=1
fi

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
# Carrega variaveis que serao utilizadas no WRF (namelist.input.baixo)
#
####################################################################

HIS_INT=`grep HIS_INT ${raiz}/invariantes/${area}.txt 		| cut -d" " -f2`
FRAMES=`grep FRAMES ${raiz}/invariantes/${area}.txt 		| cut -d" " -f2`
TPASSO=`grep TPASSO ${raiz}/invariantes/${area}.txt 		| cut -d" " -f2`
ADAPT_TS=`grep ADAPT_TS ${raiz}/invariantes/${area}.txt         | cut -d" " -f2`
MAX_TS=`grep MAX_TS ${raiz}/invariantes/${area}.txt             | cut -d" " -f2`
MIN_TS=`grep MIN_TS ${raiz}/invariantes/${area}.txt             | cut -d" " -f2`
INT_SEC=`grep INT_SEC ${raiz}/invariantes/${area}.txt 		| cut -d" " -f2` 	# Aplicado no namelist.input.cima
NDOMAIN=`grep MAX_DOM ${raiz}/invariantes/${area}.txt 		| cut -d" " -f2`
E_WE1=`grep E_WE1 ${raiz}/invariantes/${area}.txt 		| cut -d" " -f2`
E_SN1=`grep E_SN1 ${raiz}/invariantes/${area}.txt 		| cut -d" " -f2`
E_WE2=`grep E_WE2 ${raiz}/invariantes/${area}.txt 		| cut -d" " -f2` 	# So usado se houver aninhamento (ainda nao pronto)
E_SN2=`grep E_SN2 ${raiz}/invariantes/${area}.txt 		| cut -d" " -f2` 	# So usado se houver aninhamento (ainda nao pronto)
EVERT=`grep EVERT ${raiz}/invariantes/${area}.txt 		| cut -d" " -f2`
NSOILEVEL=`grep NSOILEVEL ${raiz}/invariantes/${area}.txt 	| cut -d" " -f2`
MAP_PROJ=`grep MAP_PROJ ${raiz}/invariantes/${area}.txt 	| cut -d" " -f2`

# Se MAP_PROJ for lat-lon, o WRF precisa tirar a resolucao dos
# arquivos geo_em.d0*. Caso seja lambert ou mercator, pega a
# resolucao do arquivo dentro do diretorio invariantes

	if ! [ ${MAP_PROJ} == "lat-lon" ];then

	DX_1=`grep DX_1 ${raiz}/invariantes/${area}.txt 	| cut -d" " -f2`
        DX_2=`grep DX_2 ${raiz}/invariantes/${area}.txt 	| cut -d" " -f2`
	DY_1=`grep DY_1 ${raiz}/invariantes/${area}.txt 	| cut -d" " -f2`
        DY_2=`grep DY_2 ${raiz}/invariantes/${area}.txt 	| cut -d" " -f2`

	else

	cd ${dir_wps}

	DX_1=`ncdump -h geo_em.d01.nc | grep ":DX " | cut -d" " -f3 | cut -d"f" -f1`
	DY_1=`ncdump -h geo_em.d01.nc | grep ":DY " | cut -d" " -f3 | cut -d"f" -f1`

		if [ -e geo_em.d02.nc ];then

		DX_2=`ncdump -h geo_em.d02.nc | grep ":DX " | cut -d" " -f3 | cut -d"f" -f1`
	        DY_2=`ncdump -h geo_em.d02.nc | grep ":DY " | cut -d" " -f3 | cut -d"f" -f1`

		else

		DX_2=`grep DX_2 ${raiz}/invariantes/${area}.txt | cut -d" " -f2`
		DY_2=`grep DY_2 ${raiz}/invariantes/${area}.txt | cut -d" " -f2`

		fi
	fi

MPPHY1=`grep MPPHY1 ${raiz}/invariantes/${area}.txt 	| cut -d" " -f2`
ROL1=`grep ROL1 ${raiz}/invariantes/${area}.txt 	| cut -d" " -f2`
ROC1=`grep ROC1 ${raiz}/invariantes/${area}.txt 	| cut -d" " -f2`
PRAD1=`grep PRAD1 ${raiz}/invariantes/${area}.txt 	| cut -d" " -f2`
PSOLO1=`grep PSOLO1 ${raiz}/invariantes/${area}.txt 	| cut -d" " -f2`
PSUP1=`grep PSUP1 ${raiz}/invariantes/${area}.txt 	| cut -d" " -f2`
CLIM1=`grep CLIM1 ${raiz}/invariantes/${area}.txt 	| cut -d" " -f2`
CUMU1=`grep CUMU1 ${raiz}/invariantes/${area}.txt 	| cut -d" " -f2`
NCASOL=`grep NCASOL ${raiz}/invariantes/${area}.txt 	| cut -d" " -f2`

MPPHY2=`grep MPPHY2 ${raiz}/invariantes/${area}.txt 	| cut -d" " -f2`
ROL2=`grep ROL2 ${raiz}/invariantes/${area}.txt 	| cut -d" " -f2`
ROC2=`grep ROC2 ${raiz}/invariantes/${area}.txt 	| cut -d" " -f2`
PRAD2=`grep PRAD2 ${raiz}/invariantes/${area}.txt 	| cut -d" " -f2`
PSOLO2=`grep PSOLO2 ${raiz}/invariantes/${area}.txt 	| cut -d" " -f2`
PSUP2=`grep PSUP2 ${raiz}/invariantes/${area}.txt 	| cut -d" " -f2`
CLIM2=`grep CLIM2 ${raiz}/invariantes/${area}.txt 	| cut -d" " -f2`
CUMU2=`grep CUMU2 ${raiz}/invariantes/${area}.txt 	| cut -d" " -f2`
NCASOL=`grep NCASOL ${raiz}/invariantes/${area}.txt 	| cut -d" " -f2`
NLANDCAT=`grep NLANDCAT ${raiz}/invariantes/${area}.txt     | cut -d" " -f2`

cd ${dir_wrf}

sed s/TPASSO/${TPASSO}/g ${dir_tmpl}/tmpl.namelist.input.baixo 	> temp1
sed s/ADAPT_TS/${ADAPT_TS}/g temp1 				> temp2
sed s/MAX_TS/${MAX_TS}/g temp2 					> temp1
sed s/MIN_TS/${MIN_TS}/g temp1 					> temp2
sed s/MAX_DOM/${NDOMAIN}/g temp2 				> temp1
sed s/E_WE1/${E_WE1}/g temp1 					> temp2
sed s/E_SN1/${E_SN1}/g temp2 					> temp1
sed s/E_WE2/${E_WE2}/g temp1 					> temp2
sed s/E_SN2/${E_SN2}/g temp2 					> temp1
sed s/EVERT/${EVERT}/g temp1 					> temp2
sed s/NSOILEVEL/${NSOILEVEL}/g temp2 				> temp1
sed s/DX_1/${DX_1}/g temp1 					> temp2
sed s/DY_1/${DY_1}/g temp2 					> temp1
sed s/DX_2/${DX_2}/g temp1 					> temp2
sed s/DY_2/${DY_2}/g temp2 					> temp1
sed s/MPPHY1/${MPPHY1}/g temp1 					> temp2
sed s/MPPHY2/${MPPHY2}/g temp2 					> temp1
sed s/ROL1/${ROL1}/g temp1 					> temp2
sed s/ROL2/${ROL2}/g temp2 					> temp1
sed s/ROC1/${ROC1}/g temp1 					> temp2
sed s/ROC2/${ROC2}/g temp2 					> temp1
sed s/PRAD1/${PRAD1}/g temp1 					> temp2
sed s/PRAD2/${PRAD2}/g temp2 					> temp1
sed s/PSOLO1/${PSOLO1}/g temp1 					> temp2
sed s/PSOLO2/${PSOLO2}/g temp2 					> temp1
sed s/PSUP1/${PSUP1}/g temp1 					> temp2
sed s/PSUP2/${PSUP2}/g temp2 					> temp1
sed s/CLIM1/${CLIM1}/g temp1 					> temp2
sed s/CLIM2/${CLIM2}/g temp2 					> temp1
sed s/CUMU1/${CUMU1}/g temp1 					> temp2
sed s/CUMU2/${CUMU2}/g temp2 					> temp1
sed s/NCASOL/${NCASOL}/g temp1 					> temp2
sed s/NLANDCAT/${NLANDCAT}/g temp2                              > namelist.input.baixo

rm temp1 temp2

###################################################################

# Calcula o ultimo arquivo para utilizar de comparacao
# no final do script

ULT_PROG=`${HOME}/local/bin/caldate ${curr_date} + ${HSTOP}h 'yyyymmddhh'`

        YYYY_ULT=`echo ${ULT_PROG} | cut -c1-4`                              # Extrai o ano do formato acima,   ex: 2012
        MM_ULT=`echo ${ULT_PROG} | cut -c5-6`                                # Extrai o mes do formato acima,   ex: 11
        DD_ULT=`echo ${ULT_PROG} | cut -c7-8`                                # Extrai o dia do formato acima,   ex: 21
        HH_ULT=`echo ${ULT_PROG} | cut -c9-10`                               # Extrai a hora do formato acima,  ex: 00

ARQ_FIM=${arq}1.${YYYY_ULT}-${MM_ULT}-${DD_ULT}_${HH_ULT}:00:00.nc

nt=1

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

	# Ajusta o Flag de RESTART da rodada.

	if [ ${HREF} -eq 00 ];then
		RESTFLAG=".false."

		# Limpa cache para o proximo horario
		ssh root@10.13.100.31 'bash -s' < /data1/wrfdesenv/home/scripts/04.2_limpa_cache.sh

	else
		RESTFLAG=".true."
	fi

	# Checar arquivos met_em.d01???.nc presentes

	cd ${dir_wrf}

	# Calcula o horario ATUAL e carrega variaveis

	HREF_DATE=`${HOME}/local/bin/caldate ${curr_date} + ${HREF}h 'yyyymmddhh'`
	echo
	echo  " Horario inicial do processo eh ${HREF_DATE}"

	YYYY=`echo ${HREF_DATE} | cut -c1-4`                              # Extrai o ano do formato acima,   ex: 2012
	MM=`echo ${HREF_DATE} | cut -c5-6`                                # Extrai o mes do formato acima,   ex: 11
	DD=`echo ${HREF_DATE} | cut -c7-8`                                # Extrai o dia do formato acima,   ex: 21
	HH=`echo ${HREF_DATE} | cut -c9-10`                               # Extrai a hora do formato acima,  ex: 00

	# Calcula horario SEGUINTE e carrega variaveis

	NEXT_PROG=`${HOME}/local/bin/caldate ${HREF_DATE} + ${HINT}h 'yyyymmddhh'`
	echo " Horario final do processo eh   ${NEXT_PROG}"
	echo

	YYYY_end=`echo ${NEXT_PROG} | cut -c1-4`                          # Extrai o ano do formato acima,   ex: 2012
        MM_end=`echo ${NEXT_PROG} | cut -c5-6`                            # Extrai o mes do formato acima,   ex: 11
        DD_end=`echo ${NEXT_PROG} | cut -c7-8`                            # Extrai o dia do formato acima,   ex: 21
        HH_end=`echo ${NEXT_PROG} | cut -c9-10`                           # Extrai a hora do formato acima,  ex: 00

	arq_met1=${arq}1.${YYYY}-${MM}-${DD}_${HH}:00:00.nc
	arq_met2=${arq}1.${YYYY_end}-${MM_end}-${DD_end}_${HH_end}:00:00.nc

	arq_met1_nocomma=${arq}1.${YYYY}-${MM}-${DD}_${HH}_00_00.nc
	arq_met2_nocomma=${arq}1.${YYYY_end}-${MM_end}-${DD_end}_${HH_end}_00_00.nc

	FLAG=1

	while [ ${FLAG} -eq 1 ];do

		if [ -e ${dir_temp}/${arq_met1} ] && [ -e ${dir_temp}/${arq_met2} ];then

			ln -sf ${dir_temp}/${arq_met1} ./${arq_met1}
#			ln -sf ${dir_temp}/${arq_met1} ./${arq_met1_nocomma}
			ln -sf ${dir_temp}/${arq_met2} ./${arq_met2}
#			ln -sf ${dir_temp}/${arq_met2} ./${arq_met2_nocomma}

			# Substituindo variaveis no tmpl_namelist.input.cima e
			# salvando tais substituicoes no namelist.input.cima

			sed s/YYYY.END/${YYYY_end}/g ${dir_tmpl}/tmpl.namelist.input.cima > temp1
			sed s/MM.END/${MM_end}/g temp1 > temp2
			sed s/DD.END/${DD_end}/g  temp2 > temp1
			sed s/HH.END/${HH_end}/g  temp1 > temp2
			sed s/YYYY/${YYYY}/g  temp2 > temp1
			sed s/MM/${MM}/g  temp1 > temp2
			sed s/DD/${DD}/g  temp2 > temp1
			sed s/HH/${HH}/g  temp1 > temp2
			sed s/HSTOP/${HINT}/g temp2 > temp1
			sed s/HIS_INT/${HIS_INT}/g temp1 > temp2
			sed s/FRAMES/${FRAMES}/g temp2 > temp1
			sed s/RESTFLAG/${RESTFLAG}/g temp1 > temp2
			sed s/INT_SEC2/${INT_SEC}/g temp2 > namelist.input.cima

			# Aglutina as duas partes do namelist.input

			mv namelist.input.cima namelist.input
			cat namelist.input.baixo >> namelist.input

			# Passa a lista de pontos de METEOGRAMAS se houver.

			if [ -e ${dir_inv}/${area}/${area}_tslist ];then

				echo
				echo " Existe arquivo tslist para esta area,"
				echo " Vou linka-lo pra o diretorio de trabalho."
				echo

	        		ln -sf ${dir_inv}/${area}/${area}_tslist ${dir_wrf}/tslist

			fi

			# Executa REAL e WRF avaliando se a maquina eh
			# de memoria DISTRIBUIDA OU COMPARTILHADA.

			if [ ${MAQUINA} == "COMPARTILHADA" ];then

				echo
				echo " Rodando o REAL em memoria COMPARTILHADA."
				echo

                		# Carrega os parametros do DPLACE

                		N_REA_PROC=`grep REA_PROC ${raiz}/invariantes/${area}.txt | awk ' { print $2 } '`
                		REA_PROC=`grep REA_PROC ${raiz}/invariantes/${area}.txt | awk ' { print $3 } '` 

				echo
				echo " time $mpi -np ${N_REA_PROC} ${dplace} -c ${REA_PROC} ./real.exe 2> /dev/null" 

				${time} $mpi -np ${N_REA_PROC} ${dplace} -c ${REA_PROC} ./real.exe 2> /dev/null

			else


				echo
				echo " Rodando o REAL em memoria DISTRIBUIDA."
				echo

				dm_realarg=`cat ${raiz}/invariantes/${area}/${area}_realarg`

				echo " $mpi ${dm_realarg} ./real.exe 2> /dev/null"

				$mpi ${dm_realarg} ./real.exe

			fi

			mv rsl.error.* rsl.out.* ./real_out

                        if [ ${MAQUINA} == "COMPARTILHADA" ];then

                                echo
                                echo " Rodando o WRF em memoria COMPARTILHADA."
                                echo

		                # Carrega os parametros do DPLACE

                		N_WRF_PROC=`grep WRF_PROC ${raiz}/invariantes/${area}.txt | awk ' { print $2 } '`
                		WRF_PROC=`grep WRF_PROC ${raiz}/invariantes/${area}.txt | awk ' { print $3 } '`

				echo
				echo " time $mpi -np ${N_WRF_PROC} ${dplace} -c ${WRF_PROC} ./wrf.exe 2> /dev/null"

				${time} $mpi -np ${N_WRF_PROC} ${dplace} -c ${WRF_PROC} ./wrf.exe 2> /dev/null

			else

                                echo
                                echo " Rodando o WRF em memoria DISTRIBUIDA."
                                echo

				dm_wrfarg=`cat ${raiz}/invariantes/${area}/${area}_wrfarg`

				echo "$mpi ${dm_wrfarg} ./wrf.exe 2> /dev/null"

				$mpi ${dm_wrfarg} ./wrf.exe

# BOM MOMENTO VERIFICACAO QUE ESTA NO PAPEL
				# Limpa cache para o proximo horario

				ssh root@10.13.100.31 'bash -s' < /data1/wrfdesenv/home/scripts/04.2_limpa_cache.sh
			fi

			mv rsl.error.* rsl.out.* ./wrf_out

			# Carrega o nome dos arquivos base para confeccao de meteogramas 
			# colocando o horario no nome dos mesmos e transferindo-os para dir_met

                        if [ -e ${dir_inv}/${area}/${area}_tslist ];then

	                        echo
	                        echo " Existe arquivo tslist para esta area,"
	                        echo " Vou linka-lo pra o diretorio de trabalho."
	                        echo

				${dir_scr}/04.1_meteogramas.sh ${AREA} ${HSIM} ${HREF} >> ${dir_simulacao}/log/04.1_${HH}Z.log

			fi

			if [ -f ${dir_wrf}/${wrf_out}1_${YYYY_end}-${MM_end}-${DD_end}_${HH_end}:00:00 ];then

				if [ ${HREF} == 00 ];then

					# Copia arquivo de analise.

					echo
					echo " Movendo ${wrf_out}1_${YYYY}-${MM}-${DD}_${HH}:00:00 para ${dir_produtos}"
					mv ${wrf_out}1_${YYYY}-${MM}-${DD}_${HH}:00:00 ${dir_produtos}

					# Copia arquivo de prognostico
					echo
					echo " Movendo ${wrf_out}1_${YYYY_end}-${MM_end}-${DD_end}_${HH_end}:00:00 para ${dir_produtos}"
					mv ${wrf_out}1_${YYYY_end}-${MM_end}-${DD_end}_${HH_end}:00:00 ${dir_produtos}

				else

					# Copia arquivo de prognostico

					echo
					echo " Movendo de ${wrf_out}1_${YYYY_end}-${MM_end}-${DD_end}_${HH_end}:00:00 para ${dir_produtos}"
					echo
					mv ${wrf_out}1_${YYYY_end}-${MM_end}-${DD_end}_${HH_end}:00:00 ${dir_produtos}

				fi

			else

				ult_rst=`ls -ltr wrfrst* | tail -1 | awk ' { print $9 } '`

				echo
				echo " O arquivo ${wrf_out}1_${YYYY_end}-${MM_end}-${DD_end}_${HH_end}:00:00 NAO foi criado."
				echo " O ultimo arquivo de restart eh ${ult_rst}  referente ao horario ${HREF}. "
				echo
				echo " Vou matar o EXCELSO, MAGNANIMO, IMACULADO WRF!!"

				exit 99

			fi

			FLAG=0		

		else

			nt=$((nt+1))

			if [ ${nt} == ${HABORT} ];then

				echo " Esperei por ${HABORT} Ciclos de ${dormir} segundos, mas o arquivo "
				echo " ${arq_met2} nao chegou na pasta. Abortando o roda_real_wrf.sh."

				exit 11

			fi

			echo " Arquivo ${arq_met1} nao existe. "
			echo " Esperando ${dormir} segundos "

			sleep ${dormir}
		
		fi

		if [ ${HREF} == ${PENULT_PROG} ];then

			if [ -f ${dir_produtos}/${wrf_out}1_${YYYY_end}-${MM_end}-${DD_end}_${HH_end}:00:00 ];then

				rm temp* met_em.d0* wrfinput_d01 wrfbdy_d01 namelist.input.baixo namelist.output wrfrst_d01_* wrfoutReady_d01*

				echo " Chegou no final do processo do penultimo horario que eh ${PENULT_PROG} "
				echo " Vou dar EXIT pois nao ha mais 2 forcantes para o proximo horario."
				echo " A rodada terminou corretamente! "
				echo

				exit 1000

			elif ! [ -f ${dir_produtos}/${wrf_out}1_${YYYY_end}-${MM_end}-${DD_end}_${HH_end}:00:00 ] && [ ${nt} >= ${HABORT} ];then

				echo " Chegou no final do processo do penultimo horario que eh ${PENULT_PROG} "
				echo " Mas nao encontrou o arquivo ${dir_produtos}/${ARQ_FIM} "
				echo " Alguma coisa deu errado com o MAGNANIMO WRF! "
				echo " ABORTANDO! "

				exit 2000

			else

				echo
				echo " O arquivo ${wrf_out}1_${YYYY_end}-${MM_end}-${DD_end}_${HH_end}:00:00 ainda nao esta pronto, vou aguardar."

				sleep ${dormir}

			fi

		fi

#		nt=$((nt+1))

	done

done
