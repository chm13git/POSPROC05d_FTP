'open WORKDIR/ww3AREA/work/ww3.ctl'
'run ../gs/colorset.gs'
i=1
while(i<=41)
'set t 'i
'query time'
clear
'set font 1'
 prog=subwrd(str,i)
plotaond()
grade()
prog=subwrd(str,i)
titulo(i,prog)
titulos1=' Modelo WW3/GFS - Alt. Sig. Ondas(m) - WW3/GFS Model - Sig. Wave Height(m)'
titulos(titulos1)
'printim GIFDIR/ww3AREAHH/internet/ondas_'prog'.gif  x700 y730 white'
i=i+1
endwhile
*
i=1
while(i<=41)
'clear'
'set t 'i
plotaper()
grade()
prog=subwrd(str,i)
titulo(i,prog)
titulos1=' Modelo WW3/GFS - Periodo Med Ondas (seg) - WW3/GFS Model - Wave Avg. Per.(sec)'
titulos(titulos1)
'printim GIFDIR/ww3AREAHH/internet/periondas_'prog'.gif gif x700 y730 white'
i=i+1
endwhile
'quit'
*
function plotaond()
'set grads off'
'set string 1 c 6'
'set map 1 1 6'
'set clopts 1 4 0.13'
'set gxout shaded'
'set clevs 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 6 7 8 9 10 11 12 13 14'
'set ccols 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38'
'set mpdset brmap_hires.dat'
'd smth9(smth9(hs))'
'run /usr/local/lib/grads/cbarn.gs 0.75 1 8.3 5.5 '
'set gxout vector'
'set ccolor 61'
'set arrlab off'
'set arrscl 0.15'
'd skip(cos(dir),15);skip(sin(dir),15)'
'set gxout contour'
'set clevs 1  2  3  4 5 6 7 8 9 10 11 12 13 14'
'set rgb 41 0 64 128'
'set clopts 41 6 0.10'
'set ccolor 41'
'set cthick 9'
'set clab forced'
'd smth9(smth9(hs))'
'set strsiz 0.16'
'set line 1 2 4'
'set gxout contour'
'set clopts 2 6 0.10'
'set clevs 2.5'
'set ccols 2'
'set ccolor 2'
'set cthick 9'
'd smth9(smth9(hs))'
*'draw line 1.32 1.77 2.15 1.01'
*'draw line 3.24 4.39 5.73 3.02'
*'draw line 3.24 4.39 6.27 7.40'
*'draw line 6.27 7.40 7.99 5.77'
*'draw line 4.00 1.01 7.99 5.77'
 return

function plotaper()
'set grads off'
'set string 1 c 6'
'set map 1 1 6'
'set clopts 1 4 0.13'
'set gxout shaded'
'set clevs 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15'
'set ccols 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36'
'set mpdset brmap_hires.dat'
'd smth9(smth9(t01))'
'run /usr/local/lib/grads/cbarn.gs 0.85 1 8.3 5.5   '
'set gxout contour'
'set clevs 4 6 8 10  12 14 16'
'set rgb 41 0 64 128'
'set clopts 41 6 0.10'
'set ccolor 41'
'set cthick 9'
'set clab forced'
'set strsiz 0.18'
*'set line 1 2 4'
'set gxout contour'
'set clopts 2 6 0.10'
'set clevs 2.5'
'set ccols 2'
'set ccolor 2'
'set cthick 9'
'd smth9(smth9(hs))'
*'draw line 1.32 1.77 2.15 1.01'
*'draw line 3.24 4.39 5.73 3.02'
*'draw line 3.24 4.39 6.27 7.40'
*'draw line 6.27 7.40 7.99 5.77'
*'draw line 4.00 1.01 7.99 5.77'
return

