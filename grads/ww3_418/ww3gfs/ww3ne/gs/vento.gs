'open WORKDIR/ww3AREA/work/ww3.ctl'
i=1
while(i<=41)
'set t 'i
'set font 1'
'clear'
plota(-21,7,308,332)
grade()
prog=subwrd(str,i)
titulo(i,prog)
titulos1='Modelo WW3/GFS - Vento 10m - WW3/GFS Model - Wind 10m'
titulos(titulos1)
'printim GIFDIR/ww3AREAHH/vento_'prog'.gif x770 y800 white'
i=i+1
endwhile
'quit'


function plota(lats,latn,lonw,lone)
 'set grads off'
'set lat 'lats' 'latn
'set lon 'lonw' 'lone
'set string 1 c 6' 
'set font 0'
 'set mpdset brmap_hires.dat'
 'set map 1 1 6'
 'set gxout shaded'
 'set cmin 28'
'set gxout barb'
 'set rgb 44 98 98 98'
 'set ccolor 41'
 'set cthick 3'
 'set arrscl 0.1'
 'd skip(uwnd,9,9);vwnd'
 'set gxout contour'
 'set rgb 44 0 64 128'
 'set clab forced'
 'set clopts 44 5 0.08'
 'set ccolor 44'
 'set cint 5'
 'set cthick 2'
 'd mag(uwnd,vwnd)'
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

