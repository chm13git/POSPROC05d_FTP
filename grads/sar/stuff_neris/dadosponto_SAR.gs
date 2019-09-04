*################################################################################
* Inicio da funcao GERATABELASAR
*################################################################################

function geratabelasar(args)

* Carregando argumentos
_datai=subwrd(args,1)
_dataf=subwrd(args,2)
_lati=subwrd(args,3)
_loni=subwrd(args,4)
_comissao=subwrd(args,5)

* Testando se todos os args foram passados
if(_datai='') | (_dataf='') | (_lati='') | (_loni='') | (_comissao='')
say '### ARGUMENTOS INSUFICIENTES! ###'
say 'Entre com a data inicial, a data final, a latitude, a longitude e o nome do SAR.'
say 'Ex.: dadosponto_SAR.gs 2019083000 2019090100 -23.4 -43.1 SARSSE023'
'quit'
endif

** Carregando variaveis de tempo para Data Inicial
_aaaai=substr(_datai,1,4)
_mmi=substr(_datai,5,2)
_ddi=substr(_datai,7,2)
_hhi=substr(_datai,9,2)

* Reescrevendo data inicial de maneira modificada
'!caldate '_datai' + 0h 'hhZddMMMyyyy' | tr [a-z] [A-Z] > dataim'
rc=read(dataim)
_timei=sublin(rc,2)
rc=close(dataim)
'!rm dataim'

** Carregando variaveis de tempo para Data Final
_aaaaf=substr(_dataf,1,4)
_mmf=substr(_dataf,5,2)
_ddf=substr(_dataf,7,2)
_hhf=substr(_dataf,9,2)

* Reescrevendo data final de maneira modificada
'!caldate '_dataf' + 0h 'hhZddMMMyyyy' | tr [a-z] [A-Z] > datafm'
rc=read(datafm)
_timef=sublin(rc,2)
rc=close(datafm)
'!rm datafm'

* Definindo diretorio de trabalho
dirsar='/home/operador/grads/sar'

* Definindo caminnhoarq dos modelos
arqatm=dirsar'/cosmo_met.ctl'
arqond=dirsar'/ww3icon_met.ctl'
arqoce=dirsar'/hycom_met.ctl'

* Colhendo INF do 't' equivalente aos horarios de inicio e fim da tabela.
'open 'arqatm

* ti
'set time '_timei
'q time'
_ti=subwrd(result,3)

* tf
'set time '_timef
'q time'
_tf=subwrd(result,3)


say 'Extraindo dados lat  '%_lati' lon '%_loni
say ''


args=_lati" "_loni

* Executando as funcoes das variaveis
tempo(args)
temp2m(args)
vento10m(args)

corrente(args)

ondas(args)

'quit'

return

*################################################################################
* Fim da funcao GERADADOSSAR
*################################################################################


*###################### FUNCOES PARA CADA VARIAVEL ##############################


*################################################################################
* Inicio da funcao TEMPO
*################################################################################

function tempo(args)
'reinit'

* Abrindo os arquivos dos modelos
'open '%arqatm

'reset'
lat1=subwrd(args,1)
lon1=subwrd(args,2)
'set lat 'lat1
'set lon 'lon1

* ti eh o tempo inicial.
ta=_ti)

while(ta<=_tf)
'set t 'ta
'q time'
tempt=subwrd(result,3)

if(ta=_ti)
tempo=tempt
endif
if(ta>_ti)
tempo=tempo'//'tempt
endif
ta=ta+1
endwhile

say tempo

meteo=write('tabela_'_sar'_.txt',''lat1'//'lon1'//TEMPO//'tempo'')
return

*################################################################################
* Fim da funcao TEMPO
*################################################################################

*################################################################################
* Inicio da funcao TEMP2M
*################################################################################

function temp2m(args)
'reinit'

* Abrindo os arquivos dos modelos
'open '%arqatm

'reset'
lat1=subwrd(args,1)
lon1=subwrd(args,2)
'set lat 'lat1
'set lon 'lon1

* ti eh o tempo inicial.
ta=_ti

while(ta<=_tf)
'set t 'ta
'q time'
tempt=subwrd(result,3)

if(ta=_ti)
tempo=tempt
endif
if(ta>_ti)
tempo=tempo','tempt
endif

'd tmax2m'
tempmaxc=subwrd(result,4)-273.15
*tempmaxf=((tempmaxc*9)/5 + 32)
tempmaxc=math_format('%4.0f',tempmaxc)
if(ta=_ti)
temperaturasmax=tempmaxc
endif
if(ta>_ti)
temperaturasmax=temperaturasmax'//'tempmaxc
endif

