#!/bin/bash -x

AREA=$1
MODELO=$2
HSIM=$3



if ! [ $# == 3 ];then

	echo
	echo " Script para juntar os meteogramas do COSMO e WRF num mesmo arquivo .gif"
	echo
	echo " Se modelo for igual a cosmo, area =(met/ant) e o horario de rodada (00 ou 12). "
	echo " Se o modelo for igual a wrf, area =(metarea5/antartica) e o horario da rodada( 00 ou 12)." 
	echo
	echo " Exemplo de padrao de entrada:"
	echo
	echo " monta_meteogramas met/ant cosmo 00/12"
        echo 
	echo "monta meteogramas metarea5/antartica wrf 00/12"

	exit 222
fi


raiz="/home/operador"
figuras="${raiz}/grads/gif"

case ${MODELO} in
	cosmo)
	lista=`cat ~/grads/${MODELO}/${MODELO}${AREA}/invariantes/lista${AREA}_cosmo`   # LISTA CONTENDO A RELA DOS METEOGRAMAS
	dir_modelo="${raiz}/meteogramas/${MODELO}${AREA}${HSIM}"  # LOCALIZACAO DAS FIGURAS ORIGINAIS
	dir_montage=${figuras}/cosmo${AREA}_${HSIM}/internet      # LOCAL ONDE AS MONTAGENS SERAO SALVAS
	;;
	wrf)
	lista=`cat ~/grads/${MODELO}/${MODELO}_${AREA}/invariantes/lista${AREA}_wrf`
	dir_modelo="${figuras}/${MODELO}_${AREA}_${HSIM}/internet"
	dir_montage="${figuras}/wrf_${AREA}_${HSIM}/internet"
	;;
esac


echo
echo " Removendo meteogramas antigos do ${MODELO} da ${AREA}."

rm ${dir_montage}/met_*_${MODELO}${AREA}_${HSIM}.gif 2> /dev/null


for local in ${lista};do

	echo
	echo " Montando meteogramas do ${MODELO} da ${AREA}."
	echo

	if [ ${MODELO} == "cosmo" ];then

		/usr/bin/montage ${dir_modelo}/${local}1.gif ${dir_modelo}/${local}2.gif \
		-geometry +1+1 -tile 2x1 -shadow ${dir_montage}/met_${local}_cosmo${AREA}_${HSIM}.gif 2> /dev/null
	else

                /usr/bin/montage ${dir_modelo}/${local}1.jpg ${dir_modelo}/${local}2.jpg \
                -geometry +1+1 -tile 2x1 -shadow ${dir_montage}/met_${local}_wrf${AREA}_${HSIM}.gif 2> /dev/null
	fi
done



