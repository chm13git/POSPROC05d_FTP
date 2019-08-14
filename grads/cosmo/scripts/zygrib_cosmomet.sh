#!/bin/bash -x
#
# Script para Gerar os gribs do zybrib para METAREA e ANTARTICA
# AUTORA: CT(T) Alana em 05NOV2016 
#
#==================================================================================

if [ $# -ne 5 ];then
	echo "Entre com o modelo (met), o recorte (comissao), o horario de referencia (00 ou 12), horario inicial(geralmente 00) e horario final(48, 72 ou 96)"
#	echo "Ex zygrib_cosmo.sh ant zoom/drakefull/drakecut 00 00 72"
	exit
fi

AREA=$1
RECORTE=$2
HH=$3
HSTART=$4
HSTOP=$5

datahoje=`cat ~/datas/datacorrente${HH}`
datagrads=`cat ~/datas/datacorrente_grads${HH}`
dadosdir="/home/operador/grads/cosmo/cosmomet/zygrib${HH}"

case $AREA in

	met)
	AREA="met"
	HSTOP=$HSTOP
	;;
	*)
	echo "Modelo nao cadastrado"
	exit 12
	;;
esac
	cd $dadosdir
	#rm *.bin *.grb *.bz2
	rm *.bin 
	rm *.grb
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


if [ "$AREA" == "met" ] && [ "$RECORTE" == "operantar" ] ; then
echo "fazendo comissao"
sleep 2


/opt/opengrads/opengrads -bpc "run /opt/opengrads/Resources/Scripts/lats4d.gs -i /home/operador/grads/cosmo/cosmo${AREA}/ctl/ctl${HH}/cosmo_met5_${HH}_zygribBIN.ctl -format grib -center chm -table /home/operador/grads/cosmo/cosmomet/invariantes/zygribtable -lon -70 -40 -lat -45 -22 -o $dadosdir/cosmo_zygrib_previous -q"

	cd $dadosdir


########Alterando o numero do centro gerador dos dados##################################################################### 

	/usr/local/bin/grib_set -s generatingProcessIdentifier=31 cosmo_zygrib_previous.grb cosmo_zygrib2_previous.grb

######## Isolando os dados para manipular os dados da  rajada #############################################################
	wgrib -s cosmo_zygrib2_previous.grb | egrep "(:TMP:|:RH:|:PRMSL:|:APCP:|:UGRD:|:VGRD)" | wgrib -i -grib cosmo_zygrib2_previous.grb -o new_zygrib_previous_without_gusts.grb

#	Isolando a rajada dos demais dados
	wgrib -s cosmo_zygrib2_previous.grb | egrep "(:SALIN:)" | wgrib -i -grib cosmo_zygrib2_previous.grb -o new_zygrib_previous_with_gusts.grb

#	Alterando o numero do kpds5
	/usr/local/bin/grib_set -s indicatorOfParameter=180 new_zygrib_previous_with_gusts.grb tmp.grb

#	Alterando o numero do kpds6
	/usr/local/bin/grib_set -s indicatorOfTypeOfLevel=1 tmp.grb tmp1.grb

#	Alterando o valor do nivel
	/usr/local/bin/grib_set -s level=0 tmp1.grb tmp2.grb

########  Isolando os dados para manipulacao do dado de cobertura total de nuvens ####
	wgrib -s cosmo_zygrib2_previous.grb | egrep "(:TCDC:)" | wgrib -i -grib cosmo_zygrib2_previous.grb -o totalcloudcover.grb
	/usr/local/bin/grib_set -s indicatorOfTypeOfLevel=200 totalcloudcover.grb totalcloudcover1.grb
####################################################################################################################

	cat new_zygrib_previous_without_gusts.grb tmp2.grb totalcloudcover1.grb > new_zygrib_previous_total.grb
	mv new_zygrib_previous_total.grb cosmo_${HH}_metarea5_operantar_${datahoje}.grb
	bzip2 -f cosmo_${HH}_metarea5_operantar_${datahoje}.grb
scp cosmo_${HH}_metarea5_operantar_${datahoje}.grb.bz2 supervisor@dpnt02:/home/supervisor/zygrib/cosmo/metarea5/${HH}HMG
scp cosmo_${HH}_metarea5_operantar_${datahoje}.grb.bz2 supervisor@dpnt02b:/home/supervisor/zygrib/cosmo/metarea5/${HH}HMG

elif [ "$AREA" == "met" ] && [ "$RECORTE" == "missilex" ] ; then
echo "fazendo missilex"
sleep 2

/opt/opengrads/opengrads -bpc "run /opt/opengrads/Resources/Scripts/lats4d.gs -i /home/operador/grads/cosmo/cosmo${AREA}/ctl/ctl${HH}/cosmo_met5_${HH}_zygribBIN.ctl -format grib -center chm -table /home/operador/grads/cosmo/cosmomet/invariantes/zygribtable -lon -45 -38 -lat -27 -21 -o $dadosdir/cosmo_zygrib_previous_missilex -q"

        cd $dadosdir

########Alterando o numero do centro gerador dos dados##################################################################### 
        /usr/local/bin/grib_set -s generatingProcessIdentifier=31 cosmo_zygrib_previous_missilex.grb cosmo_zygrib2_previous_missilex.grb

######## Isolando os dados para manipular os dados da  rajada #############################################################
       wgrib cosmo_zygrib2_previous_missilex.grb | egrep "(:TMP:|:RH:|:PRMSL:|:APCP:|:UGRD:|:VGRD)" | wgrib -i -grib cosmo_zygrib2_previous_missilex.grb -o new_zygrib_previous_without_gusts_missilex.grb

