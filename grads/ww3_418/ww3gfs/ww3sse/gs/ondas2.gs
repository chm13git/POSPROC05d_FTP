'open WORKDIR/ww3AREA/work/ww3.ctl'
i=1
while(i<=41)
'set t 'i
'set font 1'
plota(-38,-16,304,328)
prog=subwrd(str,i)
titulo(i,prog)
titulos1=' Modelo WW3/GFS - Alt.Ondas(m)/Vento(10m) - WW3/GFS Model - Wave Height(m)/Wind(10m)'
titulos(titulos1)
'printim GIFDIR/ww3AREAHH/ondas_vento_'prog'.gif gif x770 y800 white'
i=i+1
'clear'
endwhile
'quit'

function plota(lats,latn,lonw,lone)
'set grads off'
'set lat 'lats' 'latn
'set lon 'lonw' 'lone
'set string 1 c 6'
'set rgb 42 255 163 70'
'set rgb 43 128 128 255'
'set rgb 44 98 98 98'
'set map 1 1 6'
 'set clopts 1 4 0.13'
 'set gxout shaded'
 'set ccolor rainbow'
 'set cmin 3.0'
 'set cint 0.5'
 'set mpdset brmap_hires.dat'
'set clevs 3 3.5 4 4.5 5  6 7 8 9 10 11 12'
'set ccols 0  4 11 5 13 3 10 7 12 8 2 6'
* 'set mpdset hires'
 'd smth9(smth9(hs))'
'run /usr/local/lib/grads/cbarn.gs'
 'set gxout barb'
 'set ccolor 44'
 'set arrlab off'
 'set arrscl 0.15'
 'd skip(uwnd,9,9);vwnd' 
'set gxout contour'
 'set rgb 41 0 64 128'
 'set clopts 41 6 0.10'
 'set ccolor 41'
 'set cthick 9'
 'set clab forced'
'set cint 0.5'
'd smth9(smth9(hs))'
'set gxout contour'
'set clopts 2 6 0.10'
'set clevs 2.5'
'set ccols 2'
'set ccolor 2'
'set cthick 9'
'd smth9(smth9(hs))'
'set strsiz 0.18'
'set line 1 2 4'
'draw line 1.32 2.98 3 2.12'
'draw line 3 2.12 7.69 7.75'
'draw line 6.12 5.88 4.87 6.99'
'draw line 4.87 6.99 2.74 4.90'
'draw line 2.74 4.90 4.56 4.00'
'draw line 7.69 7.75 5.75 9'
 return
