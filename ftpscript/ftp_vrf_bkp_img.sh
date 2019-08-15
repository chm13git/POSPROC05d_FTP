#!/bin/bash -x
#########################################################################
### Este script g....                                                 ### 
###                                                                   ###
### Como executar:                                                    ###
### ./ftp_vrf_bkp_img.sh                                              ###  
###                                                                   ###
###                   CB-ME ALVES, JUL, 28th 2019 - DPN/SVC CH-13     ###
#########################################################################
#
path_cro=$HOME/ftpscript
#
#-----------------------------------------------------------------------#
# Criar a variável data                                                 #
#-----------------------------------------------------------------------#
#
asis=`date +'%Y'`
msis=`date +'%m'`
mmsis=`date +'%B'`
#dsis=`date --date="-1 day" +'%d'`
dsis=`date +'%d'`
hsis=`date +'%H'`
dtsis=$asis$msis$dsis

dias=-1
hori=$((dias*24))
dati=`echo $dtsis $hori | awk -f $path_cro/fwddatan.awk | awk '{ print substr($1,1,10)}'`
horai=`echo $dati | awk '{ print substr($1,9,2)}' `
diai=`echo $dati | awk '{ print substr($1,7,2)}'`

horf=$((dias*12))
datf=`echo $dtsis $horf | awk -f $path_cro/fwddatan.awk | awk '{ print substr($1,1,10)}'`
horaf=`echo $datf | awk '{ print substr($1,9,2)}' `

echo $dati
echo $diai
echo $horai
echo $horaf

datsis=$diai$msis$asis
echo $datsis

#
#-----------------------------------------------------------------------#
# PATHS para os arquivos de imagem dos modelos                          #
#-----------------------------------------------------------------------#
#
path_mod=$HOME/backup_produtos_modelagem/$asis/$mmsis/$datsis
path_scr=$HOME/ftpscript
path_out=$HOME/out_vrf/out_bkp_img/out_$mmsis
#
#-----------------------------------------------------------------------#
# Criando diretório para armazenamento mensal                           #
#-----------------------------------------------------------------------#
#
mkdir $path_out
#
#-----------------------------------------------------------------------#
# Define padrão da saida para o arquivo de texto                        #
#-----------------------------------------------------------------------#
#
header="%-8s %-14s %-2s %-6s %-2s %-6s\n"
format="%8s %-14s %2s %7s %2s %7s"
#
printf "$header" "DATA" "MODELOS" "00Z" "DIFF00" "12Z" "DIFF12"  > $path_out/vrf_bkp_img_$datsis.txt
#
#-----------------------------------------------------------------------#
# Verifica quantidade de imagens do modelo                              #
#-----------------------------------------------------------------------#
#
#-----------------------------------------------------------------------#
# COSMOSSE22ZOOM							#
#-----------------------------------------------------------------------#

path_cosmosse22z_00=$path_mod/cosmo_sse22zoom_$horai
dados_cosmosse22z_00=`ls $path_cosmosse22z_00/ | wc -l`
if [ $dados_cosmosse22z_00 -ne 389 ];then versse2z00="NO";else versse2z00="OK";fi
diff_cosmosse22z_00=$((dados_cosmosse22z_00-389))

path_cosmosse22z_12=$path_mod/cosmo_sse22zoom_$horaf
dados_cosmosse22z_12=`ls $path_cosmosse22z_12/ | wc -l`
if [ $dados_cosmosse22z_12 -ne 0 ];then versse2z12="NO";else versse2z12="OK";fi
diff_cosmosse22z_12=$((dados_cosmosse22z_12-0))

fig1=COSMOSSE22ZOOM

printf "$format" "$datsis" "$fig1" "$versse2z00" "$diff_cosmosse22z_00" "$versse2z12" "$diff_cosmosse22z_12" >> $path_out/vrf_bkp_img_$datsis.txt
printf "\n" >> $path_out/vrf_bkp_img_$datsis.txt

