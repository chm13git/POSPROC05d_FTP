#!/bin/bash -x

# Script para ftp_gfs.sh
#
# Autor: 1 T(T) LEANDRO 
#
# Alterado em 03SET2014   Por: 1T(T) Alexandre Gadelha
#
#==================================================================================

#==================================================================================
#
# Script para gerar o pos processamento do GFS para as areas de interesse.
# Procura primeiramente os dados do GFS na DPNS01 e caso nao encontre,
# assume que os dados da DPNS31 estao presentes e tenta gerar as figuras.
# 
#==================================================================================

# Testando se o paramentro referente o horario da rodada foi passado

	if [ $# -ne 3 ];then

		echo " Entre com a area modelada (glo, met, car e lib), com o horario de referencia (00 ou 12) \
		e com o periodo de previsao em horas (24, 48, 71, ..)!!!! "

		exit

	fi

AREA=$1
HH=$2
HSTOP=$3

dpns5dir="/home/operador/grads/gfs/gfs${AREA}"
gifdir="/home/operador/grads/gif/gfs${AREA}_${HH}"
datahoje=`cat ~/datas/datacorrente${HH}`
datagrads=`cat ~/datas/datacorrente_grads${HH}`
#dadosdir07="/home/operador/data/gfs/data_dpns07/${datahoje}"
dadosdir31="/home/operador/data/gfs/data${HH}_dpns31"
dadosdir25a="/home/operador/data/gfs/data${HH}_dpns25a"
dadosdir01="/home/operador/data/gfs/data${HH}_dpns01"
#dadosdir26a="/home/operador/data/gfs/data${HH}_dpns26a"
dadosdir="/home/operador/data/gfs/data${HH}"
dados2dir="/home/operador/grads/gfs/dados${HH}"

# testa se existe o diretorio na DPNS07,
# caso NAO, DIRECIONA os dados do GFS para a DPNS25a ou DPNS26a.
# Para a dpns05d direciona os dados da dpns01

ls ${dadosdir}

	if [ $? -eq 0 ];then

	dadosdir2=${dadosdir}

	else

	dadosdir2=${dadosdir}

	fi

DIG=0

rm /home/operador/grads/gfs/gfs/ctl/ctl${HH}/*

for HREF in `seq 0 3 $HSTOP`;do

	if [ $HREF -lt 10 ];then

		HORA=0$DIG$HREF

	elif [ $HREF -lt 100 ];then

		HORA=$DIG$HREF

	else

		HORA=$HREF

	fi

str="${str} ${HORA}"

done

#Apagando as figuras no diretorio local

rm -f ${gifdir}/*.gif
rm -f ${gifdir}/*.png
rm -f ${gifdir}/internet/*
rm -f ${dados2dir}/gfs*
#rm -f ${dadosdir}/*

#*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.

# Passo 0 - Verifica se o GFS da Area e horario especificado terminou a rodada
#          senao espera ateh 2 horas
#
#

for prog in `echo ${str}`;do

	flag=1
ni=0

RFILE=gfs.t${HH}z.pgrb2.0p25.f${prog}
RFILE2=gfs.t${HH}z.pgrb2.0p25.f${prog}


	while [ $flag -eq 1 ];do 

		# testa se existe o diretorio na DPNS01,
		# caso NAO, UTILIZA os dados da  DPNS31.

        	if [ ${dadosdir} == ${dadosdir} ];then

			if  [ -e ${dadosdir}/${RFILE} ] ; then

				echo "Prontificado o prognostico de ${prog}h do GFS ${AREA}"

				flag=0

				echo
		        	echo " Copiando o arquivo GFS da DPNS01. "
		        	echo

				ln -sf  ${dadosdir}/${RFILE} ${dados2dir}/${RFILE2}

			else

				echo " A pasta de hoje existe mas o arquivo ${dadosdir2}/${RFILE2} nao esta la. "

				echo "Prognostico de ${prog}h do GFS ${AREA} ainda nao foi prontificado"

				k=`expr $ni + 1`
				ni=$k
				datafile=0

				sleep 30

					if [ $ni -ge 480 ];then

						echo "Apos 4 horas abortei a rodada !!!!"
						exit 12

					fi

			fi

		else

			echo
			echo " Copiando o arquivo GFS da DPNS31. "
			echo

			ln -sf ${dadosdir2}/${RFILE2} ${dados2dir}/${RFILE2}

			flag=0

		fi

		if [ $prog == "000" ];then

        		valor=354

        	else

        		valor=417

        	fi

	campo=`/usr/local/bin/wgrib2  ${dados2dir}/${RFILE2} | wc -l`

		if [ $campo -ge ${valor} ];then

			echo " Arquivo  ${RFILE2} completo. "

		else

			echo " Arquivo ${RFILE2} incompleto. "
			flag=1

		fi
 
	dataarq=`/usr/local/bin/wgrib2 -v ${dados2dir}/${RFILE2}  | head -1 | cut -f2 -d"=" | cut -f1 -d":"`

		if [ $dataarq -eq ${datahoje}${HH} ];then

			echo " Arquivo ${RFILE2} de hoje. "

		else

			echo " Arquivo ${RFILE2} nao e de hoje. "
			flag=1

		fi

	done

	#*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.

	if ! [ $AREA == "glo" ];then

		echo =======================================================================
		echo
		echo POS-PROCESSAMENTO DO GFS ${AREA2} ${HH}Z Prognostico de $prog h 
		echo

		#if [ $prog -eq "00" ]
		#then
		#/home/operador/grads/faxsimile/scripts/faxsimile.sh gfs $prog
		#fi

		cd ${dpns5dir}/ctl/ctl${HH}

#		rm -f gfs_${AREA}_${HH}*.ctl
#		rm -f *.idx

		deltat=`echo "($prog + $HH)" | bc`
		datagrads=`/usr/bin/caldate $datahoje + ${deltat}h 'hhZddmmmyyyy'`

		cat ${dpns5dir}/ctl/gfs_${AREA}_HH.ctl | sed -e 's|HH|'$HH'|' 	> raw
		cat raw | sed -e 's|DATAGRADS|'$datagrads'|' 			> raw2
		cat raw2 | sed -e 's|NOMEGRIB|'$RFILE2'|' 			> raw
		mv raw gfs_${AREA}_${HH}.ctl
		/usr/local/bin/gribmap -i gfs_${AREA}_${HH}.ctl

		echo " fazendo ctls"

		for L in `echo "6 24"`;do

			resto=`echo "( $prog % $L )" | bc`

			if [ $resto -eq 0 ] && [ $prog -gt 0 ] ;then

				cont1=`echo "( $prog - $L ) / 3 + 1 " | bc`
				cont2=`echo "$prog / 3 + 1 " | bc`
				progt=`echo ${str} | cut -f$cont1-$cont2 -d" "`
				deltat2=`echo "( $deltat - $L )" | bc`
				datagradst=`/usr/bin/caldate $datahoje + ${deltat2}h 'hhZddmmmyyyy'`
				ni=`echo "( $L / 3 ) + 1 " | bc`

				cat ${dpns5dir}/ctl/gfs_${AREA}_HH_${L}.ctl | sed -e 's|HH|'$HH'|g' 	> raw
				cat raw | sed -e 's|DATAGRADS'$L'|'$datagradst'|' 			> raw2
#				cat raw2 | sed -e 's|NOMEGRIB'$L'|'$RFILE2'|' 				> raw

				for i in `seq 1 $ni`;do

					progi=`echo $progt | cut -f$i -d" "`
					cat raw2 | sed -e 's|PROG'$i'|'$progi'|' 			> raw
					mv raw  raw2
				done

				mv raw2 gfs_${AREA}_${HH}_$L.ctl
				/usr/local/bin/gribmap -i gfs_${AREA}_${HH}_$L.ctl

			fi
		done

		rm *raw*

		echo
		echo executando GrADs...
		date
		echo

		if [ $prog -le 99 ];then

			dig="0"

		else

			dig=""

		fi

		${dpns5dir}/../scripts/roda.sh ${AREA} ${HH} ${prog}

	fi

        # Preparando os arquivos que serao utilizados para os cortes verticais
#        /usr/local/bin/wgrib2 $dadosdir/$RFILE2 -match UGRD -match mb: -small_grib -100:40 -70:50 $dados2dir/${RFILE2}_1
#        /usr/local/bin/wgrib2 $dadosdir/$RFILE2 -match VGRD -match mb: -small_grib -100:40 -70:50 $dados2dir/${RFILE2}_2
#        /usr/local/bin/wgrib2 $dadosdir/$RFILE2 -match RH -match mb: -small_grib -100:40 -70:50  $dados2dir/${RFILE2}_3
#        /usr/local/bin/wgrib2 $dadosdir/$RFILE2 -match TMP  -match mb: -small_grib -100:40 -70:50 $dados2dir/${RFILE2}_4
#        /usr/local/bin/wgrib2 $dadosdir/$RFILE2 -match TCDC:low -small_grib -100:40 -70:50  $dados2dir/${RFILE2}_5
#        /usr/local/bin/wgrib2 $dadosdir/$RFILE2 -match TCDC:middle -small_grib -100:40 -70:50 $dados2dir/${RFILE2}_6
#        /usr/local/bin/wgrib2 $dadosdir/$RFILE2 -match TCDC:high -small_grib -100:40 -70:50  $dados2dir/${RFILE2}_7
#        /usr/local/bin/wgrib2 $dadosdir/$RFILE2 -match TCDC:entire -small_grib -100:40 -70:50 $dados2dir/${RFILE2}_8
#        cat  $dados2dir/${RFILE2}_? >>  $dados2dir/${RFILE2}
#        rm $dados2dir/${RFILE2}_?

done

if ! [ $AREA == "glo" ];then

	cd $gifdir

	for arq in `ls *${prog}.gif`;do

		nomeprog=`echo $arq | cut -f1 -d.`
		/usr/bin/convert $arq $nomeprog.png

	done

fi

# Gerando os CTLs para o corte vertical

#/home/operador/grads/gfs/scripts/geractl_v2.sh $HH $HSTOP

# Gerando os CTLs para o meteograma

/home/operador/grads/gfs/scripts/geractl_v3.sh $HH $HSTOP

/home/operador/ftp_comissoes/ftp_comissoes.sh $HH gfs${AREA}
