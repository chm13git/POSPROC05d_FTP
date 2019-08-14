#!/bin/bash -x

AREA=$1
HH=$2
prog=$3

if [ $# -ne 3 ]
then
echo "Voce deve entrar com a area com o horario de referencia e com o prognostico"
exit 12
fi

case $AREA in

met)
AREA2="met5"
HSTOP=${prog}
;;

ant)
AREA2="ant"
HSTOP=${prog}
;;

met20)
AREA2="met20"
;;

esac

dadossaida=/home/operador/areps
dadosdir=/home/operador/grads/cosmo/cosmomet/dados${HH}
datahoje=`cat /home/operador/datas/datacorrente${HH}`
DIG='0'


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

#cdo -f grb ml2hlx,2000,1750,1500,1000,500,350,300,250,200,150,100,50 ${dadosdir}/cosmo_${AREA2}_${HH}_${datahoje}${HORA} ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}z.grb.lev 
#cdo -f grb intlevel,5000,3000,2000,1750,1500,1000,500,350,300,250,200,150,100,50 ${dadosdir}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}z ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}z.grb.lev
 cdo -f grb intlevel,1000,975,950,900,850,800,750,700,600,500,400,300,250 ${dadosdir}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p.grb.lev
 cdo -f grb intlevel,5000,3000,2000,1750,1500,1250,1000,850,750,600,500 ${dadosdir}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}z ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}z.grb.lev
 cdo -f nc sellonlatbox,-29.35,-29.3,-20.5,-20.55 ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p.grb.lev ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p_poit
 cdo -f nc sellonlatbox,-29.35,-29.3,-20.5,-20.55 ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}z.grb.lev ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}z_poit
cdo -f nc invertlev ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p_poit ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p_poit_invert
# cp -p ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p_poit ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p_poit_invert
 cdo -f nc invertlev ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}z_poit ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}z_poit_invert
 cdo -f nc splitname ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p_poit_invert ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p_poit_
 cdo -f nc splitname ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}z_poit_invert ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}z_poit_
