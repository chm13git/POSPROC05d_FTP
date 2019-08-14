#!/bin/bash -x
#
# Script para Gerar os gribs do zybrib para METAREA e ANTARTICA
# AUTORA: CT(T) Alana em 05NOV2016 
#
#==================================================================================

if [ $# -ne 5 ];then
	echo "Entre com o modelo (met ou ant), o recorte (comissao), o horario de referencia (00 ou 12), horario inicial(geralmente 00) e horario final(48, 72 ou 96)"
	echo "Ex zygrib_cosmo.sh ant zoom/drakefull/drakecut 00 00 72"
	exit
fi

AREA=$1
RECORTE=$2
HH=$3
HSTART=$4
HSTOP=$5

datahoje=`cat ~/datas/datacorrente${HH}`
datagrads=`cat ~/datas/datacorrente_grads${HH}`
dadosdir="/home/operador/grads/cosmo/cosmoant/zygrib${HH}"

case $AREA in

	ant)
	AREA="ant"
#        HSTOP=72
        HSTOP=$HSTOP
	;;
	met)
	AREA="met"
	HSTOP=72
	;;
	*)
	echo "Modelo nao cadastrado"
	exit 12
	;;
esac
	cd $dadosdir
	#rm *.bin *.grb *.bz2
	rm *.bin 

	nprog=`echo "($HSTOP +3)/3" | bc`
	echo $nprog

   		cd /home/operador/grads/cosmo/cosmo${AREA}/gs
   		cp  teste2.zygrib.gs tmp1    
   		cat tmp1 | sed -e 's|HH|'$HH'|g'              > tmp2
   		cat tmp2 | sed -e 's|AREA|'${AREA}'|g'        > tmp1
   		cat tmp1 | sed -e 's|DATAHOJE|'$datahoje'|g'  > tmp2
   		cat tmp2 | sed -e 's|PROGN|'$nprog'|g'        > tmp1
   		mv tmp1 rawzygrib_teste2.gs
   		rm tmp2 


	 	/opt/opengrads/opengrads -bpc "run /home/operador/grads/cosmo/cosmo${AREA}/gs/rawzygrib_teste2.gs"

###########################################################################################################################
########  Utilizando o Lats4d para desrotacionar os dados de Vento do COSMO ANT ###########################################
###########################################################################################################################

################################################################################
#
# Significado das linhas abaixo:
# Registro ou kpds
# ^1: 1:0:d=${wgrb_date}:PRMSL:kpds5=2:kpds6=102:kpds7=0   Extrai pressao reduzida a superficie
# kpds5=7:kpds6=4                                      Extrai isolinha de 0 grau
# kpds5=11:kpds6=105                                   Extrai a T2m (K)
# kpds5=17:kpds6=105                                   Extrai a TD2m (K)
# kpds5=33:kpds6=105                                   Extrai U_10M (m/s)
# kpds5=34:kpds6=105                                   Extrai V_10M (m/s)
# kpds5=52:kpds6=105                                   Extrai UR 2m (%)
# kpds5=71                                             Extrai Cobertura Total de Nuvens
# kpds5=20:kpds6=1                                     Extrai Visibilidade (m)
# kpds5=180:kpds6=1                                    Extrai Rajadas (m/s)
# kpds5=33:kpds6=100                                   Extrai comp U nos niveis ne pressao
# kpds5=34:kpds6=100                                   Extrai comp V nos niveis de pressao
# kpds5=11:kpds6=100                                   Extrai temperatura nos niveis de pressao
# kpds5=17:kpds6=100                                   Extrai temp do ponto de orvalho nos niveis de pressao
# kpds5=52:kpds6=100                                   Extrai a UR (%) nos niveis de pressao
# kpds5=66:kpds6=1                                     Extrai profundidade de neve (m)
# kpds5=143:kpds6=1 (esta duplicado com 289)           Extrai Neve Categorica (0 ou 1)
# kpds5=141:kpds6=1 (esta duplicado com 291)           Extrai Chuva congelada categorica (0 ou 1)
# kpds5=79:kpds6=1                                     Extrai Neve de escala de grade
# kpds5=61:kpds6=1                                     Extrai Prec. total kg/m2
# kpds5=63:kpds6=1                                     Extrai Prec. Convectiva kg/m2
# kpds5=71:kpds6=200                                   Extrai Cobert. total de nuvens %
#################################################################################


