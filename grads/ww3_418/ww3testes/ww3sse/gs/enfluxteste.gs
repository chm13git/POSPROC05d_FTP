'open /home/operador/grads/ww3_418/ww3gfs/ww3sse/work/ww3.ctl'
i=1
while(i<=41)
'set t 'i
'set font 1'
plota(-38,-16,304,328)
prog=subwrd(str,i)
titulo(i,prog)
titulos1=' Modelo WW3/GFS - Fluxo de Energia - WW3/GFS Model - Energy Flux'
titulos(titulos1)
'printim GIFDIR/ww3sseHH/enfluxtest_'prog'.gif gif x770 y800 white'
*'printim /home/operador/ftp_comissoes/gif/ww3AREA_HH/periopeakgfs_'prog'.gif gif x577 y600 white'

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
'set rgb 17 240 240 240'
'set rgb 18 230 230 230'
'set rgb 19 220 220 255'
'set rgb 20 190 190 255'
'set rgb 31 230 255 225'
'set rgb 32 200 255 190'
'set rgb 33 180 250 170'
'set rgb 34 150 245 140'
'set rgb 35 120 245 115'
'set rgb 36  80 240  80'
'set rgb 37  55 210  60'
'set rgb 38  30 180  30'
'set rgb 39  15 160  15'
'set rgb 41 225 255 255'
'set rgb 42 180 240 250'
'set rgb 43 150 210 250'
'set rgb 44 120 185 250'
'set rgb 45  80 165 245'
'set rgb 46  60 150 245'
'set rgb 47  40 130 240'
'set rgb 48  30 110 235'
'set rgb 49  20 100 210'
'set rgb 51 220 220 255'
'set rgb 52 192 180 255'
'set rgb 53 160 140 255'
'set rgb 54 128 112 235'
'set rgb 55 112  96 220'   
'set rgb 56  72  60 200'   
'set rgb 57  60  40 180'
'set rgb 58  45  30 165'
'set rgb 59  40   0 160'
'set rgb 99 0 235 235'
'set map 1 1 6'
 'set clopts 1 4 0.13'
 'set gxout shaded'
 'set ccolor revrain'
 'set cmin 7'
 'set cint 20'
'set mpdset brmap_hires.dat'
'set clevs 2.5 10 22.5 40 62.5 90 122.5 160 202.5 250 302.5 360 422.5 490 562.5 640'
'set ccols 0 49 47 45 43 31 33 35 37 39 53 55 56 57 58 59  '
 'd smth9(smth9((1/fp)*hs*hs))'
'run /usr/local/lib/grads/cbarn.gs  0.75 1 8.3 5.5 '
 'set gxout vector'
 'set ccolor 1'
 'set arrlab off'
 'set arrscl 0.15'
 'd skip(cos(dp),15);skip(sin(dp),15)'
*'set gxout contour'
*'set clopts 1 6 0.10'
*'set clevs  12 14 16 18 20'
*'set ccols  1 1 1 1 1 '
*'set ccolor 1'
*'set cthick 5'
*'set clab masked'
*'d smth9(smth9((1/fp)*hs*hs)))'
'set line 1 2 4'
'draw line 1.32 2.98 3 2.12'
'draw line 3 2.12 7.69 7.75'
'draw line 6.12 5.88 4.87 6.99'
'draw line 4.87 6.99 2.74 4.90'
'draw line 2.74 4.90 4.56 4.00'
'draw line 7.69 7.75 5.75 9'
 return
