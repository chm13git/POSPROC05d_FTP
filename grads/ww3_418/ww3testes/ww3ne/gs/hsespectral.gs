'open WORKDIR/ww3sse/work/ww3.ctl'
i=1
while(i<=41)
'set t 'i
'set font 1'
plota(-38,-16,304,328)
prog=subwrd(str,i)
titulo(i,prog)
titulos1=' Modelo WW3/GFS - Alt. Sig. Ondas(m) PH02 - WW3/GFS Model - Sig. Wave Height(m)'
titulos(titulos1)
'printim GIFDIR/ww3sseHH/hsespectral_'prog'.gif gif x770 y800 white'
*'printim /home/operador/ftp_comissoes/gif/ww3AREA_HH/HS_0'prog'.gif gif x577 y600 white'

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

*'set mpdset brmap_hires.dat'
*'set gxout contour'
*'set clevs 1 1.5 2.5 3.5 4 5 6 7 8 9 10 11 12 '
*'set rgb 41 0 64 128'
*'set clopts 41 6 0.10'
*'set ccolor 9'
*'set cthick 9'
*'set clab forced'
*'set cint 0.5'
*'d smth9(smth9(phs00))'

*'set gxout contour'
*'set clevs 1 1.5 2.5 3.5 4 5 6 7 8 9 10 11 12 '
*'set rgb 41 0 64 128'
*'set clopts 41 6 0.10'
*'set ccolor 7'
*'set cthick 9'
*'set clab forced'
*'set cint 0.5'
*'d smth9(smth9(phs01))'

*'set gxout contour'
*'set clevs 1 1.5 2.5 3.5 4 5 6 7 8 9 10 11 12 '
*'set rgb 41 0 64 128'
*'set clopts 41 6 0.10'
*'set ccolor 10'
*'set cthick 9'
*'set clab forced'
*'set cint 0.5'
*'d smth9(smth9(phs02))'

'set gxout vector'
'set ccolor 4'
'set arrlab off'
'set arrscl 0.15'
'd skip(cos(dir),15);skip(sin(dir),15)' 
'set gxout vector'
'set ccolor 3'
'set arrlab off'
'set arrscl 0.15'
'd skip(cos(dp),15);skip(sin(dp),15)'
'set gxout vector'
'set ccolor 2'
'set arrlab off'
'set arrscl 0.15'
'd skip(cos(pdi00),15);skip(sin(pdi00),15)'


*'set gxout contour'
*'set clevs 1 1.5 2.5 3.5 4 5 6 7 8 9 10 11 12 '
*'set rgb 41 0 64 128'
*'set clopts 41 6 0.10'
*'set ccolor 41'
*'set cthick 9'
*'set clab forced'
*'set cint 0.5'
*'set mpdset brmap_hires.dat'
* 'set mpdset hires'
*'d smth9(smth9(hs))'
*'set gxout contour'
*'set clopts 2 6 0.10'
*'set clevs 2.5'
*'set ccols 2'
*'set ccolor 2'
*'set cthick 9'
*'d smth9(smth9(hs))'
'set line 1 2 4'
'draw line 1.32 2.98 3 2.12'
'draw line 3 2.12 7.69 7.75'
'draw line 6.12 5.88 4.87 6.99'
'draw line 4.87 6.99 2.74 4.90'
'draw line 2.74 4.90 4.56 4.00'
'draw line 7.69 7.75 5.75 9'
 return