#-----------------------------------------------------------------------#
# COSMOSSE22							#
#-----------------------------------------------------------------------#

path_cosmosse22_00=$path_mod/cosmosse22_$horai
dados_cosmosse22_00=`ls $path_cosmosse22_00/ | wc -l`
path_cosmosse22_12=$path_mod/cosmosse22_$horaf
if [ $dados_cosmosse22_00 -ne 146 ];then versse200="NO";else versse200="OK";fi
diff_cosmosse22_00=$((dados_cosmosse22_00-146))

dados_cosmosse22_12=`ls $path_cosmosse22_12/ | wc -l`
if [ $dados_cosmosse22_12 -ne 0 ];then versse212="NO";else versse212="OK";fi
diff_cosmosse22_12=$((dados_cosmosse22_12-0))

fig2=COSMOSSE22 

printf "$format" "$datsis" "$fig2" "$versse200" "$diff_cosmosse22_00" "$versse212" "$diff_cosmosse22_12" >> $path_out/vrf_bkp_img_$datsis.txt
printf "\n" >> $path_out/vrf_bkp_img_$datsis.txt

#-----------------------------------------------------------------------#
# MCOSMOMET							#
#-----------------------------------------------------------------------#

path_mcosmomet_00=$path_mod/meteogramas_cosmomet$horai
dados_mcosmomet_00=`ls $path_mcosmomet_00/ | wc -l`
if [ $dados_mcosmomet_00 -ne 185 ];then vermcmet00="NO";else vermcmet00="OK";fi
diff_mcosmomet_00=$((dados_mcosmomet_00-185))

path_mcosmomet_12=$path_mod/meteogramas_cosmomet$horaf
dados_mcosmomet_12=`ls $path_mcosmomet_12/ | wc -l`
if [ $dados_mcosmomet_12 -ne 185 ];then vermcmet12="NO";else vermcmet12="OK";fi
diff_mcosmomet_12=$((dados_mcosmomet_12-185))

fig3=METEOGCOSMOMET

printf "$format" "$datsis" "$fig3" "$vermcmet00" "$diff_mcosmomet_00" "$vermcmet12" "$diff_mcosmomet_12" >> $path_out/vrf_bkp_img_$datsis.txt
printf "\n" >> $path_out/vrf_bkp_img_$datsis.txt

#-----------------------------------------------------------------------#
# MCOSMOANT							#
#-----------------------------------------------------------------------#

path_mcosmoant_00=$path_mod/meteogramas_cosmoant$horai
dados_mcosmoant_00=`ls $path_mcosmoant_00/ | wc -l`
if [ $dados_mcosmoant_00 -ne 49 ];then vermcant00="NO";else vermcant00="OK";fi
diff_mcosmoant_00=$((dados_mcosmoant_00-49))

path_mcosmoant_12=$path_mod/meteogramas_cosmoant$horaf
dados_mcosmoant_12=`ls $path_mcosmoant_12/ | wc -l`
if [ $dados_mcosmoant_12 -ne 49 ];then vermcant12="NO";else vermcant12="OK";fi
diff_mcosmoant_12=$((dados_mcosmoant_12-49))

fig4=METEOGCANT

printf "$format" "$datsis" "$fig4" "$vermcant00" "$diff_mcosmoant_00" "$vermcant12" "$diff_mcosmoant_12" >> $path_out/vrf_bkp_img_$datsis.txt
printf "\n" >> $path_out/vrf_bkp_img_$datsis.txt

#-----------------------------------------------------------------------#
# COSMOMET							#
#-----------------------------------------------------------------------#

path_cosmomet_00=$path_mod/cosmomet_$horai
dados_cosmomet_00=`ls $path_cosmomet_00/ | wc -l`
if [ $dados_cosmomet_00 -ne 1529 ];then vercmet00="NO";else vercmet00="OK";fi
diff_cosmomet_00=$((dados_cosmomet_00-1529))

