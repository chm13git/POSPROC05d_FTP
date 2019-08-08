'open WORKDIR/ww3AREA/work/ww3.ctl'
i=1
while(i<=33)
'set t 'i
'set font 1'
plota(-38,-16,304,328)
prog=subwrd(str,i)
titulo(i,prog)
titulos1=' Modelo WW3/COSMO - Per. Med. Ondas(seg) - WW3/COSMO Model - Wave Avg. Per.(sec)'
titulos(titulos1)
'printim GIFDIR/ww3AREAHH/periondas_0'prog'.gif gif x770 y800 white'
*'printim /home/operador/ftp_comissoes/gif/ww3AREA_HH/PER_0'prog'.gif gif x577 y600 white'

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
* 'set mpdset hires'
 'd smth9(smth9(t01))'
'set strsiz 0.18'
'set line 1 2 4'
'draw line 1.32 2.98 3 2.12'
'draw line 3 2.12 7.69 7.75'
'draw line 6.12 5.88 4.87 6.99'
'draw line 4.87 6.99 2.74 4.90'
'draw line 2.74 4.90 4.56 4.00'
'draw line 7.69 7.75 5.75 9'
 return


