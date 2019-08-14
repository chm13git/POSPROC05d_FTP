#!/bin/bash -x

# Esse script faz os links do cosmoant para gerar o dado para o ww3

if [ $# -ne 2 ];then

	echo "Entre com a area modelada (ant), com o horario de referencia (00 ou 12)"
	exit

fi

AREA=$1
HH=$2
HSTART="00"
dadosdir="/home/operador/grads/cosmo/cosmoant/ww3_unrot${HH}"
dpns5dir="/home/operador/grads/cosmo/cosmo${AREA}"
datahoje=`cat /home/operador/datas/datacorrente${HH}`
datagrads=`/usr/bin/caldate $datahoje$HH + 0h 'hhZddmmmyyyy'`
echo "Os seguintes parametros foram passados para o script"
echo "AREA=$AREA"
echo "HH=$HH - horario de referencia da rodada "

case ${AREA} in
	ant)
	HSTOP=96
	AREA2="ant"
	;;
esac


	cd ${dadosdir}
	
	if ! [ -z $AREA2 ];then
	ln -sf  ${dadosdir}/lfff00000000 cosmo_ant_${HH}_${datahoje}000
	ln -sf  ${dadosdir}/lfff00010000 cosmo_ant_${HH}_${datahoje}001
	ln -sf  ${dadosdir}/lfff00020000 cosmo_ant_${HH}_${datahoje}002
	ln -sf  ${dadosdir}/lfff00030000 cosmo_ant_${HH}_${datahoje}003
	ln -sf  ${dadosdir}/lfff00040000 cosmo_ant_${HH}_${datahoje}004
	ln -sf  ${dadosdir}/lfff00050000 cosmo_ant_${HH}_${datahoje}005
	ln -sf  ${dadosdir}/lfff00060000 cosmo_ant_${HH}_${datahoje}006
	ln -sf  ${dadosdir}/lfff00070000 cosmo_ant_${HH}_${datahoje}007
	ln -sf  ${dadosdir}/lfff00080000 cosmo_ant_${HH}_${datahoje}008
	ln -sf  ${dadosdir}/lfff00090000 cosmo_ant_${HH}_${datahoje}009
	ln -sf  ${dadosdir}/lfff00100000 cosmo_ant_${HH}_${datahoje}010
	ln -sf  ${dadosdir}/lfff00110000 cosmo_ant_${HH}_${datahoje}011
	ln -sf  ${dadosdir}/lfff00120000 cosmo_ant_${HH}_${datahoje}012
	ln -sf  ${dadosdir}/lfff00130000 cosmo_ant_${HH}_${datahoje}013
	ln -sf  ${dadosdir}/lfff00140000 cosmo_ant_${HH}_${datahoje}014
	ln -sf  ${dadosdir}/lfff00150000 cosmo_ant_${HH}_${datahoje}015
	ln -sf  ${dadosdir}/lfff00160000 cosmo_ant_${HH}_${datahoje}016
	ln -sf  ${dadosdir}/lfff00170000 cosmo_ant_${HH}_${datahoje}017
	ln -sf  ${dadosdir}/lfff00180000 cosmo_ant_${HH}_${datahoje}018
	ln -sf  ${dadosdir}/lfff00190000 cosmo_ant_${HH}_${datahoje}019
	ln -sf  ${dadosdir}/lfff00200000 cosmo_ant_${HH}_${datahoje}020
	ln -sf  ${dadosdir}/lfff00210000 cosmo_ant_${HH}_${datahoje}021
	ln -sf  ${dadosdir}/lfff00220000 cosmo_ant_${HH}_${datahoje}022
	ln -sf  ${dadosdir}/lfff00230000 cosmo_ant_${HH}_${datahoje}023
	ln -sf  ${dadosdir}/lfff01000000 cosmo_ant_${HH}_${datahoje}024
	ln -sf  ${dadosdir}/lfff01010000 cosmo_ant_${HH}_${datahoje}025
	ln -sf  ${dadosdir}/lfff01020000 cosmo_ant_${HH}_${datahoje}026
	ln -sf  ${dadosdir}/lfff01030000 cosmo_ant_${HH}_${datahoje}027
	ln -sf  ${dadosdir}/lfff01040000 cosmo_ant_${HH}_${datahoje}028
	ln -sf  ${dadosdir}/lfff01050000 cosmo_ant_${HH}_${datahoje}029
	ln -sf  ${dadosdir}/lfff01060000 cosmo_ant_${HH}_${datahoje}030
	ln -sf  ${dadosdir}/lfff01070000 cosmo_ant_${HH}_${datahoje}031
	ln -sf  ${dadosdir}/lfff01080000 cosmo_ant_${HH}_${datahoje}032
	ln -sf  ${dadosdir}/lfff01090000 cosmo_ant_${HH}_${datahoje}033
	ln -sf  ${dadosdir}/lfff01100000 cosmo_ant_${HH}_${datahoje}034
	ln -sf  ${dadosdir}/lfff01110000 cosmo_ant_${HH}_${datahoje}035
        ln -sf  ${dadosdir}/lfff01120000 cosmo_ant_${HH}_${datahoje}036
        ln -sf  ${dadosdir}/lfff01130000 cosmo_ant_${HH}_${datahoje}037
        ln -sf  ${dadosdir}/lfff01140000 cosmo_ant_${HH}_${datahoje}038
        ln -sf  ${dadosdir}/lfff01150000 cosmo_ant_${HH}_${datahoje}039
        ln -sf  ${dadosdir}/lfff01160000 cosmo_ant_${HH}_${datahoje}040
        ln -sf  ${dadosdir}/lfff01170000 cosmo_ant_${HH}_${datahoje}041
        ln -sf  ${dadosdir}/lfff01180000 cosmo_ant_${HH}_${datahoje}042
        ln -sf  ${dadosdir}/lfff01190000 cosmo_ant_${HH}_${datahoje}043
        ln -sf  ${dadosdir}/lfff01200000 cosmo_ant_${HH}_${datahoje}044
        ln -sf  ${dadosdir}/lfff01210000 cosmo_ant_${HH}_${datahoje}045
        ln -sf  ${dadosdir}/lfff01220000 cosmo_ant_${HH}_${datahoje}046
        ln -sf  ${dadosdir}/lfff01230000 cosmo_ant_${HH}_${datahoje}047
        ln -sf  ${dadosdir}/lfff02000000 cosmo_ant_${HH}_${datahoje}048
        ln -sf  ${dadosdir}/lfff02010000 cosmo_ant_${HH}_${datahoje}049
        ln -sf  ${dadosdir}/lfff02020000 cosmo_ant_${HH}_${datahoje}050
        ln -sf  ${dadosdir}/lfff02030000 cosmo_ant_${HH}_${datahoje}051
        ln -sf  ${dadosdir}/lfff02040000 cosmo_ant_${HH}_${datahoje}052
        ln -sf  ${dadosdir}/lfff02050000 cosmo_ant_${HH}_${datahoje}053
        ln -sf  ${dadosdir}/lfff02060000 cosmo_ant_${HH}_${datahoje}054
        ln -sf  ${dadosdir}/lfff02070000 cosmo_ant_${HH}_${datahoje}055
        ln -sf  ${dadosdir}/lfff02080000 cosmo_ant_${HH}_${datahoje}056
        ln -sf  ${dadosdir}/lfff02090000 cosmo_ant_${HH}_${datahoje}057
        ln -sf  ${dadosdir}/lfff02100000 cosmo_ant_${HH}_${datahoje}058
        ln -sf  ${dadosdir}/lfff02110000 cosmo_ant_${HH}_${datahoje}059
        ln -sf  ${dadosdir}/lfff02120000 cosmo_ant_${HH}_${datahoje}060
        ln -sf  ${dadosdir}/lfff02130000 cosmo_ant_${HH}_${datahoje}061
        ln -sf  ${dadosdir}/lfff02140000 cosmo_ant_${HH}_${datahoje}062
        ln -sf  ${dadosdir}/lfff02150000 cosmo_ant_${HH}_${datahoje}063
        ln -sf  ${dadosdir}/lfff02160000 cosmo_ant_${HH}_${datahoje}064
        ln -sf  ${dadosdir}/lfff02170000 cosmo_ant_${HH}_${datahoje}065
        ln -sf  ${dadosdir}/lfff02180000 cosmo_ant_${HH}_${datahoje}066
        ln -sf  ${dadosdir}/lfff02190000 cosmo_ant_${HH}_${datahoje}067
        ln -sf  ${dadosdir}/lfff02200000 cosmo_ant_${HH}_${datahoje}068
        ln -sf  ${dadosdir}/lfff02210000 cosmo_ant_${HH}_${datahoje}069
        ln -sf  ${dadosdir}/lfff02220000 cosmo_ant_${HH}_${datahoje}070
        ln -sf  ${dadosdir}/lfff02230000 cosmo_ant_${HH}_${datahoje}071
        ln -sf  ${dadosdir}/lfff03000000 cosmo_ant_${HH}_${datahoje}072
        ln -sf  ${dadosdir}/lfff03010000 cosmo_ant_${HH}_${datahoje}073
        ln -sf  ${dadosdir}/lfff03020000 cosmo_ant_${HH}_${datahoje}074
        ln -sf  ${dadosdir}/lfff03030000 cosmo_ant_${HH}_${datahoje}075
        ln -sf  ${dadosdir}/lfff03040000 cosmo_ant_${HH}_${datahoje}076
        ln -sf  ${dadosdir}/lfff03050000 cosmo_ant_${HH}_${datahoje}077
        ln -sf  ${dadosdir}/lfff03060000 cosmo_ant_${HH}_${datahoje}078
        ln -sf  ${dadosdir}/lfff03070000 cosmo_ant_${HH}_${datahoje}079
        ln -sf  ${dadosdir}/lfff03080000 cosmo_ant_${HH}_${datahoje}080
        ln -sf  ${dadosdir}/lfff03090000 cosmo_ant_${HH}_${datahoje}081
        ln -sf  ${dadosdir}/lfff03100000 cosmo_ant_${HH}_${datahoje}082
        ln -sf  ${dadosdir}/lfff03110000 cosmo_ant_${HH}_${datahoje}083
        ln -sf  ${dadosdir}/lfff03120000 cosmo_ant_${HH}_${datahoje}084
        ln -sf  ${dadosdir}/lfff03130000 cosmo_ant_${HH}_${datahoje}085
        ln -sf  ${dadosdir}/lfff03140000 cosmo_ant_${HH}_${datahoje}086
        ln -sf  ${dadosdir}/lfff03150000 cosmo_ant_${HH}_${datahoje}087
        ln -sf  ${dadosdir}/lfff03160000 cosmo_ant_${HH}_${datahoje}088
        ln -sf  ${dadosdir}/lfff03170000 cosmo_ant_${HH}_${datahoje}089
        ln -sf  ${dadosdir}/lfff03180000 cosmo_ant_${HH}_${datahoje}090
        ln -sf  ${dadosdir}/lfff03190000 cosmo_ant_${HH}_${datahoje}091
        ln -sf  ${dadosdir}/lfff03200000 cosmo_ant_${HH}_${datahoje}092
        ln -sf  ${dadosdir}/lfff03210000 cosmo_ant_${HH}_${datahoje}093
        ln -sf  ${dadosdir}/lfff03220000 cosmo_ant_${HH}_${datahoje}094
        ln -sf  ${dadosdir}/lfff03230000 cosmo_ant_${HH}_${datahoje}095
        ln -sf  ${dadosdir}/lfff04000000 cosmo_ant_${HH}_${datahoje}096
        

        fi