#cdo -Q splitname ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}z_poit  ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}z_poit_
#cdo -f nc splitcode ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}z_poit  ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}z_poit_
 
 cdo -f nc divc,100 ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}z_poit_var1.nc ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}z_poit_var1_hpa.nc
 cdo -f nc subc,273 ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p_poit_var11.nc ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p_poit_var11_C.nc

 cdo -f nc mulc,-1 ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p_poit_var52.nc ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p_poit_var52-RH.nc
 cdo -f nc addc,100 ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p_poit_var52-RH.nc ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p_poit_var52_100-RH.nc
 cdo -f nc divc,5 ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p_poit_var52_100-RH.nc ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p_poit_var52_100-RHdiv5.nc
 cdo -f nc mulc,-1 ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p_poit_var52_100-RHdiv5.nc ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p_poit_var52_-100-RHdiv5.nc
 cdo -f nc add ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p_poit_var11_C.nc ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p_poit_var52_-100-RHdiv5.nc ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p_poit_var17_C.nc

 cdo -f nc subc,0 ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p_poit_var52.nc ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p_poit_var52_UR.nc

 ncdump ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}z_poit_var1_hpa.nc > ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}z_poit_var1.txt
 ncdump ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p_poit_var11_C.nc > ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p_poit_var11.txt
 ncdump ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p_poit_var17_C.nc > ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p_poit_var17.txt
 ncdump ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p_poit_var52_UR.nc > ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p_poit_var52.txt

 sed '1,55 d' ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}z_poit_var1.txt > ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}z_poit_var1_final
 sed '1,55 d' ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p_poit_var11.txt > ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p_poit_var11_final
 sed '1,59 d' ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p_poit_var17.txt > ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p_poit_var17_final
 sed '1,55 d' ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p_poit_var52.txt > ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p_poit_var52_final

 sed '12 d' ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}z_poit_var1_final > ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}z_poit_var1_fim
 sed '15 d' ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p_poit_var11_final > ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p_poit_var11_fim
 sed '15 d' ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p_poit_var17_final > ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p_poit_var17_fim
 sed '15 d' ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p_poit_var52_final > ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p_poit_var52_fim

 cat ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}z_poit_var1_fim | sed 's/=//g' > ${dadossaida}/${HH}_${datahoje}${HORA}z_poit_var1
 cat ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p_poit_var11_fim | sed 's/=//g' > ${dadossaida}/${HH}_${datahoje}${HORA}p_poit_var11
 cat ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p_poit_var17_fim | sed 's/=//g' > ${dadossaida}/${HH}_${datahoje}${HORA}p_poit_var17
 cat ${dadossaida}/cosmo_${AREA2}_${HH}_${datahoje}${HORA}p_poit_var52_fim | sed 's/=//g' > ${dadossaida}/${HH}_${datahoje}${HORA}p_poit_var52
 
 cat ${dadossaida}/${HH}_${datahoje}${HORA}z_poit_var1 | sed 's/,//g' > ${dadossaida}/${HH}_${datahoje}${HORA}z_var1_col
 cat ${dadossaida}/${HH}_${datahoje}${HORA}p_poit_var11 | sed 's/,//g' > ${dadossaida}/${HH}_${datahoje}${HORA}p_var11_col
 cat ${dadossaida}/${HH}_${datahoje}${HORA}p_poit_var17 | sed 's/,//g' > ${dadossaida}/${HH}_${datahoje}${HORA}p_var17_col
 cat ${dadossaida}/${HH}_${datahoje}${HORA}p_poit_var52 | sed 's/,//g' > ${dadossaida}/${HH}_${datahoje}${HORA}p_var52_col
 

 cat ${dadossaida}/${HH}_${datahoje}${HORA}z_var1_col | sed 's/;//g' > ${dadossaida}/${HH}_${datahoje}${HORA}z_var1 
 cat ${dadossaida}/${HH}_${datahoje}${HORA}z_var1 | sed 's/var1/pressao(hPa)/g' > ${dadossaida}/${HH}_${datahoje}${HORA}z_pressao
 cat ${dadossaida}/${HH}_${datahoje}${HORA}p_var11_col | sed 's/;//g' > ${dadossaida}/${HH}_${datahoje}${HORA}p_var11
 cat ${dadossaida}/${HH}_${datahoje}${HORA}p_var11 | sed 's/var11/T(C)/g' > ${dadossaida}/${HH}_${datahoje}${HORA}p_temp
 cat ${dadossaida}/${HH}_${datahoje}${HORA}p_var17_col | sed 's/;//g' > ${dadossaida}/${HH}_${datahoje}${HORA}p_var17
 cat ${dadossaida}/${HH}_${datahoje}${HORA}p_var17 | sed 's/var11/Td(C)/g' >  ${dadossaida}/${HH}_${datahoje}${HORA}p_tempd
 cat ${dadossaida}/${HH}_${datahoje}${HORA}p_var52_col | sed 's/;//g' > ${dadossaida}/${HH}_${datahoje}${HORA}p_var52
 cat ${dadossaida}/${HH}_${datahoje}${HORA}p_var52 | sed 's/var52/UR(%)/g' > ${dadossaida}/${HH}_${datahoje}${HORA}p_UR

 paste /home/operador/areps/niveis_z ${dadossaida}/${HH}_${datahoje}${HORA}z_pressao ${dadossaida}/${HH}_${datahoje}${HORA}p_temp ${dadossaida}/${HH}_${datahoje}${HORA}p_UR ${dadossaida}/${HH}_${datahoje}${HORA}p_tempd > /home/operador/grads/gif/cosmomet_${HH}/areps/${HH}_${datahoje}${HORA}p_areps

# rm ${dadossaida}/*grb.lev ${dadossaida}/*_poit ${dadossaida}/*.txt ${dadossaida}/*final ${dadossaida}/*fim ${dadossaida}/*poit_var* ${dadossaida}/*col* ${dadossaida}/*var* ${dadossaida}/*.nc ${dadossaida}/*temp  ${dadossaida}/*UR ${dadossaida}/*invert ${dadossaida}/*tempd

