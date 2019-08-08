'open /home/operador/grads/ww3_418/ww3gfs/ww3sse/work/ww3.ctl'
i=1
while(i<=41)
'set t 'i
'set font 1'
plota(-38,-16,304,328)
prog=subwrd(str,i)
titulo(i,prog)
titulos1=' Modelo WW3/GFS - Per. Pico Ondas(seg) PTP02 - WW3/GFS Model - Wave Peak Per.(sec)'
titulos(titulos1)
'printim GIFDIR/ww3sseHH/ptp02_'prog'.gif gif x770 y800 white'
*'printim /home/operador/ftp_comissoes/gif/ww3AREA_HH/periopeakgfs'prog'.gif gif x577 y600 white'

i=i+1
'clear'
endwhile
'quit'

function plota(lats,latn,lonw,lone)
'set grads off'
'set lat 'lats' 'latn
'set lon 'lonw' 'lone
'set string 1 c 6'
'set rgb 21 255 250 170'
'set rgb 22 255 232 120'
'set rgb 23 255 192  60'
'set rgb 24 255 160   0'
'set rgb 25 255  96   0'
'set rgb 26 255  50   0'
'set rgb 27 225  20   0'
'set rgb 28 192   0   0'
'set rgb 29 165   0   0'
'set rgb 30 135   0   0'
'set rgb 31 105   0   0'
'set rgb 17 240 240 240'
'set rgb 18 230 230 230'
'set rgb 19 220 220 255'
'set rgb 20 190 190 255'
'set rgb 32 255 70 0'
'set rgb 33 180 0 0'
'set rgb 34 90 0 0'
'set rgb 35 40 0 0'
*'set rgb 42 255 163 70'
*'set rgb 43 128 128 255'
*'set rgb 44 98 98 98'
'set rgb 41 225 255 255'
'set rgb 42 180 240 250'
'set rgb 43 150 210 250'
'set rgb 44 120 185 250'
'set rgb 45  80 165 245'
'set rgb 46  60 150 245'
'set rgb 47  40 130 240'
'set rgb 48  30 110 235'
'set rgb 49  20 100 210'
'set rgb 99 0 235 235'
'set map 1 1 6'
 'set clopts 1 4 0.13'
 'set gxout shaded'
 'set ccolor revrain'
 'set cmin 11'
 'set cint 1'
'set mpdset brmap_hires.dat'
'set clevs 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22'
'set ccols 0 49 48 47 46 45 43 42 21 22 23 24 25 26 27 28 29 30 31'
 'd smth9(smth9(ptp02))'
 'run /usr/local/lib/grads/cbarn.gs  0.75 1 8.3 5.5 '
 'set gxout vector'
 'set ccolor 1'
 'set arrlab off'
 'set arrscl 0.15'
 'd skip(cos(pdi02),15);skip(sin(pdi02),15)'
'set gxout contour'
'set clopts 1 6 0.10'
'set clevs  12 14 16 18 20'
'set ccols  1 1 1 1 1 '
'set ccolor 1'
'set cthick 5'
'set clab masked'
'd smth9(smth9(ptp02))'
'set line 1 2 4'
'draw line 1.32 2.98 3 2.12'
'draw line 3 2.12 7.69 7.75'
'draw line 6.12 5.88 4.87 6.99'
'draw line 4.87 6.99 2.74 4.90'
'draw line 2.74 4.90 4.56 4.00'
'draw line 7.69 7.75 5.75 9'
 return
