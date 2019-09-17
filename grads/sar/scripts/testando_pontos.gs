function testepontos(args)
'reinit'

_datasar=subwrd(args,1)
_lati=subwrd(args,2)
_long=subwrd(args,3)
_longw=360+(1*_long)

*say 'Informe uma data dentro do intervalo SOL do SAR (Ex.: 00Z16SEP2019).'
*pull _datasar
*say 'Informe a lat.'
*pull _lati
*say 'Informe a lon.'
*pull _long

_latii=_lati-0.5; say _latii
_latif=_lati+0.5; say _latif
_longi=_long-0.5; say _longi
_longf=_long+0.5; say _longf
_longwi=_longw-0.5; say _longwi
_longwf=_longw+0.5; say _longwf

* Gerando Figura para WW3ICON
'open /home/operador/grads/sar/ctl/ww3icon_met.ctl'

'set display color white'
'set time '_datasar
'set lat '_latii' '_latif
'set lon '_longwi' '_longwf
'set gxout grid'
'set grads off'
'd hs'

'q w2xy '_longw' '_lati
say result
x1 = subwrd(result,3)
y1 = subwrd(result,6)
'set line 2 1 1'
'draw mark 3 'x1' 'y1' 0.15'
'draw title Desloque o ponto escolhido \ para o local onde ha dados validos'

'printim teste_ponto_'_lati'_'_long'_ww3icon.png'
'!scp teste_ponto_'_lati'_'_long'_ww3icon.png supervisor@10.13.200.5:~/scripts'
'!scp teste_ponto_'_lati'_'_long'_ww3icon.png supervisor@10.13.200.8:~/scripts'

* Gerando Figura para GHYCOM
'reinit'
'open /home/operador/grads/sar/ctl/hycom_met.ctl'

'set display color white'
'set time '_datasar
'set lat '_latii' '_latif
'set lon '_longi' '_longf
'set gxout grid'
'set grads off'
'd temperature'

'q w2xy '_long' '_lati
say result
x1 = subwrd(result,3)
y1 = subwrd(result,6)
'set line 2 1 1'
'draw mark 3 'x1' 'y1' 0.15'
'draw title Desloque o ponto escolhido \ para o local onde ha dados validos'

'printim teste_ponto_'_lati'_'_long'_hycom.png'
'!scp teste_ponto_'_lati'_'_long'_hycom.png supervisor@10.13.200.5:~/scripts'
'!scp teste_ponto_'_lati'_'_long'_hycom.png supervisor@10.13.200.8:~/scripts'

'quit'
return