#       Isolando a rajada dos demais dados
        wgrib -s cosmo_zygrib2_previous_missilex.grb | egrep "(:SALIN:)" | wgrib -i -grib cosmo_zygrib2_previous_missilex.grb -o new_zygrib_previous_with_gusts_missilex.grb


#       Alterando o numero do kpds5
        /usr/local/bin/grib_set -s indicatorOfParameter=180 new_zygrib_previous_with_gusts_missilex.grb tmp_missilex.grb

#       Alterando o numero do kpds6
        /usr/local/bin/grib_set -s indicatorOfTypeOfLevel=1 tmp_missilex.grb tmp1_missilex.grb

#       Alterando o valor do nivel
        /usr/local/bin/grib_set -s level=0 tmp1_missilex.grb tmp2_missilex.grb

########  Isolando os dados para manipulacao do dado de cobertura total de nuvens ####
        wgrib -s cosmo_zygrib2_previous_missilex.grb | egrep "(:TCDC:)" | wgrib -i -grib cosmo_zygrib2_previous_missilex.grb -o totalcloudcover_missilex.grb
	/usr/local/bin/grib_set -s indicatorOfTypeOfLevel=200 totalcloudcover_missilex.grb totalcloudcover1_missilex.grb
####################################################################################################################

        cat new_zygrib_previous_without_gusts_missilex.grb tmp2_missilex.grb totalcloudcover1_missilex.grb > new_zygrib_previous_total_missilex.grb
        mv new_zygrib_previous_total_missilex.grb cosmo_${HH}_metarea5_missilex_${datahoje}.grb
        bzip2 -f cosmo_${HH}_metarea5_missilex_${datahoje}.grb
scp cosmo_${HH}_metarea5_missilex_${datahoje}.grb.bz2 supervisor@dpnt02c:/home/supervisor/zygrib/cosmo/metarea5/${HH}HMG
scp cosmo_${HH}_metarea5_missilex_${datahoje}.grb.bz2 supervisor@dpnt02b:/home/supervisor/zygrib/cosmo/metarea5/${HH}HMG

elif [ "$AREA" == "met" ] && [ "$RECORTE" == "unitas" ] ; then
echo "fazendo unitas"
sleep 2

/opt/opengrads/opengrads -bpc "run /opt/opengrads/Resources/Scripts/lats4d.gs -i /home/operador/grads/cosmo/cosmo${AREA}/ctl/ctl${HH}/cosmo_met5_${HH}_zygribBIN.ctl -format grib -center chm -table /home/operador/grads/cosmo/cosmomet/invariantes/zygribtable -lon -47 -40 -lat -26 -21 -o $dadosdir/cosmo_zygrib_previous_unitas -q"

        cd $dadosdir

########Alterando o numero do centro gerador dos dados#####################################################################
        /usr/local/bin/grib_set -s generatingProcessIdentifier=31 cosmo_zygrib_previous_unitas.grb cosmo_zygrib2_previous_unitas.grb


######## Isolando os dados para manipular os dados da  rajada #############################################################
        wgrib -s cosmo_zygrib2_previous_unitas.grb | egrep "(:TMP:|:RH:|:PRMSL:|:APCP:|:UGRD:|:VGRD)" | wgrib -i -grib cosmo_zygrib2_previous_unitas.grb -o new_zygrib_previous_without_gusts_unitas.grb

#       Isolando a rajada dos demais dados
        wgrib -s cosmo_zygrib2_previous_unitas.grb | egrep "(:SALIN:)" | wgrib -i -grib cosmo_zygrib2_previous_unitas.grb -o new_zygrib_previous_with_gusts_unitas.grb

#       Alterando o numero do kpds5
        /usr/local/bin/grib_set -s indicatorOfParameter=180 new_zygrib_previous_with_gusts_unitas.grb tmp_unitas.grb

#       Alterando o numero do kpds6
        /usr/local/bin/grib_set -s indicatorOfTypeOfLevel=1 tmp_unitas.grb tmp1_unitas.grb

#       Alterando o valor do nivel
        /usr/local/bin/grib_set -s level=0 tmp1_unitas.grb tmp2_unitas.grb

######## Finalizando a manipulacao do dado da rajada ########################################################################

######## Isolando os dados para manipulacao do dado de cobertura total de nuvens ##############################################
        wgrib -s cosmo_zygrib2_previous_unitas.grb | egrep "(:TCDC:)" | wgrib -i -grib cosmo_zygrib2_previous_unitas.grb -o totalcloudcover_unitas.grb
        /usr/local/bin/grib_set -s indicatorOfTypeOfLevel=200 totalcloudcover_unitas.grb totalcloudcover1_unitas.grb
####################################################################################################################

        cat new_zygrib_previous_without_gusts_unitas.grb tmp2_unitas.grb totalcloudcover1_unitas.grb > new_zygrib_previous_total_unitas.grb
        mv new_zygrib_previous_total_unitas.grb cosmo_${HH}_metarea5_unitas_${datahoje}.grb
        bzip2 -f cosmo_${HH}_metarea5_unitas_${datahoje}.grb
scp cosmo_${HH}_metarea5_unitas_${datahoje}.grb.bz2 supervisor@dpnt02c:/home/supervisor/zygrib/cosmo/metarea5/${HH}HMG
scp cosmo_${HH}_metarea5_unitas_${datahoje}.grb.bz2 supervisor@dpnt02b:/home/supervisor/zygrib/cosmo/metarea5/${HH}HMG
else 

echo 
echo " Terminando o zygrib" 
echo 

fi 