if [ "$AREA" == "ant" ] && [ "$RECORTE" == "operantar" ] ; then
echo "fazendo drake"
sleep 2

#/opt/opengrads/opengrads -bpc "run /opt/opengrads/Resources/Scripts/lats4d.gs -i /home/operador/grads/cosmo/cosmo${AREA}/ctl/ctl${HH}/cosmo_ant_${HH}_zygribBIN.ctl -format grib -center chm -table /home/operador/grads/cosmo/cosmoant/invariantes/zygribtable -lon -90 -50 -lat -75 -40 -o $dadosdir/cosmo_zygrib_previous -q"

/opt/opengrads/opengrads -bpc "run /opt/opengrads/Contents/Resources/Scripts/lats4d.gs -i /home/operador/grads/cosmo/cosmo${AREA}/ctl/ctl${HH}/cosmo_ant_${HH}_zygribBIN.ctl -format grib -center chm -table /home/operador/grads/cosmo/cosmoant/invariantes/zygribtable -lon -90 -50 -lat -75 -40 -o $dadosdir/cosmo_zygrib_previous -q"

	cd $dadosdir

#wgrib -s cosmo_zygrib_previous.grb | egrep "(:UGRD:|:VGRD:)" | wgrib -i -grib cosmo_zygrib_previous.grb -o new_cosmo_uv_unrot.grb
#wgrib -s cosmo_zygrib_previous.grb | egrep "(kpds5=33:kpds6=105|kpds5=34:kpds6=105)" | wgrib -i -grib cosmo_zygrib_previous.grb -o new_cosmo_uv_unrot.grb

########Alterando o numero do centro gerador dos dados##################################################################### 
#####	/usr/local/bin/grib_set -s generatingProcessIdentifier=31 cosmo_zygrib_previous.grb cosmo_zygrib2_previous.grb

	/home/operador/local/bin/grib_set -s generatingProcessIdentifier=31 cosmo_zygrib_previous.grb cosmo_zygrib2_previous.grb
######## Isolando os dados para manipular os dados da  rajada #############################################################
	wgrib -s cosmo_zygrib2_previous.grb | egrep "(:TMP:|:RH:|:PRMSL:|:APCP:|:UGRD:|:VGRD:)" | wgrib -i -grib cosmo_zygrib2_previous.grb -o new_zygrib_previous_without_gusts.grb
#	Isolando a rajada dos demais dados
	wgrib -s cosmo_zygrib2_previous.grb | egrep "(:SALIN:)" | wgrib -i -grib cosmo_zygrib2_previous.grb -o new_zygrib_previous_with_gusts.grb
#	Alterando o numero do kpds5
#	/usr/local/bin/grib_set -s indicatorOfParameter=180 new_zygrib_previous_with_gusts.grb tmp.grb
	/home/operador/local/bin/grib_set -s indicatorOfParameter=180 new_zygrib_previous_with_gusts.grb tmp.grb
#	Alterando o numero do kpds6
#	/usr/local/bin/grib_set -s indicatorOfTypeOfLevel=1 tmp.grb tmp1.grb
	/home/operador/local/bin/grib_set -s indicatorOfTypeOfLevel=1 tmp.grb tmp1.grb
#	Alterando o valor do nivel
#	/usr/local/bin/grib_set -s level=0 tmp1.grb tmp2.grb
	/home/operador/local/bin/grib_set -s level=0 tmp1.grb tmp2.grb
##Finalizando a manipulacao do dado da rajada e Isolando os dados para manipulacao do dado da isoterma de 0 graus ##########
	wgrib -s cosmo_zygrib2_previous.grb | egrep "(:HGT:)" | wgrib -i -grib cosmo_zygrib2_previous.grb -o isoterma0graus.grb
#       Alterando o numero do kpds6
#	/usr/local/bin/grib_set -s indicatorOfTypeOfLevel=4 isoterma0graus.grb  isoterma0graus1.grb
	/home/operador/local/bin/grib_set -s indicatorOfTypeOfLevel=4 isoterma0graus.grb  isoterma0graus1.grb
######## Finalizando a manipulacao do dado da isoterma de 0 graus e Isolando os dados para manipulacao do dado de cobertura total de nuvens ####
	wgrib -s cosmo_zygrib2_previous.grb | egrep "(:TCDC:)" | wgrib -i -grib cosmo_zygrib2_previous.grb -o totalcloudcover.grb