path_cosmomet_12=$path_mod/cosmomet_$horaf
dados_cosmomet_12=`ls $path_cosmomet_12/ | wc -l`
if [ $dados_cosmomet_12 -ne 1529 ];then vercmet12="NO";else vercmet12="OK";fi
diff_cosmomet_12=$((dados_cosmomet_12-1529))

fig5=COSMOMET

printf "$format" "$datsis" "$fig5" "$vercmet00" "$diff_cosmomet_00" "$vercmet12" "$diff_cosmomet_12" >> $path_out/vrf_bkp_img_$datsis.txt
printf "\n" >> $path_out/vrf_bkp_img_$datsis.txt

#-----------------------------------------------------------------------#
# COSMOANT							#
#-----------------------------------------------------------------------#

path_cosmoant_00=$path_mod/cosmoant_$horai
dados_cosmoant_00=`ls $path_cosmoant_00/ | wc -l`
if [ $dados_cosmoant_00 -ne 493 ];then vercant00="NO";else vercant00="OK";fi
diff_cosmoant_00=$((dados_cosmoant_00-493))

path_cosmoant_12=$path_mod/cosmoant_$horaf
dados_cosmoant_12=`ls $path_cosmoant_12/ | wc -l`
if [ $dados_cosmoant_12 -ne 493 ];then vercant12="NO";else vercant12="OK";fi
diff_cosmoant_12=$((dados_cosmoant_12-493))

fig6=COSMOANT

printf "$format" "$datsis" "$fig6" "$vercant00" "$diff_cosmoant_00" "$vercant12" "$diff_cosmoant_12" >> $path_out/vrf_bkp_img_$datsis.txt
printf "\n" >> $path_out/vrf_bkp_img_$datsis.txt

#-----------------------------------------------------------------------#
# COSMOSSE							#
#-----------------------------------------------------------------------#

path_cosmosse_00=$path_mod/cosmosse_$horai
dados_cosmosse_00=`ls $path_cosmosse_00/ | wc -l`
if [ $dados_cosmosse_00 -ne 395 ];then vercsse00="NO";else vercsse00="OK";fi
diff_cosmosse_00=$((dados_cosmosse_00-395))

path_cosmosse_12=$path_mod/cosmosse_$horaf
dados_cosmosse_12=`ls $path_cosmosse_12/ | wc -l`
if [ $dados_cosmosse_12 -ne 395 ];then vercsse12="NO";else vercsse12="OK";fi
diff_cosmosse_12=$((dados_cosmosse_12-395))

fig7=COMSOSSE

printf "$format" "$datsis" "$fig7" "$vercsse00" "$diff_cosmosse_00" "$vercsse12" "$diff_cosmosse_12" >> $path_out/vrf_bkp_img_$datsis.txt
printf "\n" >> $path_out/vrf_bkp_img_$datsis.txt

#-----------------------------------------------------------------------#
# ICONANT							#
#-----------------------------------------------------------------------#

path_iconant_00=$path_mod/iconant$horai
dados_iconant_00=`ls $path_iconant_00/ | wc -l`
if [ $dados_iconant_00 -ne 86 ];then veriant00="NO";else veriant00="OK";fi
diff_iconant_00=$((dados_iconant_00-86))

path_iconant_12=$path_mod/iconant$horaf
dados_iconant_12=`ls $path_iconant_12/ | wc -l`
if [ $dados_iconant_12 -ne 86 ];then veriant12="NO";else veriant12="OK";fi
diff_iconant_12=$((dados_iconant_12-86))

fig8=ICONANT

printf "$format" "$datsis" "$fig8" "$veriant00" "$diff_iconant_00" "$veriant12" "$diff_iconant_12" >> $path_out/vrf_bkp_img_$datsis.txt
printf "\n" >> $path_out/vrf_bkp_img_$datsis.txt

