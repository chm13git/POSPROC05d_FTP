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

*COMISSAO DRAGAO 20181106 -> 20181114
*DRAGAO1
'c'
'set lat -22.98'
'set lon 318.27'
plota()
'draw string 4.2 10.3 DRAGAO1 lat: -22.98 lon: -41.73 (27km da costa) ref: 'var'.'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_DRAGAO1.gif'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_DRAGAO1.jpg'

*COMISSAO DRAGAO 20181106 -> 20181114
*DRAGAO2
'c'
'set lat -21.00'
'set lon 319.47'
plota()
'draw string 4.2 10.3 DRAGAO2 lat: -21.00 lon: -40.53 ref: 'var'.'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_DRAGAO2.gif'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_DRAGAO2.jpg'

*COMISSAO DRAGAO 20181106 -> 20181114
*DRAGAO3
'c'
'set lat -23.28'
'set lon 318.29'
plota()
'draw string 4.2 10.3 DRAGAO3 lat: -23.28 lon: -41.71 ref: 'var'.'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_DRAGAO3.gif'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_DRAGAO3.jpg'

*COMISSAO DRAGAO 20181106 -> 20181114
*DRAGAO4
'c'
'set lat -22.38'
'set lon 319.84'
plota()
'draw string 4.2 10.3 DRAGAO4 lat: -22.38 lon: -40.16 ref: 'var'.'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_DRAGAO4.gif'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_DRAGAO4.jpg'

*COMISSAO NDCCSABOIA 20190220 -> 20190222
'c'
'set lat -23.1'
'set lon 315.68'
plota()
'draw string 4.2 10.3 NDCCSB Ens. Bat. Neves '
'draw string 4.2 10.8 lat: -23.1 lon: -44.32 ref: 'var'.'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_NDCCSB_enseadabatistaneves.gif'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_NDCCSB_enseadabatistaneves.jpg'

*COMISSAO NDCCSABOIA 20190220 -> 20190222
'c'
'set lat -23.06'
'set lon 316.02'
plota()
'draw string 4.2 10.3 NDCCSB Rest. Marambaia'
'draw string 4.2 10.8 lat: -23.06 lon: -43.98 ref: 'var'.'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_NDCCSB_restingamarambaia.gif'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_NDCCSB_restingamarambaia.jpg'

*COMISSAO MAN-SUP 2019 20190311 -> 20190329
'c'
'set lat -25.167'
'set lon 319.25'
plota()
'draw string 4.2 10.3 MAN-SUP 2019 - PONTO103'
'draw string 4.2 10.8 lat: -25.167 lon: -40.750 ref: 'var'.'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_MANSUP2019_PONTO103.gif'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_MANSUP2019_PONTO103.jpg'

**************************************************************************

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
'u=(cos(dir)*3.14/180)'
'v=(sin(dir)*3.14/180)'
'd const(u,1); u ; v' 
'draw title Alt. significativa (m) e Direcao Media'
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
'd (1/fp) ' 
'set ccolor 1'
'u=(cos(dp)*3.14/180)'
'v=(sin(dp)*3.14/180)'
'd const(u,10); u ; v'      
'draw title Periodo (s) e Direcao de Pico'
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
'draw title Magnitude (nos) e direcao do vento a 10m'
'set vpage off'
return
