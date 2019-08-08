#!/bin/bash
#########################################################################
# Script para incluir o contour de 2,5m nos *.gs das areas SSE e NE WW3 #
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

txt_dir='/home/operador/grads/ww3_418/ww3'${MOD}'/scripts/txt'
ne_dir='/home/operador/grads/ww3_418/ww3'${MOD}'/ww3ne/gs'
sse_dir='/home/operador/grads/ww3_418/ww3'${MOD}'/ww3sse/gs'

echo

cd $sse_dir

echo ""
echo "-------------------------------------------------------"
echo "Iniciando modificações na área SSE do modelo WW3/${MOD}"
echo "-------------------------------------------------------"

sed -i '/set line 1 2 4/r '$txt_dir'/cont_2_5_1.txt' alturaon.gs

sed -i '54d' alturaon.gs

sed -i '/set strsiz 0.18/r '$txt_dir'/cont_2_5_3.txt' ondas2.gs

sed -i '50d' ondas2.gs

sed -i '/set strsiz 0.16/r '$txt_dir'/cont_2_5_2.txt' produto_internet.gs

sed -i '60d' produto_internet.gs

echo ""
echo "-----------------------------------------------------"
echo "Fim das modificações na área SSE do modelo WW3/${MOD}"
echo "-----------------------------------------------------"
echo ""

cd $ne_dir

echo ""
echo "-------------------------------------------------------"
echo "Iniciando modificações na área NE do modelo WW3/${MOD} "
echo "-------------------------------------------------------"

sed -i '/set line 1 2 4/r '$txt_dir'/cont_2_5_1.txt' alturaon.gs

sed -i '53d' alturaon.gs

sed -i '/set strsiz 0.18/r '$txt_dir'/cont_2_5_3.txt' ondas2.gs

sed -i '51d' ondas2.gs

sed -i '/set strsiz 0.16/r '$txt_dir'/cont_2_5_2.txt' produto_internet.gs

sed -i '62d' produto_internet.gs

echo ""
echo "-----------------------------------------------------"
echo "Fim das modificações na área NE do modelo WW3/${MOD} "
echo "-----------------------------------------------------"
echo ""

