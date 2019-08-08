'open WORKDIR/ww3AREA/work/ww3.ctl'
i=1
while(i<=41)
'set t 'i
'set font 1'
plota()
prog=subwrd(str,i)
titulo(i,prog)
titulos1=' Modelo WW3/GFS - Per. Med. Ondas(seg) - WW3/GFS Model - Wave Avg. Per.(sec)'
titulos(titulos1)
grade()
'printim GIFDIR/ww3AREAHH/periondas_'prog'.gif gif x770 y800 white'
'printim /home/operador/ftp_comissoes/gif/ww3AREA_HH/periondas_'prog'.gif gif x577 y600 white'

i=i+1
'clear'
endwhile
'quit'

function plota()
 'set grads off'
 'set string 1 c 6'
 'set rgb 42 255 163 70'
 'set rgb 43 128 128 255'
 'set rgb 44 98 98 98'
 'set map 1 1 6'
 'set rgb 41 0 64 128'
 'set ccolor 41'
 'set cthick 9'
 'set clab forced'
 'set mpdset hires'
*'set clevs 0 2 4 6 8 10 12 14 16 18 20'
*'set ccols 0 4 11 5 13 3 10 7 12 8 2'
 'd smth9(smth9(t01))'
'set strsiz 0.18'
'set line 1 2 1'
 return


