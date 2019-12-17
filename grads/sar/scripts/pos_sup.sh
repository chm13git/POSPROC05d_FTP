#!/bin/bash
#


echo 'Script para concatenar arquivos do CHM - rodadas operacionais do HYCOM'
echo 'e salvar apenas as variaveis necessarias.'
echo 'de o comando da seguinte forma:'
echo './pos_sup.sh AAAAMMDD'


export AMD=$1
export dj=`(/bin/date --date=${AMD} +%j)`
echo 'dj = '${dj}
export ano=$(/bin/date --date=${AMD} +%Y)



dir='/data/operador/previsao/hycom_2_2/output/Previsao_1_12_nova/Ncdf/'${AMD}
cd $dir
arq3zt=${AMD}'_previsao_3zt.des'
arq3zu=${AMD}'_previsao_3zu.des'
arqfsd=${AMD}'_previsao_fsd.des'
arqbat='/data/operador/previsao/hycom_2_2/proc/ATLo0.08/expt_03.0/batimetria_hycom112.nc'
rm -f $arq3zt
rm -f $arq3zu
rm -f $arqfsd
rm -f temporario.jnl
rm -f hycom11gn_sup_'${AMD}'.nc
cp -f /home/operador/concatena_nc/make_des .

./make_des archv.*3zt.nc > $arq3zt # TSM e Salin (sup)
./make_des archv.*3zu.nc > $arq3zu # U,V corrente (sup)
./make_des archv.*fsd.nc > $arqfsd # SSH

echo 'set mem/size=1500' > temporario.jnl
echo 'use "'$arq3zt'"' >> temporario.jnl
echo 'use "'$arq3zu'"' >> temporario.jnl
echo 'use "'$arqfsd'"' >> temporario.jnl
echo 'use "'$arqbat'"' >> temporario.jnl
echo 'save/clobber/ncformat=4/deflate=1/shuffle=1/file="hycom112gn_sup_'${AMD}'.nc" DATE[d=3], BATHYMETRY[d=4], SSH[d=3], U[d=2,k=1],V[d=2,k=1], TEMPERATURE[d=1,k=1], SALINITY[d=1,k=1]' >> temporario.jnl


cd $dir
pwd
ferret -gif -nojnl << eof
go temporario.jnl
exit
eof

date

exit
