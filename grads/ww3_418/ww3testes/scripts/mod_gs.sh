#!/bin/bash
#########################################################################
# Script para realizar modificações nos '*.gs' das areas NE e SSE do WW3#
# 2T(RM2-T)ANDRESSA D'AGOSTINI                                          #
# FEV2016                                                               #
#########################################################################

if [ $# -lt 1 ];then
   echo ""
   echo "--------------------------------------"
   echo " Inserir o modelo: cosmo, icon ou gfs "
   echo "--------------------------------------"
   echo ""
   exit 12
fi

MOD=$1

txt_dir='/home/operador/grads/ww3_418/ww3'${MOD}'/scripts'
ne_dir='/home/operador/grads/ww3_418/ww3'${MOD}'/ww3ne/gs'	
sse_dir='/home/operador/grads/ww3_418/ww3'${MOD}'/ww3sse/gs'

echo

cd $sse_dir

echo ""
echo "-------------------------------------------------------"
echo "Iniciando modificações na área SSE do modelo WW3/${MOD}"
echo "-------------------------------------------------------"

for arq in `ls *.gs`
do
cat $arq | sed -e 's/draw line 1.32 1.77 2.15 1.01/draw line 1.32 2.98 3 2.12/' > raw
cat raw | sed -e 's/draw line 3.24 4.39 5.73 3.02/draw line 3 2.12 7.69 7.75/' >$arq
cat $arq | sed -e 's/draw line 3.24 4.39 6.27 7.40/draw line 6.12 5.88 4.87 6.99/' > raw
cat raw | sed -e 's/draw line 6.27 7.40 7.99 5.77/draw line 4.87 6.99 2.74 4.90/' >$arq
cat $arq | sed -e 's/draw line 4.00 1.01 7.99 5.77/draw line 2.74 4.90 4.56 4.00/' > raw
cat raw | sed -e 's/(-35,-18,305,322)/(-38,-16,304,328)/' > $arq
done 

sed -i '/draw line 2.74 4.90 4.56 4.00/r '$txt_dir'/draw_line2.txt' vento.gs
sed -i '/draw line 2.74 4.90 4.56 4.00/r '$txt_dir'/draw_line2.txt' produto_internet.gs
sed -i '/draw line 2.74 4.90 4.56 4.00/r '$txt_dir'/draw_line2.txt' periodon.gs
sed -i '/draw line 2.74 4.90 4.56 4.00/r '$txt_dir'/draw_line2.txt' ondas2.gs
sed -i '/draw line 2.74 4.90 4.56 4.00/r '$txt_dir'/draw_line2.txt' alturaon.gs

echo ""
echo "-----------------------------------------------------"
echo "Fim das modificações na área SSE do modelo WW3/${MOD}"
echo "-----------------------------------------------------"
echo ""

cd $ne_dir

echo ""
echo "-------------------------------------------------------"
echo "Iniciando modificações na área NE do modelo WW3/${MOD}"
echo "-------------------------------------------------------"
echo ""

for arq in `ls *.gs`
do
cat $arq | sed -e 's/(-22,5,315,337)/(-21,7,308,332)/' > raw
cat raw > $arq
done

sed -i '/d mag(uwnd,vwnd)/r '$txt_dir'/draw_line.txt' vento.gs

sed -i '/set strsiz 0.18/r '$txt_dir'/draw_line.txt' periodon.gs

sed -i '/d smth9(smth9(hs))/r '$txt_dir'/draw_line.txt' alturaon.gs

sed -i '/set strsiz 0.18/r '$txt_dir'/draw_line.txt' ondas2.gs

sed -i '/set strsiz 0.16/r '$txt_dir'/draw_line.txt' produto_internet.gs

sed -i '/d smth9(smth9(t01))/r '$txt_dir'/draw_line.txt' produto_internet.gs

echo "-----------------------------------------------------"
echo "Fim das modificações na área NE do modelo WW3/${MOD}"
echo "-----------------------------------------------------"
echo ""

