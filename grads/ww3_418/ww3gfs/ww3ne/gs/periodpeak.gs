'open WORKDIR/ww3AREA/work/ww3.ctl'
i=1
while(i<=41)
'set t 'i
'set font 1'
plota(-21,7,308,332)
prog=subwrd(str,i)
titulo(i,prog)
titulos1=' Modelo WW3/GFS - Per. Pico Ondas(seg) - WW3/GFS Model - Wave Peak Per.(sec)'
titulos(titulos1)
'printim GIFDIR/ww3AREAHH/periopeak_'prog'.gif gif x770 y800 white'
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
 'd smth9(smth9(1/fp))'
 'run /usr/local/lib/grads/cbarn.gs  0.75 1 8.3 5.5 '
 'set gxout vector'
 'set ccolor 1'
 'set arrlab off'
 'set arrscl 0.15'
 'd skip(cos(dp),7);skip(sin(dp),7)'
'set gxout contour'
'set clopts 1 6 0.10'
'set clevs  6 8 10 12 14 16 18 20'
'set ccols  15 15 15 1 1 1 1 1 '
'set ccolor 1'
'set cthick 5'
'set clab masked'
'd smth9(smth9(1/fp))'
'set line 1 2 4'
'draw line 0.98 9.38 1.99 10.25'
'draw line 1.99 10.25 7.36 6.86'
'draw line 7.36 6.86 7.36 4.48'
'draw line 7.36 4.48 6.23 2.79'
'draw line 6.23 2.79 6.23 0.75'
'draw line 6.23 0.75 4.48 1.85'
'draw line 4.67 3.46 6.23 2.79'
'draw line 5.61 5.92 7.36 6.86'
'draw line 3.03 7.03 4.81 8.55' 
 return
