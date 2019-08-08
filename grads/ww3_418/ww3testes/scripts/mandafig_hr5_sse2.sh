#!/bin/sh
#
# DPNS05
# script para mudar o nome das figuras do HR5 com GFS 
# para o SSE2 com HRM e copia-las para o diretorio 

if [ $# -ne 1 ]
then
echo "                                                 " 
echo " Voce deve entrar com o horario de referencia HH "
echo "                                                 "
exit 12
fi


cyc=$1
gifdir=/home/operador/grads/gif

#
# mudando para o diretorio do ww3hr5

cd $gifdir/ww3hr5$cyc/


ii=0
passo=03

while [ $ii -le 78 ] 
do

   if [ $ii -lt 10 ]; then
      
     cp $gifdir/ww3hr5$cyc/ondas_hr5_'00'$ii.png       $gifdir/ww3sse2$cyc/ondas_sse2_'0'$ii.png
     cp $gifdir/ww3hr5$cyc/ondas_hr5_'00'$ii.gif       $gifdir/ww3sse2$cyc/ondas_sse2_'0'$ii.gif
     cp $gifdir/ww3hr5$cyc/periondas_hr5_'00'$ii.png   $gifdir/ww3sse2$cyc/periondas_sse2_'0'$ii.png
     cp $gifdir/ww3hr5$cyc/periondas_hr5_'00'$ii.gif   $gifdir/ww3sse2$cyc/periondas_sse2_'0'$ii.gif
     cp $gifdir/ww3hr5$cyc/vento_'00'$ii.png           $gifdir/ww3sse2$cyc/vento_'0'$ii.png
     cp $gifdir/ww3hr5$cyc/vento_'00'$ii.gif           $gifdir/ww3sse2$cyc/vento_'0'$ii.gif
     cp $gifdir/ww3hr5$cyc/ondas_vento_'00'$ii.png     $gifdir/ww3sse2$cyc/ondas_vento_'0'$ii.png
     cp $gifdir/ww3hr5$cyc/ondas_vento_'00'$ii.gif     $gifdir/ww3sse2$cyc/ondas_vento_'0'$ii.gif
   
   else
 
     cp $gifdir/ww3hr5$cyc/ondas_hr5_'0'$ii.png        $gifdir/ww3sse2$cyc/ondas_sse2_$ii.png
     cp $gifdir/ww3hr5$cyc/ondas_hr5_'0'$ii.gif        $gifdir/ww3sse2$cyc/ondas_sse2_$ii.gif
     cp $gifdir/ww3hr5$cyc/periondas_hr5_'0'$ii.png    $gifdir/ww3sse2$cyc/periondas_sse2_$ii.png
     cp $gifdir/ww3hr5$cyc/periondas_hr5_'0'$ii.gif    $gifdir/ww3sse2$cyc/periondas_sse2_$ii.gif
     cp $gifdir/ww3hr5$cyc/vento_'0'$ii.png            $gifdir/ww3sse2$cyc/vento_$ii.png 
     cp $gifdir/ww3hr5$cyc/vento_'0'$ii.gif            $gifdir/ww3sse2$cyc/vento_$ii.gif 
     cp $gifdir/ww3hr5$cyc/ondas_vento_'0'$ii.png      $gifdir/ww3sse2$cyc/ondas_vento_$ii.png
     cp $gifdir/ww3hr5$cyc/ondas_vento_'0'$ii.gif      $gifdir/ww3sse2$cyc/ondas_vento_$ii.gif

   fi


    ii=`expr $ii + $passo`
 
done

#FIM