'd tmin2m'
tempminc=subwrd(result,4)-273.15
*tempminf=((tempminc*9)/5 + 32)
tempminc=math_format('%4.0f',tempminc)
if(ta=_ti)
temperaturasmin=tempminc
endif
if(ta>_ti)
temperaturasmin=temperaturasmin'//'tempminc
endif

ta=ta+1
endwhile

say temperaturasmin
*say temperaturasmax

*meteo=write('tabela_'_sar'_.txt',''lat1'//'lon1',TAIR TEMP,'tempo'')
*meteo=write('tabela_'_sar'_.txt',''lat1'//'lon1',AIR TEMP MAX,'temperaturasmax'')
meteo=write('tabela_'_sar'_.txt',''lat1'//'lon1'//TEMP AR//'temperaturasmin'')
return

*################################################################################
* Fim da funcao TEMP2M
*################################################################################

*################################################################################
* Inicio da funcao VENTO 10m (dir e int)
*################################################################################

function vento10m(args)
'reinit'

* Abrindo os arquivos dos modelos
'open '%arqatm

'reset'
lat1=subwrd(args,1)
lon1=subwrd(args,2)
'set lat 'lat1
'set lon 'lon1

* ti eh o tempo inicial.
ta=_ti

temps=' '
while(ta<=_tf)
'set t 'ta

'q time'
tempt=subwrd(result,3)
if(ta=_ti)
tempo=tempt
endif
if(ta>_ti)
tempo=tempo','tempt
endif

*'define dirvento10m=(57.3*atan2(-u_10m,-v_10m))'
'define dirvento10m=(57.3*atan2(u_10m,v_10m)+180)'
'd dirvento10m'
dirvento10m=subwrd(result,4)
dirvento10m=math_format('%3.0f',dirvento10m)
* Transformando a Direcao do Vento a 10 metros

*if(dirvento10m <= 22.5 | dirvento10m >= 337.5)
*dirvento10m="N"
*endif
*if(dirvento10m > 22.5 & dirvento10m <= 67.5)
*dirvento10m="NE"
*endif
*if(dirvento10m > 67.5 & dirvento10m <= 112.5)
*dirvento10m="E"
*endif
*if(dirvento10m > 112.5 & dirvento10m <= 157.5)
*dirvento10m="SE"
*endif
*if(dirvento10m > 157.5 & dirvento10m <= 202.5)
*dirvento10m="S"
*endif
*if(dirvento10m > 202.5 & dirvento10m <= 247.5)
*dirvento10m="SW"
*endif
*if(dirvento10m > 247.5 & dirvento10m <= 292.5)
*dirvento10m="W"
*endif
*if(dirvento10m > 292.5 & dirvento10m < 337.5)
*dirvento10m="NW"
*endif

'define intvento10m=mag(U_10m*1.94,V_10m*1.94)'
'd intvento10m'
intvento10m=subwrd(result,4)
intvento10m=math_format('%3.0f',intvento10m)

'define ventomax10m=(vmax_10m*1.94384)'
'd ventomax10m'
intventmax10m=subwrd(result,4)
intventmax10m=math_format('%3.0f',intventmax10m)

* Criando as STRINGS com os dados de vento
if(ta=_ti)
dirvento10ms=dirvento10m
intvento10ms=intvento10m
intventmax10ms=intventmax10m
*vento10m=dirvento10m'/'intvento10m'-'intventmax10m'KT'
*restriventos=retrivento
endif
if(ta>_ti)
dirvento10ms=dirvento10ms'//'dirvento10m
intvento10ms=intvento10ms'//'intvento10m
intventmax10ms=intventmax10ms'//'intventmax10m
*restriventos=restrivento';'restriventos
endif

ta=ta+1
endwhile

say dirvento10ms
say intvento10ms
say intventmax10ms

*meteo=write('tabela_'_sar'_.txt',''lat1';'lon1';TWIND@SFC;'tempo'')
*meteo=write('tabela_'_sar'_.txt',''lat1'//'lon1',DIRWIND@SFC,'dirvento10ms'')
*meteo=write('tabela_'_sar'_.txt',''lat1'//'lon1',INTWIND@SFC,'intvento10ms'')
*meteo=write('tabela_'_sar'_.txt',''lat1'//'lon1',MAXWIND@SFC,'intventmax10ms'')
*meteo=write('tabela_'_sar'_.txt',''lat1';'lon1';RESTRWIND@SFC;'restriventos'')
meteo=write('tabela_'_sar'_.txt',''lat1'//'lon1'//VENTOS//'dirvento10ms'-'intvento10ms'')
return

