#!/bin/bash -x
#
# Script para Gerar os gribs do zybrib para METAREA e ANTARTICA
# AUTORA: CT(T) Alana em 05NOV2016 
#
#==================================================================================

if [ $# -ne 5 ];then
	echo "Entre com o modelo (ant), o recorte (drakefull), o horario de referencia (00 ou 12), horario inicial(geralmente 00) e horario final(48, 72 ou 96)"
	echo "Ex zygrib_unrot.sh ant drakefull 00 00 96"
	exit
fi

AREA=$1
RECORTE=$2
HH=$3
HSTART=$4
HSTOP=$5

datahoje=`cat ~/datas/datacorrente${HH}`
datagrads=`cat ~/datas/datacorrente_grads${HH}`
dadosdir="/home/operador/grads/cosmo/cosmoant/ww3_unrot${HH}"

case $AREA in

        ant)
        AREA="ant"
        HSTOP=96
        ;;
        *)
        echo "Modelo nao cadastrado"
        exit 12
        ;;
esac

	/home/operador/grads/cosmo/scripts/geralinks_ww3ant.sh ant ${HH}
	/home/operador/grads/cosmo/scripts/geractl_unrot.sh ant ${HH}

        cd $dadosdir

        #rm *.bin *.grb *.bz2
        rm *.bin
	rm *.grb
	rm *.nc

#       nprog=`echo "($HSTOP +3)/3" | bc`
        nprog=`echo "($HSTOP +1)" | bc`
        echo $nprog

   		cd /home/operador/grads/cosmo/cosmo${AREA}/gs
   		cp  teste2.zygrib_unrot.gs tmp1    
   		cat tmp1 | sed -e 's|HH|'$HH'|g'              > tmp2
   		cat tmp2 | sed -e 's|AREA|'${AREA}'|g'        > tmp1
   		cat tmp1 | sed -e 's|DATAHOJE|'$datahoje'|g'  > tmp2
   		cat tmp2 | sed -e 's|PROGN|'$nprog'|g'        > tmp1
   		mv tmp1 rawzygrib_teste2_unrot.gs
   		rm tmp2 


		/opt/opengrads/opengrads -bpc "run /home/operador/grads/cosmo/cosmo${AREA}/gs/rawzygrib_teste2_unrot.gs"

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



/opt/opengrads/opengrads -bpc "run /opt/opengrads/Resources/Scripts/lats4d.gs -i /home/operador/grads/cosmo/cosmo${AREA}/ctl/ctl${HH}/cosmo_ant_${HH}_zygribBINunrot.ctl -format grib -center chm -table /home/operador/grads/cosmo/cosmoant/invariantes/zygribtable -lon -90 -50 -lat -75 -40 -o $dadosdir/cosmo_zygrib_previous -q"


cd $dadosdir


wgrib cosmo_zygrib_previous.grb | egrep "(:kpds5=33:kpds6=105|kpds5=34:kpds6=105)" | wgrib -i -grib cosmo_zygrib_previous.grb -o new_ww3_antartica.grb

/usr/local/src/instalacao_novo_cdo/teste/bin/cdo -f nc copy new_ww3_antartica.grb new_ww3_antartica.nc