#-----------------------------------------------------------------------#
# ICONATL							#
#-----------------------------------------------------------------------#

path_iconatl_00=$path_mod/iconatl$horai
dados_iconatl_00=`ls $path_iconatl_00/ | wc -l`
if [ $dados_iconatl_00 -ne 77 ];then veriatl00="NO";else veriatl00="OK";fi
diff_iconatl_00=$((dados_iconatl_00-77))

path_iconatl_12=$path_mod/iconatl$horaf
dados_iconatl_12=`ls $path_iconatl_12/ | wc -l`
if [ $dados_iconatl_12 -ne 77 ];then veriatl12="NO";else veriatl12="OK";fi
diff_iconatl_12=$((dados_iconatl_12-77))

fig9=ICONATL

printf "$format" "$datsis" "$fig9" "$veriatl00" "$diff_iconatl_00" "$veriatl12" "$diff_iconatl_12" >> $path_out/vrf_bkp_img_$datsis.txt
printf "\n" >> $path_out/vrf_bkp_img_$datsis.txt

#-----------------------------------------------------------------------#
# FAX							#
#-----------------------------------------------------------------------#

path_fax_00=$path_mod/fax$horai
dados_fax_00=`ls $path_fax_00/ | wc -l`
if [ $dados_fax_00 -ne 6 ];then verfax00="NO";else verfax00="OK";fi
diff_fax_00=$((dados_fax_00-6))

path_fax_12=$path_mod/fax$horaf
dados_fax_12=`ls $path_fax_12/ | wc -l`
if [ $dados_fax_12 -ne 6 ];then verfax12="NO";else verfax12="OK";fi
diff_fax_12=$((dados_fax_12-6))

fig10=FACSIMILE

printf "$format" "$datsis" "$fig10" "$verfax00" "$diff_fax_00" "$verfax12" "$diff_fax_12" >> $path_out/vrf_bkp_img_$datsis.txt
printf "\n" >> $path_out/vrf_bkp_img_$datsis.txt

#-----------------------------------------------------------------------#
# WRF							#
#-----------------------------------------------------------------------#

path_wrf_00=$path_mod/wrf_metarea5_$horai
dados_wrf_00=`ls $path_wrf_00/ | wc -l`
if [ $dados_wrf_00 -ne 1476 ];then verwrf00="NO";else verwrf00="OK";fi
diff_wrf_00=$((dados_wrf_00-1476))

path_wrf_12=$path_mod/wrf_metarea5_$horaf
dados_wrf_12=`ls $path_wrf_12/ | wc -l`
if [ $dados_wrf_12 -ne 1476 ];then verwrf12="NO";else verwrf12="OK";fi
diff_wrf_12=$((dados_wrf_12-1476))

fig11=WRF 

printf "$format" "$datsis" "$fig11" "$verwrf00" "$diff_wrf_00" "$verwrf12" "$diff_wrf_12" >> $path_out/vrf_bkp_img_$datsis.txt
printf "\n" >> $path_out/vrf_bkp_img_$datsis.txt

#-----------------------------------------------------------------------#
# WW3COSMO							#
#-----------------------------------------------------------------------#

path_ww3cosmo=$path_mod/ww3_418/ww3cosmo
path_wcww3met_00=$path_ww3cosmo/ww3met$horai
dados_wcww3met_00=`ls $path_wcww3met_00/ | wc -l`
if [ $dados_wcww3met_00 -ne 99 ];then verw3met00="NO";else verw3met00="OK";fi
diff_wcww3met_00=$((dados_wcww3met_00-99))

path_wcww3met_12=$path_ww3cosmo/ww3met$horaf
dados_wcww3met_12=`ls $path_wcww3met_12/ | wc -l`
if [ $dados_wcww3met_12 -ne 99 ];then verw3met12="NO";else verw3met12="OK";fi
diff_wcww3met_12=$((dados_wcww3met_12-99))

fig12=WW3MET

