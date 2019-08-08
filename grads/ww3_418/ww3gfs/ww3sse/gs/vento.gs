'open WORKDIR/ww3AREA/work/ww3.ctl'
i=1
while(i<=41)
'set t 'i
'set font 1'
'clear'
plota(-38,-16,304,328)
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
'draw line 1.32 2.98 3 2.12'
'draw line 3 2.12 7.69 7.75'
'draw line 6.12 5.88 4.87 6.99'
'draw line 4.87 6.99 2.74 4.90'
'draw line 2.74 4.90 4.56 4.00'
'draw line 7.69 7.75 5.75 9'
 return

