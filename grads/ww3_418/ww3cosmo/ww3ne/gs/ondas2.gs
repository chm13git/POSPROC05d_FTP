'open WORKDIR/ww3AREA/work/ww3.ctl'
i=1
while(i<=33)
'set t 'i
'set font 1'
plota(-21,7,308,332)
grade()
prog=subwrd(str,i)
titulo(i,prog)
titulos1=' Modelo WW3/COSMO - Alt.Ondas(m)/Vento(10m) - WW3/COSMO Model - Wave Height(m)/Wind(10m)'
titulos(titulos1)
'printim GIFDIR/ww3AREAHH/ondas_vento_0'prog'.gif gif x770 y800 white'
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
 'set cmin 3'
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