printf "$format" "$datsis" "$fig12" "$verw3met00" "$diff_wcww3met_00" "$verw3met12" "$diff_wcww3met_12" >> $path_out/vrf_bkp_img_$datsis.txt
printf "\n" >> $path_out/vrf_bkp_img_$datsis.txt

#-----------------------------------------------------------------------#
# WW3COSMOSSE							#
#-----------------------------------------------------------------------#

path_wcww3sse_00=$path_ww3cosmo/ww3sse$horai
dados_wcww3sse_00=`ls $path_wcww3sse_00/ | wc -l`
if [ $dados_wcww3sse_00 -ne 99 ];then verw3sse00="NO";else verw3sse00="OK";fi
diff_wcww3sse_00=$((dados_wcww3sse_00-99))

path_wcww3sse_12=$path_ww3cosmo/ww3sse$horaf
dados_wcww3sse_12=`ls $path_wcww3sse_12/ | wc -l`
if [ $dados_wcww3sse_12 -ne 99 ];then verw3sse12="NO";else verw3sse12="OK";fi
diff_wcww3sse_12=$((dados_wcww3sse_12-99))

fig13=WW3SSE

printf "$format" "$datsis" "$fig13" "$verw3sse00" "$diff_wcww3sse_00" "$verw3sse12" "$diff_wcww3sse_12" >> $path_out/vrf_bkp_img_$datsis.txt
printf "\n" >> $path_out/vrf_bkp_img_$datsis.txt

#-----------------------------------------------------------------------#
# WW3CONDOG							#
#-----------------------------------------------------------------------#

path_wcondog_00=$path_ww3cosmo/ondogramas$horai
dados_wcondog_00=`ls $path_wcondog_00/ | wc -l`
if [ $dados_wcondog_00 -ne 108 ];then verwcondog00="NO";else verwcondog00="OK";fi
diff_wcondog_00=$((dados_wcondog_00-108))

path_wcondog_12=$path_ww3cosmo/ondogramas$horaf
dados_wcondog_12=`ls $path_wcondog_12/ | wc -l`
if [ $dados_wcondog_12 -ne 108 ];then verwcondog12="NO";else verwcondog12="OK";fi
diff_wcondog_12=$((dados_wcondog_12-108))

fig14=WWONDOG

printf "$format" "$datsis" "$fig14" "$verwcondog00" "$diff_wcondog_00" "$verwcondog12" "$diff_wcondog_12" >> $path_out/vrf_bkp_img_$datsis.txt
printf "\n" >> $path_out/vrf_bkp_img_$datsis.txt

#-----------------------------------------------------------------------#
# WW3CONDOG							#
#-----------------------------------------------------------------------#

path_ww3icon=$path_mod/ww3_418/ww3icon
path_wiww3met_00=$path_ww3icon/ww3met$horai
dados_wiww3met_00=`ls $path_wiww3met_00/ | wc -l`
if [ $dados_wiww3met_00 -ne 123 ];then verwiww3met00="NO";else verwiww3met00="OK";fi
diff_wiww3met_00=$((dados_wiww3met_00-123))

path_wiww3met_12=$path_ww3icon/ww3met$horaf
dados_wiww3met_12=`ls $path_wiww3met_12/ | wc -l`
if [ $dados_wiww3met_12 -ne 123 ];then verwiww3met12="NO";else verwiww3met12="OK";fi
diff_wiww3met_12=$((dados_wiww3met_12-123))

fig15=WW3ICONMET

printf "$format" "$datsis" "$fig15" "$verwiww3met00" "$diff_wiww3met_00" "$verwiww3met12" "$diff_wiww3met_12" >> $path_out/vrf_bkp_img_$datsis.txt
printf "\n" >> $path_out/vrf_bkp_img_$datsis.txt

#-----------------------------------------------------------------------#
# WW3IONDOG							#
#-----------------------------------------------------------------------#