#	/usr/local/bin/grib_set -s indicatorOfTypeOfLevel=200 totalcloudcover.grb totalcloudcover1.grb
	/home/operador/local/bin/grib_set -s indicatorOfTypeOfLevel=200 totalcloudcover.grb totalcloudcover1.grb
####################################################################################################################

	cat new_zygrib_previous_without_gusts.grb tmp2.grb isoterma0graus1.grb totalcloudcover1.grb > new_zygrib_previous_total.grb
	mv new_zygrib_previous_total.grb cosmo_${HH}_antartica_operantar_${datahoje}.grb
	bzip2 -f cosmo_${HH}_antartica_operantar_${datahoje}.grb

elif [ "$AREA" == "ant" ] && [ "$RECORTE" == "drakecut" ] ; then
echo "fazendo drake"
sleep 2

#/opt/opengrads/opengrads -bpc "run /opt/opengrads/Contents/Resources/Scripts/lats4d.gs -i /home/operador/grads/cosmo/cosmo${AREA}/ctl/ctl${HH}/cosmo_ant_${HH}_zygribBIN.ctl -format grib -center chm -table /home/operador/grads/cosmo/cosmoant/invariantes/zygribtable -lon -90 -50 -lat -75 -40 -o $dadosdir/cosmo_zygrib_previous_drakecut -q"
/opt/opengrads/opengrads -bpc "run /opt/opengrads/Contents/Resources/Scripts/lats4d.gs -i /home/operador/grads/cosmo/cosmo${AREA}/ctl/ctl${HH}/cosmo_ant_${HH}_zygribBIN.ctl -format grib -center chm -table /home/operador/grads/cosmo/cosmoant/invariantes/zygribtable -lon -80 -50 -lat -70 -50 -o $dadosdir/cosmo_zygrib_previous_drakecut -q"

        cd $dadosdir

########Alterando o numero do centro gerador dos dados##################################################################### 
        /home/operador/local/bin/grib_set -s generatingProcessIdentifier=31 cosmo_zygrib_previous_drakecut.grb cosmo_zygrib2_previous_drakecut.grb

######## Isolando os dados para manipular os dados da  rajada #############################################################
       wgrib cosmo_zygrib2_previous_drakecut.grb | egrep "(kpds5=2:kpds6=102|kpds5=11:kpds6=105|kpds5=52:kpds6=105|kpds5=71:kpds6=3|:APCP:|kpds5=33:kpds6=105|kpds5=34:kpds6=105)" | wgrib -i -grib cosmo_zygrib2_previous_drakecut.grb -o new_zygrib_previous_without_gusts_drakecut.grb

#       Isolando a rajada dos demais dados
        wgrib -s cosmo_zygrib2_previous_drakecut.grb | egrep "(:SALIN:)" | wgrib -i -grib cosmo_zygrib2_previous_drakecut.grb -o new_zygrib_previous_with_gusts_drakecut.grb

#       Alterando o numero do kpds5
        /home/operador/local/bin/grib_set -s indicatorOfParameter=180 new_zygrib_previous_with_gusts_drakecut.grb tmp_drakecut.grb

#       Alterando o numero do kpds6
        /home/operador/local/bin/grib_set -s indicatorOfTypeOfLevel=1 tmp_drakecut.grb tmp1_drakecut.grb

#       Alterando o valor do nivel
        /home/operador/local/bin/grib_set -s level=0 tmp1_drakecut.grb tmp2_drakecut.grb

##Finalizando a manipulacao do dado da rajada e Isolando os dados para manipulacao do dado da isoterma de 0 graus ##########
#        wgrib -s cosmo_zygrib2_previous.grb | egrep "(:HGT:)" | wgrib -i -grib cosmo_zygrib2_previous.grb -o isoterma0graus.grb
#       Alterando o numero do kpds6
#        /usr/local/bin/grib_set -s indicatorOfTypeOfLevel=4 isoterma0graus.grb  isoterma0graus1.grb

######## Finalizando a manipulacao do dado da isoterma de 0 graus e Isolando os dados para manipulacao do dado de cobertura total de nuvens ####
        wgrib -s cosmo_zygrib2_previous_drakecut.grb | egrep "(:TCDC:)" | wgrib -i -grib cosmo_zygrib2_previous_drakecut.grb -o totalcloudcover_drakecut.grb
	/home/operador/local/bin/grib_set -s indicatorOfTypeOfLevel=200 totalcloudcover_drakecut.grb totalcloudcover1_drakecut.grb
