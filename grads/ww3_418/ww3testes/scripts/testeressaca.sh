#!/bin/bash


DATA=`date -d '-0 day' '+%d%b'`
DATA1=`date -d '-1 day' '+%d%b'`

#/home/operador/grads/ww3_418/ww3testes/scripts/roda.sh met 00 120
#/home/operador/grads/ww3_418/ww3testes/scripts/roda.sh sse 00 120
#cd /home/operador/grads/gif/ww3_418/ww3testes/transfer
#rm *${DATA1}*

#cd /home/operador/grads/gif/ww3_418/ww3testes/transfer/animation
#rm *${DATA1}*

AREA="sse"

cd /home/operador/grads/gif/ww3_418/ww3testes/ww3${AREA}00

convert -delay 20 -loop 0 periopeak*.gif peakperiod_anim_${DATA}_${AREA}.gif
convert -delay 20 -loop 0 enflux_*.gif enflux_anim_${DATA}_${AREA}.gif
convert -delay 20 -loop 0 ph00_*.gif ph00_anim_${DATA}_${AREA}.gif
convert -delay 20 -loop 0 ph01_*.gif ph01_anim_${DATA}_${AREA}.gif
convert -delay 20 -loop 0 hs0tp0_*.gif hs0tp0_anim_${DATA}_${AREA}.gif
convert -delay 20 -loop 0 hs1tp1_*.gif hs1tp1_anim_${DATA}_${AREA}.gif
convert -delay 20 -loop 0 ptp00_*.gif ptp00_anim_${DATA}_${AREA}.gif
convert -delay 20 -loop 0 ptp01_*.gif ptp01_anim_${DATA}_${AREA}.gif


mv peakperiod_anim_${DATA}_${AREA}.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/animation
mv enflux_anim_${DATA}_${AREA}.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/animation
mv ph00_anim_${DATA}_${AREA}.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/animation
mv ph01_anim_${DATA}_${AREA}.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/animation
mv hs0tp0_anim_${DATA}_${AREA}.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/animation
mv hs1tp1_anim_${DATA}_${AREA}.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/animation
mv ptp00_anim_${DATA}_${AREA}.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/animation
mv ptp01_anim_${DATA}_${AREA}.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/animation
cp periopeak_000.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/periopeak_${DATA}_${AREA}.gif
cp enflux_000.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/enflux_${DATA}_${AREA}.gif
cp ph00_000.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/ph00_${DATA}_${AREA}.gif
cp ph01_000.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/ph01_${DATA}_${AREA}.gif
cp hs1tp1_000.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/hs1tp1_${DATA}_${AREA}.gif
cp hs0tp0_000.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/hs0tp0_${DATA}_${AREA}.gif
cp ptp00_000.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/ptp00_${DATA}_${AREA}.gif
cp ptp01_000.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/ptp01_${DATA}_${AREA}.gif

cd /home/operador/grads/gif/ww3_418/ww3gfs/ww3${AREA}00

convert -delay 20 -loop 0 ondas_*.gif ondas_anim_${DATA}_${AREA}.gif
convert -delay 20 -loop 0 periopeak_*.gif periopeak_anim_${DATA}_${AREA}.gif

mv ondas_anim_${DATA}_${AREA}.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/animation
mv periopeak_anim_${DATA}_${AREA}.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/animation
cp ondas_000.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/ondas_${DATA}_${AREA}.gif
cp periopeak_000.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/periopeak_${DATA}_${AREA}.gif

cd /home/operador/grads/gif/wrf_metarea5_00/

convert -delay 20 -loop 0 espvor_*.gif espvor_anim_${DATA}_${AREA}.gif
convert -delay 20 -loop 0 ventmax_*.gif ventmax_anim_${DATA}_${AREA}.gif

mv espvor_anim_${DATA}_${AREA}.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/animation
mv ventmax_anim_${DATA}_${AREA}.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/animation
cp espvor_000.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/ondas_${DATA}_${AREA}.gif
cp ventmax_003.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/periopeak_${DATA}_${AREA}.gif

rm espvor_anim_${DATA}_${AREA}.gif
rm ventmax_anim_${DATA}_${AREA}.gif



AREA="ne"

cd /home/operador/grads/gif/ww3_418/ww3testes/ww3${AREA}00

convert -delay 20 -loop 0 periopeak*.gif peakperiod_anim_${DATA}_${AREA}.gif
convert -delay 20 -loop 0 enflux_*.gif enflux_anim_${DATA}_${AREA}.gif
convert -delay 20 -loop 0 ph00_*.gif ph00_anim_${DATA}_${AREA}.gif
convert -delay 20 -loop 0 ph01_*.gif ph01_anim_${DATA}_${AREA}.gif
convert -delay 20 -loop 0 hs0tp0_*.gif hs0tp0_anim_${DATA}_${AREA}.gif
convert -delay 20 -loop 0 hs1tp1_*.gif hs1tp1_anim_${DATA}_${AREA}.gif
convert -delay 20 -loop 0 ptp00_*.gif ptp00_anim_${DATA}_${AREA}.gif
convert -delay 20 -loop 0 ptp01_*.gif ptp01_anim_${DATA}_${AREA}.gif


