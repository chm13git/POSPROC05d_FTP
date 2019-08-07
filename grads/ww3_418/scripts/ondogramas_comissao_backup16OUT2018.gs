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

**********************AREA EDITAVEL PARA COMISSOES************************
*COMISSAO MISSILEX-2018 pt01 20180739 -> 20180807
'c'
'set lat -24.15'
'set lon 318.83'
plota()
'draw string 4.2 10.3 A. MISSILEX lat: -24.15 lon: -41.17 ref: 'var'.'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_MISSILEX_p01.gif'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_MISSILEX_p01.jpg'

*COMISSAO MISSILEX-2018 pt02 20180739 -> 20180807
'c'
'set lat -24.7'
'set lon 320.45'
plota()
'draw string 4.2 10.3 A. MISSILEX lat: -24.7 lon: -39.55 ref: 'var'.'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_MISSILEX_p02.gif'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_MISSILEX_p02.jpg'

*COMISSAO MISSILEX-2018 pt03 20180739 -> 20180807
'c'
'set lat -26.23'
'set lon 319.8'
plota()
'draw string 4.2 10.3 A. MISSILEX lat: -26.23 lon: -40.2 ref: 'var'.'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_MISSILEX_p03.gif'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_MISSILEX_p03.jpg'

*COMISSAO MISSILEX-2018 pt04 20180739 -> 20180807
'c'
'set lat -25.61'
'set lon 318.05'
plota()
'draw string 4.2 10.3 A. MISSILEX lat: -25.61 lon: -41.95 ref: 'var'.'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_MISSILEX_p04.gif'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_MISSILEX_p04.jpg'

*COMISSAO MISSILEX-2018 pt05 20180739 -> 20180807
'c'
'set lat -24.3'
'set lon 318.6'
plota()
'draw string 4.2 10.3 A. MISSILEX lat: -24.3 lon: -41.4 ref: 'var'.'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_MISSILEX_p05.gif'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_MISSILEX_p05.jpg'

*COMISSAO ADEREX I/2018 20180612 -> 20180617 
*OBERON
'c'
'set lat -24.3'
'set lon 318.6'
plota()
'draw string 4.2 10.3 A. OBERON lat: -24 lon: -43.03 ref: 'var'.'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_OBERON.gif'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_OBERON.jpg'

*COMISSAO ADEREX I/2018 20180612 -> 20180617
*ATENA
'c'
'set lat -23.53333'
'set lon 317.28'
plota()
'draw string 4.2 10.3 A. ATENA lat: -23.53 lon: -42.72 ref: 'var'.'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_ATENA.gif'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_ATENA.jpg'

*COMISSAO ADEREX I/2018 20180612 -> 20180617 
*HERMES
'c'
'set lat -24.07'
'set lon 317.65'
plota()
'draw string 4.2 10.3 HERMES lat: -24.07 lon: -42.35 ref: 'var'.'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_HERMES.gif'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_HERMES.jpg'

*COMISSAO ADEREX I/2018 20180612 -> 20180617
*ARES   
'c'
'set lat -24.15'
'set lon 316.92'
plota()
'draw string 4.2 10.3 ARES lat: -24.15 lon: -43.08 ref: 'var'.'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_ARES.gif'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_ARES.jpg'


*COMISSAO ADEREX I/2018 20180612 -> 20180617
*KRAKEN
'c'
'set lat -23.5'
'set lon 316.99'
plota()
'draw string 4.2 10.3 KRAKEN lat: -23.5 lon: -43.01 ref: 'var'.'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_KRAKEN.gif'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_KRAKEN.jpg'

*COMISSAO ADEREX I/2018 20180612 -> 20180617
*POSEIDON
'c'
'set lat -23.55'
'set lon 317.48'
plota()
'draw string 4.2 10.3 POSEIDON lat: -23.55 lon: -43.05 ref: 'var'.'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_POSEIDON.gif'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_POSEIDON.jpg'


*COMISSAO ADEREX I/2018 20180612 -> 20180617
*ICARO
'c'
'set lat -24'
'set lon 318.28'
plota()
'draw string 4.2 10.3 ICARO lat: -24 lon: -41.72 ref: 'var'.'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_ICARO.gif'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_ICARO.jpg'  

*COMISSAO ADEREX I/2018 20180612 -> 20180617
*FENIX
'c'
'set lat -23.2'
'set lon 318.13'
plota()
'draw string 4.2 10.3 FENIX lat: -23.2 lon: -41.87 ref: 'var'.'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_FENIX.gif'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_FENIX.jpg'


*COMISSAO ADEREX I/2018 20180612 -> 20180617
*HEFESTO
'c'
'set lat -24'
'set lon 317'
plota()
'draw string 4.2 10.3 HEFESTO lat: -24 lon: -43 ref: 'var'.'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_HEFESTO.gif'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_HEFESTO.jpg'

*COMISSAO ADEREX I/2018 20180612 -> 20180617
*ZEUS
'c'
'set lat -24.72'
'set lon 317.8'
plota()
'draw string 4.2 10.3 ZEUS lat: -24.72 lon: -42.2 ref: 'var'.'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_ZEUS.gif'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_ZEUS.jpg'


*COMISSAO TRANSITO NDCCSB 20180607 -> 20180611
*NDCCSB
'c'
'set lat -13.12'
'set lon 321.43'
plota()
'draw string 4.2 10.3 NDCCSB lat: -13.12 lon: -38.57 ref: 'var'.'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_NDCCSB.gif'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_NDCCSB.jpg'

*COMISSAO TRANSITO NDMPBA 20181020 -> 20181026
*NDMPBA_ponto_B
'c'
'set lat -23.50'
'set lon 315.39'
plota()
'draw string 4.2 10.3 NDMPBA lat: -23.50 lon: -44.61 ref: 'var'.'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_NDMPBA_ponto_B.gif'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_NDMPBA_ponto_B.jpg'

*COMISSAO TRANSITO NDMPBA 20181020 -> 20181026
*NDMPBA_ponto_C
'c'
'set lat -23.50'
'set lon 316.17'
plota()
'draw string 4.2 10.3 NDMPBA lat: -23.50 lon: -43.83 ref: 'var'.'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_NDMPBA_ponto_C.gif'
'printim /home/operador/grads/ww3_418/scripts/ondog_comissao_NDMPBA_ponto_C.jpg'

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
'draw title Magnitude de direcao do vento (10m)'
'set vpage off'
return