####################################################################################################################

        cat new_zygrib_previous_without_gusts_drakecut.grb tmp2_drakecut.grb totalcloudcover1_drakecut.grb > new_zygrib_previous_total_drakecut.grb
        mv new_zygrib_previous_total_drakecut.grb cosmo_${HH}_antartica_drakecut_${datahoje}.grb
        bzip2 -f cosmo_${HH}_antartica_drakecut_${datahoje}.grb


elif [ "$AREA" == "ant" ] && [ "$RECORTE" == "zoom" ] ; then
echo "fazendo zoom"
sleep 2

/opt/opengrads/opengrads -bpc "run /opt/opengrads/Contents/Resources/Scripts/lats4d.gs -i /home/operador/grads/cosmo/cosmo${AREA}/ctl/ctl${HH}/cosmo_ant_${HH}_zygribBIN.ctl -format grib -center chm -table /home/operador/grads/cosmo/cosmoant/invariantes/zygribtable -lon -64 -54 -lat -65 -60.5 -o $dadosdir/cosmo_zygrib_previous_zoom -q"

	cd $dadosdir

########Alterando o numero do centro gerador dos dados##################################################################### 
        /home/operador/local/bin/grib_set -s generatingProcessIdentifier=31 cosmo_zygrib_previous_zoom.grb cosmo_zygrib2_previous_zoom.grb


######## Isolando os dados para manipular os dados da  rajada #############################################################
        wgrib -s cosmo_zygrib2_previous_zoom.grb | egrep "(:TMP:|:RH:|:PRMSL:|:APCP:|:UGRD:|:VGRD:|:SNOD)" | wgrib -i -grib cosmo_zygrib2_previous_zoom.grb -o new_zygrib_previous_without_gusts_zoom.grb
#       Isolando a rajada dos demais dados
        wgrib -s cosmo_zygrib2_previous_zoom.grb | egrep "(:SALIN:)" | wgrib -i -grib cosmo_zygrib2_previous_zoom.grb -o new_zygrib_previous_with_gusts_zoom.grb
#       Alterando o numero do kpds5
        /home/operador/local/bin/grib_set -s indicatorOfParameter=180 new_zygrib_previous_with_gusts_zoom.grb tmp_zoom.grb
#       Alterando o numero do kpds6
        /home/operador/local/bin/grib_set -s indicatorOfTypeOfLevel=1 tmp_zoom.grb tmp1_zoom.grb
#       Alterando o valor do nivel
        /home/operador/local/bin/grib_set -s level=0 tmp1_zoom.grb tmp2_zoom.grb
######## Finalizando a manipulacao do dado da rajada ########################################################################
######## Isolando os dados para manipulacao do dado da isoterma de 0 graus ########################################################################
        wgrib -s cosmo_zygrib2_previous_zoom.grb | egrep "(:HGT:)" | wgrib -i -grib cosmo_zygrib2_previous_zoom.grb -o isoterma0graus_zoom.grb
#       Alterando o numero do kpds6
        /home/operador/local/bin/grib_set -s indicatorOfTypeOfLevel=4 isoterma0graus_zoom.grb  isoterma0graus1_zoom.grb
######## Finalizando a manipulacao do dado da isoterma de 0 graus######################################################################
######## Isolando os dados para manipulacao do dado de cobertura total de nuvens ##############################################
	wgrib -s cosmo_zygrib2_previous_zoom.grb | egrep "(:TCDC:)" | wgrib -i -grib cosmo_zygrib2_previous_zoom.grb -o totalcloudcover_zoom.grb
	/home/operador/local/bin/grib_set -s indicatorOfTypeOfLevel=200 totalcloudcover_zoom.grb totalcloudcover1_zoom.grb
####################################################################################################################

        cat new_zygrib_previous_without_gusts_zoom.grb tmp2_zoom.grb isoterma0graus1_zoom.grb totalcloudcover1_zoom.grb > new_zygrib_previous_total_zoom.grb
        mv new_zygrib_previous_total_zoom.grb cosmo_${HH}_antartica_zoom_${datahoje}.grb
        bzip2 -f cosmo_${HH}_antartica_zoom_${datahoje}.grb

else
echo " Terminado o zyyyyy"
fi