mv peakperiod_anim_${DATA}_${AREA}.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/animation
mv enflux_anim_${DATA}_${AREA}.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/animation
mv ph00_anim_${DATA}_${AREA}.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/animation
mv ph01_anim_${DATA}_${AREA}.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/animation
mv hs0tp0_anim_${DATA}_${AREA}.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/animation
mv hs1tp1_anim_${DATA}_${AREA}.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/animation
mv ptp00_anim_${DATA}_${AREA}.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/animation
mv ptp01_anim_${DATA}_${AREA}.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/animation
cp periopeak_000.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/periopeak_${DATA}_${AREA}.gif
cp enflux_000.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/enflux_${DATA}_${AREA}.gif
cp ph00_000.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/ph00_${DATA}_${AREA}.gif
cp ph01_000.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/ph01_${DATA}_${AREA}.gif
cp hs1tp1_000.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/hs1tp1_${DATA}_${AREA}.gif
cp hs0tp0_000.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/hs0tp0_${DATA}_${AREA}.gif
cp ptp00_000.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/ptp00_${DATA}_${AREA}.gif
cp ptp01_000.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/ptp01_${DATA}_${AREA}.gif

cd /home/operador/grads/gif/ww3_418/ww3gfs/ww3${AREA}00

convert -delay 20 -loop 0 ondas_*.gif ondas_anim_${DATA}_${AREA}.gif
convert -delay 20 -loop 0 periopeak_*.gif periopeak_anim_${DATA}_${AREA}.gif

mv ondas_anim_${DATA}_${AREA}.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/animation
mv periopeak_anim_${DATA}_${AREA}.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/animation
cp ondas_000.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/ondas_${DATA}_${AREA}.gif
cp periopeak_000.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/periopeak_${DATA}_${AREA}.gif

cd /home/operador/grads/gif/wrf_metarea5_00/

convert -delay 20 -loop 0 espvor_*.gif espvor_anim_${DATA}_${AREA}.gif
convert -delay 20 -loop 0 ventmax_*.gif ventmax_anim_${DATA}_${AREA}.gif

mv espvor_anim_${DATA}_${AREA}.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/animation
mv ventmax_anim_${DATA}_${AREA}.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/animation
cp espvor_000.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/ondas_${DATA}_${AREA}.gif
cp ventmax_003.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/periopeak_${DATA}_${AREA}.gif

rm espvor_anim_${DATA}_${AREA}.gif
rm ventmax_anim_${DATA}_${AREA}.gif


AREA="met"

cd /home/operador/grads/gif/ww3_418/ww3testes/ww3${AREA}00

convert -delay 20 -loop 0 periopeak*.gif peakperiod_anim_${DATA}_${AREA}.gif
convert -delay 20 -loop 0 enflux_*.gif enflux_anim_${DATA}_${AREA}.gif
convert -delay 20 -loop 0 ph00_*.gif ph00_anim_${DATA}_${AREA}.gif
convert -delay 20 -loop 0 ph01_*.gif ph01_anim_${DATA}_${AREA}.gif
convert -delay 20 -loop 0 hs0tp0_*.gif hs0tp0_anim_${DATA}_${AREA}.gif
convert -delay 20 -loop 0 hs1tp1_*.gif hs1tp1_anim_${DATA}_${AREA}.gif
convert -delay 20 -loop 0 ptp00_*.gif ptp00_anim_${DATA}_${AREA}.gif
convert -delay 20 -loop 0 ptp01_*.gif ptp01_anim_${DATA}_${AREA}.gif


mv peakperiod_anim_${DATA}_${AREA}.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/animation
mv enflux_anim_${DATA}_${AREA}.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/animation
mv ph00_anim_${DATA}_${AREA}.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/animation
mv ph01_anim_${DATA}_${AREA}.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/animation
mv hs0tp0_anim_${DATA}_${AREA}.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/animation
mv hs1tp1_anim_${DATA}_${AREA}.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/animation
mv ptp00_anim_${DATA}_${AREA}.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/animation
mv ptp01_anim_${DATA}_${AREA}.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/animation
cp periopeak_000.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/periopeak_${DATA}_${AREA}.gif
cp enflux_000.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/enflux_${DATA}_${AREA}.gif
cp ph00_000.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/ph00_${DATA}_${AREA}.gif
cp ph01_000.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/ph01_${DATA}_${AREA}.gif
cp hs1tp1_000.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/hs1tp1_${DATA}_${AREA}.gif
cp hs0tp0_000.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/hs0tp0_${DATA}_${AREA}.gif
cp ptp00_000.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/ptp00_${DATA}_${AREA}.gif
cp ptp01_000.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/ptp01_${DATA}_${AREA}.gif

cd /home/operador/grads/gif/ww3_418/ww3gfs/ww3${AREA}00

convert -delay 20 -loop 0 ondas_*.gif ondas_anim_${DATA}_${AREA}.gif
convert -delay 20 -loop 0 periopeak_*.gif periopeak_anim_${DATA}_${AREA}.gif

mv ondas_anim_${DATA}_${AREA}.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/animation
mv periopeak_anim_${DATA}_${AREA}.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/animation
cp ondas_000.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/ondas_${DATA}_${AREA}.gif
cp periopeak_000.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/periopeak_${DATA}_${AREA}.gif


cd /home/operador/grads/gif/wrf_metarea5_00/

convert -delay 20 -loop 0 espvor_*.gif espvor_anim_${DATA}_${AREA}.gif
convert -delay 20 -loop 0 ventmax_*.gif ventmax_anim_${DATA}_${AREA}.gif

mv espvor_anim_${DATA}_${AREA}.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/animation
mv ventmax_anim_${DATA}_${AREA}.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/animation
cp espvor_000.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/ondas_${DATA}_${AREA}.gif
cp ventmax_003.gif /home/operador/grads/gif/ww3_418/ww3testes/transfer/periopeak_${DATA}_${AREA}.gif

rm espvor_anim_${DATA}_${AREA}.gif
rm ventmax_anim_${DATA}_${AREA}.gif




