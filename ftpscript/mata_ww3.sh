#!/bin/bash -x
####################################################
#  Rotina adaptada do mata.sh das rodadas do COSMO #
#                                                  #
# Este script mata processamentos obsoletos do WW3 #
# em cada nó da DPNS31                             #
#                                                  #
# AGO/2016                                         #
# 1T(RM2-T) Andressa D'Agostini                    #
####################################################                             

kill -9 `ps -ef | grep ww3 | awk ' {print $2} '`
