#!/bin/bash

HH=$1
HORA=0

while [ $HORA -le 96 ]
do

./cdo_areps.sh met ${HH} $HORA

HORA=$[$HORA+24]

done