path_wiww3sse_00=$path_ww3icon/ww3sse$horai
dados_ww3isse_00=`ls $path_wiww3sse_00/ | wc -l`
if [ $dados_ww3isse_00 -ne 123 ];then verwiww3sse00="NO";else verwiww3sse00="OK";fi
diff_wiww3sse_00=$((dados_ww3isse_00-123))

path_wiww3sse_12=$path_ww3icon/ww3sse$horaf
dados_ww3isse_12=`ls $path_wiww3sse_12/ | wc -l`
if [ $dados_ww3isse_12 -ne 123 ];then verwiww3sse12="NO";else verwiww3sse12="OK";fi
diff_wiww3sse_12=$((dados_ww3isse_12-123))

fig16=WW3ICONSSE

printf "$format" "$datsis" "$fig16" "$verwiww3sse00" "$diff_wiww3sse_00" "$verwiww3sse12" "$diff_wiww3sse_12" >> $path_out/vrf_bkp_img_$datsis.txt
printf "\n" >> $path_out/vrf_bkp_img_$datsis.txt

#-----------------------------------------------------------------------#
# WW3GMET							#
#-----------------------------------------------------------------------#

path_ww3gfs=$path_mod/ww3_418/ww3gfs
path_wgww3met_00=$path_ww3gfs/ww3met$horai
dados_wgww3met_00=`ls $path_wgww3met_00/ | wc -l`
if [ $dados_wgww3met_00 -ne 123 ];then verwgww3met00="NO";else verwgww3met00="OK";fi
diff_wgww3met_00=$((dados_wgww3met_00-123))

path_wgww3met_12=$path_ww3gfs/ww3met$horaf
dados_wgww3met_12=`ls $path_wgww3met_12/ | wc -l`
if [ $dados_wgww3met_12 -ne 123 ];then verwgww3met12="NO";else verwgww3met12="OK";fi
diff_wgww3met_12=$((dados_wgww3met_12-123))

fig17=WW3GFSMET

printf "$format" "$datsis" "$fig17" "$verwgww3met00" "$diff_wgww3met_00" "$verwgww3met12" "$diff_wgww3met_12" >> $path_out/vrf_bkp_img_$datsis.txt
printf "\n" >> $path_out/vrf_bkp_img_$datsis.txt

#-----------------------------------------------------------------------#
# WW3GFSSSE							#
#-----------------------------------------------------------------------#

path_wgww3sse_00=$path_ww3gfs/ww3sse$horai
dados_ww3gfssse_00=`ls $path_wgww3sse_00/ | wc -l`
if [ $dados_ww3gfssse_00 -ne 123 ];then verwgww3sse00="NO";else verwgww3sse00="OK";fi
diff_wgww3sse_00=$((dados_ww3gfssse_00-123))

path_wgww3sse_12=$path_ww3gfs/ww3sse$horaf
dados_ww3gfssse_12=`ls $path_wgww3sse_12/ | wc -l`
if [ $dados_ww3gfssse_12 -ne 123 ];then verwgww3sse12="NO";else verwgww3sse12="OK";fi
diff_wgww3sse_12=$((dados_ww3gfssse_12-123))

fig18=WW3GFSSSE

printf "$format" "$datsis" "$fig18" "$verwgww3sse00" "$diff_wgww3sse_00" "$verwgww3sse12" "$diff_wgww3sse_12" >> $path_out/vrf_bkp_img_$datsis.txt
printf "\n" >> $path_out/vrf_bkp_img_$datsis.txt
#
#-----------------------------------------------------------------------#
# Arquivando e envia relatorio para 02bravo                             #
#-----------------------------------------------------------------------#
#
echo "Arquivo Gerado ->> "$path_out/vrf_bkp_img_$datsis.txt
scp $path_out/vrf_bkp_img_$datsis.txt supervisor@10.13.200.5:/home/supervisor/scripts/relatorio_bkp_modelos

exit