*################################################################################
* Fim da funcao VENTO 10m (dir e int)
*################################################################################

*################################################################################
* Fim da funcao ONDAS (hs e dp)
*################################################################################

function ondas(args)
'reinit'

* Abrindo o arquivo de ondas
'open '%arqond

'reset'
lat1=subwrd(args,1)
lon1=subwrd(args,2)

* Reescrevendo lon para modelo de ondas
if (lon1<0)
lon1=(360+(lon1))
endif

'set lat 'lat1
'set lon 'lon1

ta=_ti

ondas=' '
while(ta<=_tf)
'set t 'to

'q time'
tempt=subwrd(result,3)
if(ta=_ti)
tempo=tempt
endif
if(ta>_ti)
tempo=tempo','tempt
endif

* Usando a direcao de pico como REF
'define u =cos(dp)'
'define v =sin(dp)'
'define dironda=(57.325*atan2(-u,-v))'
'd dironda'
dironda=subwrd(result,4)

if(dironda<=0)
dironda=360+dironda
endif

dironda=math_format('%3.0f',dironda)
if(ta=_ti)
dirondas=dironda
endif
if(ta>_ti)
dirondas=dirondas'//'dironda
endif

'd hs'
onda=subwrd(result,4)
onda=math_format('%2.1f',onda)
if(ta=_ti)
ondas=onda
endif
if(ta>_ti)
ondas=ondas'//'onda
endif
to=to+1
endwhile

say dirondas
say ondas

*meteo=write('tabela_'_sar'_.txt',''lat1';'lon1';TWAVES;'tempo'')
*meteo=write('tabela_'_sar'_.txt',''lat1'//'lon1'//DIRWAVES//'dirondas'')
*meteo=write('tabela_'_sar'_.txt',''lat1'//'lon1',WAVES,'ondas'')
meteo=write('tabela_'_sar'_.txt',''lat1'//'lon1'//ONDAS//'dirondas'-'ondas'')
return

*################################################################################
* Fim da funcao ONDAS (hs e dp)
*################################################################################

*################################################################################
* Inicio da funcao TSM
*################################################################################
function corrente(args)
'reinit'

* Abrindo o arquivo de TSM
'sdfopen '%arqoce

'reset'

lat1=subwrd(args,1)
lon1=subwrd(args,2)
'set lat 'lat1
'set lon 'lon1
'set z 33'

ta=_ti

correntes=' '
while(ta<=_tf)

if(ta=_ti)
'set t 'ta

'q time'
tempt=subwrd(result,3)
tempo=tempt

'd temperature'
corrente=subwrd(result,4)
corrente=math_format('%2.1f',corrente)
correntes=corrente
endif

if(ta>_ti)
resto=math_fmod(to,2)
if(resto=0)
correntes=correntes',NULL'
tempo=tempo',NULL'
else
tc=tc+1
'set t 'tc

'q time'
tempt=subwrd(result,3)
tempo=tempo','tempt

'd temperature'
corrente=subwrd(result,4)
corrente=math_format('%2.1f',corrente)
correntes=correntes','corrente
endif
endif
to=to+1
endwhile

say correntes

*meteo=write('tabela_'_sar'_.txt',''lat1';'lon1';TTSM;'tempo'')
meteo=write('tabela_'_sar'_.txt',''lat1'//'lon1',TSM,'correntes'')
return

*################################################################################
* Fim da funcao TSM
*################################################################################

*=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=

*################################################################################
* Inicio da funcao CORRENTES
*################################################################################
function correntes(args)
'reinit'

* Abrindo o arquivo
'sdfopen '%arqoce

'reset'

lat1=subwrd(args,1)
lon1=subwrd(args,2)
'set lat 'lat1
'set lon 'lon1
'set z 33'

ta=_ti

correntes=' '
while(ta<=_tf)

if(ta=_ti)
'set t 'ta

'q time'
tempt=subwrd(result,3)
tempo=tempt

'd temperature'
corrente=subwrd(result,4)
corrente=math_format('%2.1f',corrente)
correntes=corrente
endif

if(ta>_ti)
resto=math_fmod(to,2)
if(resto=0)
correntes=correntes',NULL'
tempo=tempo',NULL'
else
tc=tc+1
'set t 'tc

'q time'
tempt=subwrd(result,3)
tempo=tempo','tempt

'd temperature'
corrente=subwrd(result,4)
corrente=math_format('%2.1f',corrente)
correntes=correntes','corrente
endif
endif
to=to+1
endwhile

say correntes

meteo=write('tabela_'_sar'_.txt',''lat1'//'lon1'//CORRENTES//'correntes'')
return

*################################################################################
* Fim da funcao TSM
