'open WORKDIR/ww3AREA/work/ww3.ctl'
i=1
while(i<=41)
'set t 'i
'set font 1'
plota(-21,7,308,332)
grade()
prog=subwrd(str,i)
titulo(i,prog)
titulos1=' Modelo WW3/GFS- Per. Med. Ondas (seg)  - WW3/GFS Model - Wave Avg. Per.(sec)'
titulos(titulos1)
'printim GIFDIR/ww3AREAHH/periondas_'prog'.gif gif x770 y800 white'
*'printim /home/operador/ftp_comissoes/gif/ww3AREA_HH/PER_'prog'.gif gif x577 y600 white'

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
 'set rgb 41 0 64 128'
 'set ccolor 41'
 'set cthick 9'
 'set clab forced'
 'set mpdset brmap_hires.dat'
 'd smth9(smth9(t01))'
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
