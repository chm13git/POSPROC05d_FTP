#!/bin/bash -xv
############################################################################
# Script que baixa arquivos de previsao climatica 
# do GFS (grade 0.25 graus) no formato .grib2
# 
# Entrada - chamada de data do sistema
# Saida - salva os arquivos com os quais serao geradas 
# as forcantes necessarias para rodar o modelo WRF no 
# diretorio /data/operador/GFS/dataHH
# 
# - prate - precipitacao
# - tmp - temperatura da atmosfera a 2m
# - spfh - umidade especifica
# - nlwrs - radiacao de onda longa
# - nswrs - radiacao de onda curta
# - uflx - corrente meridional
# - vflx - corrente setentrional
# - ugrd - componente U vento
# - vgrd - componente V vento
#############################################################################

##### NAO ESQUECER DE ALTERAR O CAMINHO DO WGRIB2 CONFORME A MAQUINA ###########

#amd=$1
HH=$1

DD=`date +"%d"`
MM=`date +"%m"`
YY=`date +"%Y"`
amd=$YY$MM$DD

echo "Operacionalizacao de download do GFS - em $DD/$MM/$YY"

# Definindo local para armazenar os dados baixados
SCRIPT_DIR=/home/wrfoperador/scripts/wget_gfs0.25
GRIB_DIR=/data1/GFS/data${HH}

#mkdir ${GRIB_DIR}/$amd
#chmod 755 ${GRIB_DIR}/$amd
cd ${GRIB_DIR}

# Removendo arquivos antigos

rm ${GRIB_DIR}/gfs.t* ${GRIB_DIR}/wget*

#
passo=03
hr=00
#

while [ $hr -le 99 ]
do

cat > wget$hr.sh << EOF

hr=$hr
FLAG=1
amd=$amd
ZZ=$HH
hoje=\${amd}\${ZZ}
#Roda no nó computacional (está rodando só que o comando continua listado no ps x) 
#ssh  r1i1n1 << end_ssh
while [ \$FLAG -ne 0 ];do

GFS_FLAG=0
#   wget -c -O ${GRIB_DIR}/gfs.t\${ZZ}z.pgrb2.0p25.f0\${hr} ftp://ftpprd.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs.\${amd}/\${ZZ}/gfs.t\${ZZ}z.pgrb2.0p25.f0\${hr} 
   wget -c --tries=1 -O ${GRIB_DIR}/gfs.t\${ZZ}z.pgrb2.0p25.f0\${hr} https://para.nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/para/gfs.\${amd}\${ZZ}/gfs.t\${ZZ}z.pgrb2.0p25.f0\${hr} 
   campo=\$(/bin/wgrib2 ${GRIB_DIR}/gfs.t\${ZZ}z.pgrb2.0p25.f0\${hr} | wc -l)  ##mostra o tamanho dos arquivos

   if [ \$hr -eq 00 ]; then
      valor=354
   else
      valor=417
   fi

   if [ \$campo -ge \${valor} ]; then
      echo Arquivo gfs.t\${ZZ}z.pgrb2.0p25.f0\${hr} completo
   else
      echo Arquivo gfs.t\${ZZ}z.pgrb2.0p25.f0\${hr} esta incompleto
      GFS_FLAG=1
      continue
   fi

#   Verifica a data do arquivo

   datafile=\$(/bin/wgrib2 ${GRIB_DIR}/gfs.t\${ZZ}z.pgrb2.0p25.f0\${hr} -d 1 -s | cut -d':' -f3| cut -d'=' -f2)
   if [ \$datafile -eq \$hoje ]; then
       echo arquivo gfs.t\${ZZ}z.pgrb2.0p25.f0\${hr} eh de HOJE
   else
      echo arquivo gfs.t\${ZZ}z.pgrb2.0p25.f0\${hr} NAO eh de hoje
      GFS_FLAG=1
      continue
   fi
   if [ \$GFS_FLAG -eq 0 ]; then
      FLAG=0
   fi
done
#end_ssh

EOF

chmod 755  wget$hr.sh /home/wrfoperador/scripts


sh wget$hr.sh  & 


    hr=`expr $hr + $passo`
   if [ $hr -lt 10 ] 
      then hr=0$hr
   fi

done;

passo=03
hr=102

while [ $hr -le 120 ]
do

cat > wget$hr.sh << EOF

hr=$hr
FLAG=1
amd=$amd
ZZ=$HH
hoje=\${amd}\${ZZ}
#Roda no nó computacional (está rodando só que o comando continua listado no ps x) 
#ssh  r1i1n1 << end_ssh
while [ \$FLAG -ne 0 ];do
   
   GFS_FLAG=0
#   wget -c -O ${GRIB_DIR}/gfs.t\${ZZ}z.pgrb2.0p25.f\${hr} ftp://ftpprd.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs.\${amd}/\${ZZ}/gfs.t\${ZZ}z.pgrb2.0p25.f\${hr} 
   wget -c --tries=1 -O ${GRIB_DIR}/gfs.t\${ZZ}z.pgrb2.0p25.f\${hr} https://para.nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/para/gfs.\${amd}\${ZZ}/gfs.t\${ZZ}z.pgrb2.0p25.f\${hr} 
   campo=\$(/bin/wgrib2 ${GRIB_DIR}/gfs.t\${ZZ}z.pgrb2.0p25.f\${hr} | wc -l)  ##mostra o tamanho dos arquivos

   if [ \$hr -eq 00 ]; then
      valor=300
   else
      valor=360
   fi
   if [ \$campo -ge \${valor} ]; then
      echo Arquivo gfs.t\${ZZ}z.pgrb2.0p25.f\${hr} completo
   else
      echo Arquivo gfs.t\${ZZ}z.pgrb2.0p25.f\${hr} esta incompleto
      GFS_FLAG=1
      continue
   fi

#   Verifica a data do arquivo

   datafile=\$(/bin/wgrib2 ${GRIB_DIR}/gfs.t\${ZZ}z.pgrb2.0p25.f\${hr} -d 1 -s | cut -d':' -f3| cut -d'=' -f2)
   if [ \$datafile -eq \$hoje ]; then
       echo arquivo gfs.t\${ZZ}z.pgrb2.0p25.f\${hr} eh de HOJE
   else
      echo arquivo gfs.t\${ZZ}z.pgrb2.0p25.f\${hr} NAO eh de hoje
      GFS_FLAG=1
      continue
   fi
   if [ \$GFS_FLAG -eq 0 ]; then
      FLAG=0
   fi
done
#end_ssh

EOF

chmod 755  wget$hr.sh /home/wrfoperador/scripts


sh wget$hr.sh  & 


    hr=`expr $hr + $passo`
   if [ $hr -lt 10 ] 
      then hr=0$hr
   fi

done;

echo |Mail -s 'Executando download dos arquivos do GFS/0.25!!' alexandre.gadelha@smm.mil.br

exit
