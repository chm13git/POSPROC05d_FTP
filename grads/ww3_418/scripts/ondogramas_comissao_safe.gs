* script 
'reinit'
'open ww3.ctl'
'set display color white'
'c'
'set t 1 last'
'q time'
var=subwrd(result,3)
'set font 1'
'set string 1 c 6'
'set strsiz 0.17'

*BOSÍSIO
'c'
'set lat -25.03'
'set lon 319.17'
plota()
'draw string 4.2 10.3 BOSISIO lat: -25.03 lon: -40.83 ref: 'var'.'
'printim /home/operador/grads/ww3_418/scripts/ondograma_BOSISIO.gif'
'printim /home/operador/grads/ww3_418/scripts/ondograma_BOSISIO.jpg'

*NETUNO   
'c'
'set lat -24.15'
'set lon 318.37'
plota()
'draw string 4.2 10.3 NETUNO lat: -24.15 lon: -41.63 ref: 'var'.'
'printim /home/operador/grads/ww3_418/scripts/ondograma_NETUNO.gif'
'printim /home/operador/grads/ww3_418/scripts/ondograma_NETUNO.jpg'

*ORION    
'c'
'set lat -23.97'
'set lon 317.80'
plota()
'draw string 4.2 10.3 ORION lat: -23.97 lon: -42.20 ref: 'var'.'
'printim /home/operador/grads/ww3_418/scripts/ondograma_ORION.gif'
'printim /home/operador/grads/ww3_418/scripts/ondograma_ORION.jpg'

*ZEUS 
'c'
'set lat -24.00'
'set lon 317.15'
plota()
'draw string 4.2 10.3 ZEUS lat: -24.00 lon: -42.85 ref: 'var'.'
'printim /home/operador/grads/ww3_418/scripts/ondograma_ZEUS.gif'
'printim /home/operador/grads/ww3_418/scripts/ondograma_ZEUS.jpg'

*POSEIDON
'c'
'set lat -23.50'
'set lon 317.10'
plota()
'draw string 4.2 10.3 POSEIDON lat: -23.50 lon: -42.90 ref: 'var'.'
'printim /home/operador/grads/ww3_418/scripts/ondograma_POSEIDON.gif'
'printim /home/operador/grads/ww3_418/scripts/ondograma_POSEIDON.jpg'  
'quit'

function plota()
'set vpage 0 8 7 10'
'set cmark 0'
'set grads off'
'set gxout line'
'set ccolor 4'
'set cthick 5'
*'set ylopts 1'
'set cstyle 1'
'set vrange 0 7'
'd HS'
'set ccolor 1'
'set grads off'
'u=(cos(dp)*3.14/180)'
'v=(sin(dp)*3.14/180)'
'd const(u,1); u ; v' 
'draw title Alt. significativa (m) e Direcao de pico'
*--------------------------------------------------
'set vpage 0 8 4.5 7.5'
'set cmark 0'
'set grads off'
'set gxout line'
'set ccolor 4'
'set cthick 5'
*'set ylopts 1'
'set cstyle 3'
'set vrange 2 20'
'd t01 ' 
'set ccolor 1'
'u=(cos(dir)*3.14/180)'
'v=(sin(dir)*3.14/180)'
'd const(u,10); u ; v'      
'draw title Periodo (s) e Direcao media'
*--------------------------------------------------
'set vpage 0 8 2 5'
'set cmark 0'    
'set grads off'
'set gxout line'
'set ccolor 4'
'set cthick 5'
*'set ylopts 1'
'set cstyle 1'
'set vrange 0 16'
'd mag(uwnd,vwnd) ' 
'set ccolor 1'
'd const(uwnd,8); uwnd ; vwnd'                                 
'draw title Magnitude de direcao do vento (10m)'
'set vpage off'
return
