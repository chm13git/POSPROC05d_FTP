#!/bin/bash
#########################################################################
# Script para incluir o contour de 2,5m nos '*.gs' na area MET  do WW3  #
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
met_dir='/home/operador/grads/ww3_418/ww3'${MOD}'/ww3met/gs'	

echo

cd $met_dir

echo ""
echo "-------------------------------------------------------"
echo "Iniciando modificações na área MET do modelo WW3/${MOD}"
echo "-------------------------------------------------------"

sed -i '43d' alturaon.gs

sed -i '/set gxout contour/r '$txt_dir'/set_levs.txt' alturaon.gs

sed -i '/d skip(cos(dir),15);skip(sin(dir),15)/r '$txt_dir'/cont_2_5.txt' alturaon.gs


sed -i '/set gxout contour/r '$txt_dir'/set_levs.txt' alturaon2.gs

sed -i '/d skip(uwnd,15,15);vwnd/r '$txt_dir'/cont_2_5.txt' alturaon2.gs


sed -i '86d' produto_internet.gs

sed -i '/set line 1 2 4/r '$txt_dir'/cont_2_5.txt' produto_internet.gs


echo ""
echo "-----------------------------------------------------"
echo "Fim das modificações na área MET do modelo WW3/${MOD}"
echo "-----------------------------------------------------"
echo ""
