#!/bin/bash -x

if [ $# -ne 3 ];then

	echo "Entre com  area (metarea5, antartica e met510km) e o horario de referencia (00 ou 12) e o prognostico (24, 48, 72, ...) !!!"
	exit 12

fi

AREA=$1
HH=$2
prog=$3

deltat=`echo "( $prog + 0 )" | bc`
datacorrente=`cat /home/operador/datas/datacorrente$HH`
#datacorrente="20141125"
dataanalise=`/usr/bin/caldate $datacorrente$HH + 000h 'hhZddmmmyyyy(sd)'`
dataprev=`/usr/bin/caldate $datacorrente$HH + ${deltat}h 'hhZddmmmyyyy(sd)'`
meses="JAN;FEV;MAR;ABR;MAI;JUN;JUL;AGO;SET;OUT;NOV;DEZ"
months="Jan;Feb;Mar;Apr;May;Jun;Jul;Ago;Sep;Oct;Nov;Dec"
dias="Dom;Seg;Ter;Qua;Qui;Sex;Sab"
diasp="Domingo;Segunda-feira;Terca-feira;Quarta-feira;Quinta-feira;Sexta-feira;Sabado"

for j in `seq 1 7`
do

	dia=`echo $dias | cut -f$j -d";"`
	day=`echo $diasp | cut -f$j -d";"`
	dataraw=`echo $dataanalise | sed -e 's/'$day'/'$dia'/'`
	dataanalise=$dataraw
	dataraw=`echo $dataprev | sed -e 's/'$day'/'$dia'/'`
	dataprev=$dataraw

done

for j in `seq 1 12`
do

	mes=`echo $meses | cut -f$j -d";"`
	month=`echo $months | cut -f$j -d";"`
	dataraw=`echo $dataanalise | sed -e 's/'$month'/'$mes'/'`
	dataanalise=$dataraw
	dataraw=`echo $dataprev | sed -e 's/'$month'/'$mes'/'`
	dataprev=$dataraw

done

if [ $AREA == "cptec" ];then

	CABECALHO="Modelo WRF/CPTEC"

elif [ $AREA == "met510km" ];then

	CABECALHO="Modelo WRF10KM/CHM"

else
	CABECALHO="Modelo WRF/CHM"

fi

cd /home/operador/grads/wrf/wrf_${AREA}/gs

for arq in `cat /home/operador/grads/wrf/wrf_${AREA}/invariantes/lista`
do

	rm -f raw.gs
	echo "'reinit'" > raw.gs
	echo str=\"$str\" >> raw.gs
	cat $arq > temp1

	prefixgs=`echo ${arq} | cut -c1-3`

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

               if [ ${arq} == "sse_precneb.gs" ];then

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

                # Este IF serve para escolher a figura correta para fazer o composite

		if [ ${arq} == "nne_precneb.gs" ];then

			FIGPNG="fundoverde_nne.png"

		else

			FIGPNG="fundo2_nne.png"

		fi

                # Este IF verifica se a area tem o arquivo GRADE.
                # Caso afirmativo, copia seu conteudo para o arquivo temp1

		if [ -s /home/operador/grads/wrf/wrf_${AREA}/invariantes/gradnne ];then

			cat /home/operador/grads/wrf/wrf_${AREA}/invariantes/gradnne >> temp1

		fi

        # Este Terceiro IF serve para trabalhar o ZOOM da METAREA5
        # que tem o foco somente na do Paraguai.
        # Ele procura o termo PRY no inicio dos arquivos CTL dentro 
        # do diretorio GS da METAREA5 e configura caminhos 
        # especificos para realizar o pos processamento PRY.

        elif [ $prefixgs == "pry" ];then

                DIRARQGIF="/home/operador/grads/gif/wrf_pry_$HH"
                DIRCOMGIF="/home/operador/ftp_comissoes/gif/wrf_pry_$HH"
                DIRINVPNG="/home/operador/grads/wrf/wrf_${AREA}/invariantes"
                DIMLAT=`cat ~/grads/wrf/wrf_${AREA}/invariantes/dims_pry | head -1`
                DIMLON=`cat ~/grads/wrf/wrf_${AREA}/invariantes/dims_pry | tail -1`

                # Este IF serve para escolher a figura correta para fazer o composite

                if [ ${arq} == "pry_nebulos_internet2.gs" ];then

                        FIGPNG="fundoverde_pry.png"

                else

                        FIGPNG="fundo2_pry.png"

                fi

                # Este IF verifica se a area tem o arquivo GRADE.
                # Caso afirmativo, copia seu conteudo para o arquivo temp1

                if [ -s /home/operador/grads/wrf/wrf_${AREA}/invariantes/gradpry ];then

                        cat /home/operador/grads/wrf/wrf_${AREA}/invariantes/gradpry >> temp1

                fi

        # Este Quinto IF serve para trabalhar o ZOOM da ANTARTICA
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

		# Este IF serve para escolher a figura correta para fazer o composite

		if [ ${arq} == "drk_neve.gs" ] || [ ${arq} == "drk_nevoeiro.gs" ] || [ ${arq} == "drk_precneb.gs" ];then

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

	cat temp1 | sed -e 's|ARQUIVOCTL|/home/operador/grads/wrf/wrf_'$AREA'/ctl/ctl'$HH'/wrf'_${AREA}_${HH}'|g' 	> temp2

	if [ $prefixgs == "sse" ];then

		cat temp2 | sed -e 's|DIMLAT|'"${DIMLAT}"'|g' 								> temp1
		cat temp1 | sed -e 's|DIMLON|'"${DIMLON}"'|g'                                                          	> temp2
		cat temp2 | sed -e 's|DIRINVPNG|/home/operador/grads/wrf/wrf_'$AREA'/invariantes|g'			> temp1
		cat temp1 | sed -e 's|FIGSSEPNG|'${FIGPNG}'|g'                                                          > temp2

	fi

	 if [ $prefixgs == "nne" ];then

                cat temp2 | sed -e 's|DIMLAT|'"${DIMLAT}"'|g'                                                           > temp1
                cat temp1 | sed -e 's|DIMLON|'"${DIMLON}"'|g'                                                           > temp2
                cat temp2 | sed -e 's|DIRINVPNG|/home/operador/grads/wrf/wrf_'$AREA'/invariantes|g'                     > temp1
                cat temp1 | sed -e 's|FIGNNEPNG|'${FIGPNG}'|g'                                                          > temp2

        fi

         if [ $prefixgs == "pry" ];then

                cat temp2 | sed -e 's|DIMLAT|'"${DIMLAT}"'|g'                                                           > temp1
                cat temp1 | sed -e 's|DIMLON|'"${DIMLON}"'|g'                                                           > temp2
                cat temp2 | sed -e 's|DIRINVPNG|/home/operador/grads/wrf/wrf_'$AREA'/invariantes|g'                     > temp1
                cat temp1 | sed -e 's|FIGPRYPNG|'${FIGPNG}'|g'                                                          > temp2

        fi

        if [ $prefixgs == "drk" ];then

                cat temp2 | sed -e 's|DIMLAT|'"${DIMLAT}"'|g'                                                           > temp1
                cat temp1 | sed -e 's|DIMLON|'"${DIMLON}"'|g'                                                           > temp2
                cat temp2 | sed -e 's|DIRINVPNG|/home/operador/grads/wrf/wrf_'$AREA'/invariantes|g'                     > temp1
                cat temp1 | sed -e 's|FIGDRKPNG|'${FIGPNG}'|g'                                                          > temp2

        fi

	cat temp2 | sed -e 's|DIRARQUIVOGIF|'$DIRARQGIF'|g'								> temp1
	cat temp1 | sed -e 's|MODELO|'"$CABECALHO"'|g' 									> temp2
	cat temp2 | sed -e 's|brmap_hires.dat|hires|g'									> temp1
	cat temp1 | sed -e 's|hires|brmap_hires.dat|g' 									> temp2
	cat temp2 | sed -e 's|mres|brmap_hires.dat|g' 									> temp1
	cat temp1 | sed -e 's|HH|'$HH'|g' 										> temp2
	cat temp2 | sed -e 's|AREA|'${AREA}'|g' 									> temp1
	cat temp1 | sed -e 's|DATAPREV|'$dataprev'|g' 									> temp2
	cat temp2 | sed -e 's|DATAANALISE|'$dataanalise'|g' 								> temp1
	cat temp1 | sed -e 's|PROGN|'$prog'|g' 										> temp2
	cat temp2 | sed -e 's|DIRCOMISSAOGIF|'$DIRCOMGIF'|g'								> temp1   
	echo $arq
	cat temp1 >> raw.gs
	cat /home/operador/grads/wrf/scripts/label >> raw.gs

	if [ $AREA == "antartica" ];then

		/opt/opengrads/opengrads -blc "run raw.gs"
	else

		/opt/opengrads/opengrads -bpc "run raw.gs"
	fi

	echo $arq

done
