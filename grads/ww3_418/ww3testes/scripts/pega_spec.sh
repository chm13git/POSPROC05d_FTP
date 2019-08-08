#!/bin/bash


specdir07='/home/operador/data/ww3/rodadas/CHM/web'
specdir31='/home/operador/data/ww3_dpns31/CHM/web'	
specdir05='/home/operador/grads/gif/ww3_espectros'
datas='/home/operador/datas'

specdir=$specdir07


cyc=$1

DATA=`cat $datas/datacorrente`$cyc

echo $DATA


ln -sf $specdir/'wave.'$DATA/plots/*.spec.* $specdir05$cyc




