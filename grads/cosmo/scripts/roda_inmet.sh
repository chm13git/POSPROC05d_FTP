#!/bin/bash -x

if [ $# -ne 3 ];then

	echo "Entre com  area (met, sse, ne, pry ou ant) e o horario de referencia (00 ou 12) e o prognostico (24, 48, 72, ...) !!!"

	exit 12
fi

AREA=$1
HH=$2
prog=$3

case $AREA in

	met)
	AREA2="met5"
	HSTOP=78
	;;

	ant)
	AREA2="ant"
	HSTOP=78
	;;

	inmet)
	AREA2="inmet"
	HSTOP=27
	;;

	sse)
	AREA2="sse"
	;;

	ne)
	AREA2="ne"
	HSTART="00"
	HSTOP="78"
	;;

	pry)
	AREA2="pry"
	HSTART="00"
	HSTOP="78"
	;;

esac


deltat=`echo "( $prog + 0 )" | bc`
datacorrente=`cat /home/operador/datas/datacorrente$HH`
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

cd /home/operador/grads/cosmo/cosmo${AREA}/gs

for arq in `cat /home/operador/grads/cosmo/cosmo${AREA}/invariantes/lista`
do

	rm -f raw.gs
	echo "'reinit'" > raw.gs
	echo str=\"$str\" >> raw.gs
  	cat $arq > temp1

        prefixgs=`echo ${arq} | cut -c1-4`

        if [ $prefixgs == "zoom" ];then

                DIRARQGIF="/home/operador/grads/gif/cosmo_inmetzoom_$HH"
                DIRCOMGIF="/home/operador/ftp_comissoes/gif/cosmo_inmetzoom_$HH"

                if [ -s /home/operador/grads/cosmo/cosmo${AREA}/invariantes/gradscosmoinmetzoom ];then

                        cat /home/operador/grads/cosmo/cosmo${AREA}/invariantes/gradcosmoinmetzoom >> temp1

                fi

        else

                DIRARQGIF="/home/operador/grads/gif/cosmo${AREA}_${HH}"
                DIRCOMGIF="/home/operador/ftp_comissoes/gif/cosmo${AREA}_$HH"

                if [ -s /home/operador/grads/cosmo/cosmo${AREA}/invariantes/grad$AREA ];then

                        cat /home/operador/grads/cosmo/cosmo${AREA}/invariantes/grad$AREA >> temp1

                fi
        fi

	cat temp1 | sed -e 's|ARQUIVOCTL|/home/operador/grads/cosmo/cosmo'$AREA'/ctl/ctl'$HH'/cosmo'_${AREA2}_${HH}'|g' > temp2
	mv temp2 temp1
	cat temp1 | sed -e 's|DIRARQUIVOGIF|'$DIRARQGIF'|g' 								> temp2
	cat temp2 | sed -e 's|MODELO|Modelo COSMO/INMET/CHM|g' 								> temp1
	cat temp1 | sed -e 's|brmap_hires.dat|hires|g'									> temp2
	cat temp2 | sed -e 's|hires|brmap_hires.dat|g' 									> temp1
	cat temp1 | sed -e 's|mres|brmap_hires.dat|g' 									> temp2
	cat temp2 | sed -e 's|HH|'$HH'|g' 										> temp1
	cat temp1 | sed -e 's|AREA|'${AREA}'|g' 									> temp2
	cat temp2 | sed -e 's|DATAPREV|'$dataprev'|g' 									> temp1
	cat temp1 | sed -e 's|DATAANALISE|'$dataanalise'|g' 								> temp2
	cat temp2 | sed -e 's|PROGN|'$prog'|g' 										> temp1
#	cat temp1 | sed -e 's|DIRCOMISSAOGIF|/home/operador/ftp_comissoes/gif/cosmo'$AREA'_'$HH'|g' 			> temp2
	cat temp1 | sed -e 's|DIRCOMISSAOGIF|'$DIRCOMGIF'|g' 								> temp2
	mv temp2 temp1
	echo $arq
	cat temp1 >> raw.gs
	cat /home/operador/grads/cosmo/scripts/label >> raw.gs

#	/opt/opengrads/opengrads -bpc "run raw.gs" -g 580x610
	/opt/opengrads/opengrads -bpc "run raw.gs" -g 770x800

	echo $arq
	rm -f temp?

#   rm raw*.gs

#   rm raw.gs

done
