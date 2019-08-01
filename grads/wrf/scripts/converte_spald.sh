#!/bin/bash

# Script para alterar o nome dos cortes verticis que vãpara a paginas spald##


HH=$1


# Diretorio alvo onde estao os arquivos a serem
# copiados.

FIGWRF=/home/operador/grads/gif/wrf_metarea5_${HH}
SPALD=/home/operador/grads/gif/asafixa${HH}/spald


# Lista de variaveis que vao para a internet e que
# precisam ter seus digitos alterados.

listaspald="rio ardocabo spald foz_iguacu sjcampos cabofrio riogde ladario bauru londrina"

cd ${FIGWRF}


# Faz um FOR no nome das variaveis

for var in ${listaspald};do


cp cvert+neb_${var}.gif wrf_cvert+neb_${var}.gif
cp cvert+neb_${var}.png wrf_cvert+neb_${var}.png


#for var2 in ${form};do

			echo " Arquivos Renomeados com Sucesso."
                        echo
                        echo
                        echo
                        echo
                        echo
                        echo
                        echo
                        echo
                        echo
                        echo
                        echo " Começdo a Trasnferencia para pasta ${SPALD}"


mv wrf_cvert+neb_${var}.gif /${SPALD}
mv wrf_cvert+neb_${var}.png /${SPALD}

#mv met_spaldeia_rj_1.png /${SPALD}
#mv met_spaldeia_rj_1.gif /${SPALD}
#mv met_spaldeia_rj_2.gif /${SPALD}
#mv met_spaldeia_rj_2.png /${SPALD}

done

listameteospald="arraial_rj cabofrio_rj spaldeia_rj sjcampos_sp figuacu_pr bauru_sp londrina_pr" 

cd ${FIGWRF} 
 
for var in ${listameteospald};do

cp met_${var}_1.gif /${SPALD}
cp met_${var}_1.png /${SPALD}
cp met_${var}_2.gif /${SPALD}
cp met_${var}_2.png /${SPALD}
cp tempmar*         /${SPALD}

echo " Transferido os meteogramas para pasta ${SPALD}"

done

cd ${SPALD} 

#for var in ${lista};do

#mv wrf_cvert+neb_riogde.gif wrf_cvert+neb_riogde.gif
#mv wrf_cvert+neb_riogde.pgn wrf_cvert+neb_riogde.png
#mv wrf_cvert+neb_ladario.gif wrf_cvert+neb_ladar.gif
#mv wrf_cvert+neb_ladario.png wrf_cvert+neb_ladar.png
mv tempmar.gif wrf_tempmar.gif
mv tempmar.png wrf_tempmar.png
echo " Transferido os tempemar para pasta ${SPALD}"















