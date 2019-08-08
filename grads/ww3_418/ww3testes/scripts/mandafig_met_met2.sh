#!/bin/sh
#
# DPNS05
# script para mudar o nome das figuras do MET com GFS  
# para o MET2 com HRM e copia-las para o diretorio 

if [ $# -ne 1 ]
then
echo "                                                  "
echo " Voce deve entrar com o horario de referencia HH  "
echo "                                                  "
exit 12
fi

cyc=$1
gifdir=/home/operador/grads/gif

ii=0
passo=03

while [ $ii -le 78 ] 
do

   if [ $ii -lt 10 ]; then

    
     cp  $gifdir/ww3met$cyc/ondas_met5_'00'$ii.png        $gifdir/ww3met2$cyc/ondas_methrm_'0'$ii.png
     cp  $gifdir/ww3met$cyc/ondas_met5_'00'$ii.gif        $gifdir/ww3met2$cyc/ondas_methrm_'0'$ii.gif
     cp  $gifdir/ww3met$cyc/ondas_vento_met5_'00'$ii.png  $gifdir/ww3met2$cyc/ondas_vento_methrm_'0'$ii.png
     cp  $gifdir/ww3met$cyc/ondas_vento_met5_'00'$ii.gif  $gifdir/ww3met2$cyc/ondas_vento_methrm_'0'$ii.gif
     cp  $gifdir/ww3met$cyc/periondas_met5_'00'$ii.png    $gifdir/ww3met2$cyc/periondas_methrm_'0'$ii.png
     cp  $gifdir/ww3met$cyc/periondas_met5_'00'$ii.gif    $gifdir/ww3met2$cyc/periondas_methrm_'0'$ii.gif
   
   else

     cp  $gifdir/ww3met$cyc/ondas_met5_'0'$ii.png         $gifdir/ww3met2$cyc/ondas_methrm_$ii.png
     cp  $gifdir/ww3met$cyc/ondas_met5_'0'$ii.gif         $gifdir/ww3met2$cyc/ondas_methrm_$ii.gif
     cp  $gifdir/ww3met$cyc/ondas_vento_met5_'0'$ii.png   $gifdir/ww3met2$cyc/ondas_vento_methrm_$ii.png
     cp  $gifdir/ww3met$cyc/ondas_vento_met5_'0'$ii.gif   $gifdir/ww3met2$cyc/ondas_vento_methrm_$ii.gif
     cp  $gifdir/ww3met$cyc/periondas_met5_'0'$ii.png     $gifdir/ww3met2$cyc/periondas_methrm_$ii.png
     cp  $gifdir/ww3met$cyc/periondas_met5_'0'$ii.gif     $gifdir/ww3met2$cyc/periondas_methrm_$ii.gif

   fi

    ii=`expr $ii + $passo`
 
done

#FIM











