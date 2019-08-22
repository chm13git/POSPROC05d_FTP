'reinit'
*say "Entre com o arquivo ctl (Ex.: ea4, para arq ea4.ctl)"
*pull arq

aaaa=ANO
mm=MM
dd=DD
_hh=HH
*if (_hh=00)
* O tempo 13 equivale ao prog36h do cosmo7km.
_ta1=13
*else
*_ta1=1
*endif
_local=LOCAL
lati="LATI"
long="LONG"
if (long<0)
longo=360long
else
longo=long
endif

say 'Extraindo dados lat  '%lati' long '%long
say ''
arqatm='/home/operador/grads/cosmo/cosmomet/ctl/ctl'_hh'/cosmo_met5_'_hh'_M.ctl'
arqond='/mnt/nfs/dpns32/data2/operador/mod_ondas/ww3_418/output/ww3icon/wave.'%aaaa%mm%dd'/met.t'_hh'z.ctl'

*################################################################################

* _tamax equivale ao ultimo horario de extracao do dado (prog 84h= tmax 29) e nao o ultimo horario
* de dado disponivel

_tamax=29
_tomax=29

* Abrindo os arquivos dos modelos
'open '%arqatm

args=lati" "long

tempo(args)
nebulosidade(args)
weather(args)
temp2m(args)
vento10m(args)

* Fechando os arquivos atmosfericos
'reinit'

* Abrindo o arquivo de ondas
'open '%arqond

ondas(args)

'quit'

*################################################################################
* FUNCOES PARA CADA VARIAVEL
*################################################################################
* Plotando o Tempo
function tempo(args)
'reset'
lat1=subwrd(args,1)
lon1=subwrd(args,2)
'set lat 'lat1
'set lon 'lon1

* ta 13 equivale ao horario 36 apos o inicio da rodada.
ta=_ta1+4

while(ta<=_tamax)
'set t 'ta
'q time'
tempt=subwrd(result,3)
if(ta=_ta1+4)
tempo=tempt
endif
if(ta>_ta1+4)
tempo=tempo','tempt
endif
ta=ta+4
endwhile

say tempo

meteo=write('S4_UNITAS_'_local'_'_hh'.txt',''lat1','lon1',TEMPO,'tempo'')
return

*################################################################################

* Plotando Temperatura a 2 metros
function temp2m(args)

'reset'
lat1=subwrd(args,1)
lon1=subwrd(args,2)
'set lat 'lat1
'set lon 'lon1

* ta 13 equivale ao horario 36 apos o inicio da rodada.
ta=_ta1

while(ta<_tamax)
'set t 'ta
'q time'
tempt=subwrd(result,3)
if(ta=_ta1)
tempo=tempt
endif
if(ta>_ta1)
tempo=tempo','tempt
endif

'define tmax=max(t2m,t='%ta',t='%ta+4')'
'd tmax'
tempmaxc=subwrd(result,4)-273
*tempmaxf=((tempmaxc*9)/5 + 32)
tempmaxc=math_format('%4.0f',tempmaxc)
if(ta=_ta1)
temperaturasmax=tempmaxc
endif
if(ta>_ta1)
temperaturasmax=temperaturasmax','tempmaxc
endif

'define tmin=min(t2m,t='%ta',t='%ta+4')'
'd tmin'
tempminc=subwrd(result,4)-273
tempminc=math_format('%4.0f',tempminc)
if(ta=_ta1)
temperaturasmin=tempminc
endif
if(ta>_ta1)
temperaturasmin=temperaturasmin','tempminc
endif

ta=ta+4
endwhile

say temperaturasmin
say temperaturasmax

*meteo=write('S4_UNITAS_'_local'_'_hh'.txt',''lat1','lon1',TAIR TEMP,'tempo'')
meteo=write('S4_UNITAS_'_local'_'_hh'.txt',''lat1','lon1',AIR TEMP MAX,'temperaturasmax'')
meteo=write('S4_UNITAS_'_local'_'_hh'.txt',''lat1','lon1',AIR TEMP MIN,'temperaturasmin'')
return

*################################################################################

* Plotando a Nebulosidade
function nebulosidade(args)

'reset'
lat1=subwrd(args,1)
lon1=subwrd(args,2)
'set lat 'lat1
'set lon 'lon1

* ta 13 equivale ao horario 12 apos o inicio da rodada.
ta=_ta1

while(ta<_tamax)
'set t 'ta

'q time'
tempt=subwrd(result,3)
if(ta=_ta1)
tempo=tempt
endif
if(ta>_ta1)
tempo=tempo','tempt
endif

'define temp=max(clct,t='%ta',t='%ta'+4)'
'd temp'
temp=subwrd(result,4)
neb=temp
neb=math_format('%3.0f',neb)

if(ta=_ta1)
*temps=temp
nebs=neb
endif
if(ta>_ta1)
*temps=temps','temp
nebs=nebs','neb
endif
ta=ta+4
endwhile

say nebs

*meteo=write('S4_UNITAS_'_local'_'_hh'.txt',''lat1','lon1',TCLOUDINESS,'tempo'')
meteo=write('S4_UNITAS_'_local'_'_hh'.txt',''lat1','lon1',CLOUDINESS,'nebs'')
return

*################################################################################

* Plotando a Precipitacao
function weather(args)

'reset'
lat1=subwrd(args,1)
lon1=subwrd(args,2)
'set lat 'lat1
'set lon 'lon1

* ta 13 equivale ao horario 36h apos o inicio da rodada.
ta=_ta1

while(ta<_tamax)
'set t 'ta
'q time'
tempt=subwrd(result,3)
if(ta=_ta1)
tempo=tempt
endif
if(ta>_ta1)
tempo=tempo','tempt
endif

* Precipitação
'define prec=TOT_PREC(t='%ta+4')-TOT_PREC(t='%ta')'
'd prec'
prec=subwrd(result,4)
if(ta=_ta1)
precs=prec
endif
if(ta>_ta1)
precs=precs','prec
endif
ta=ta+4
endwhile

say precs

*meteo=write('S4_UNITAS_'_local'_'_hh'.txt',''lat1','lon1',TWEATHER,'tempo'')
meteo=write('S4_UNITAS_'_local'_'_hh'.txt',''lat1','lon1',WEATHER,'precs'')
return

*################################################################################

* Plotando a direcao e altura das ondas
function ondas(args)

'reset'
lat1=subwrd(args,1)
lon1=subwrd(args,2)
long=(360+(lon1))

'set lat 'lat1
'set lon 'long

* to 13 equivale ao horario 36 apos o inicio da rodada.
to=_ta1

ondas=' '
while(to<_tomax)
'set t 'to

'q time'
tempt=subwrd(result,3)
if(to=_ta1)
tempo=tempt
endif
if(to>13)
tempo=tempo','tempt
endif

'define u =cos(dp)'
'define v =sin(dp)'
'define dironda=(57.325*atan2(-u,-v))'
'd dironda'
dironda=subwrd(result,4)

if(dironda<=0)
dironda=360+dironda
endif
dironda=math_format('%3.0f',dironda)
if(to=_ta1)
dirondas=dironda
endif
if(to>13)
dirondas=dirondas','dironda
endif

'define ondamax=max(hs,t='%to',t='%to+4')'
'd ondamax'
onda=subwrd(result,4)
onda=math_format('%2.1f',onda)
if(to=_ta1)
ondas=onda
endif
if(to>13)
ondas=ondas','onda
endif
to=to+4
endwhile

say dirondas
say ondas

*meteo=write('S4_UNITAS_'_local'_'_hh'.txt',''lat1';'lon1';TWAVES;'tempo'')
meteo=write('S4_UNITAS_'_local'_'_hh'.txt',''lat1','lon1',DIRWAVES,'dirondas'')
meteo=write('S4_UNITAS_'_local'_'_hh'.txt',''lat1','lon1',WAVES,'ondas'')
return

*################################################################################

* Plotando INFO Vento a 10 metros
function vento10m(args)

'reset'
lat1=subwrd(args,1)
lon1=subwrd(args,2)
'set lat 'lat1
'set lon 'lon1

* ta 13 equivale ao horario 12 apos o inicio da rodada.
ta=_ta1

temps=' '
while(ta<_tamax)
'set t 'ta

'q time'
tempt=subwrd(result,3)
if(ta=_ta1)
tempo=tempt
endif
if(ta>_ta1)
tempo=tempo','tempt
endif

*'define dirvento10m=(57.3*atan2(-u_10m,-v_10m))'
'define dirvento10m=(57.3*atan2(u_10m,v_10m)+180)'
'd dirvento10m'
dirvento10m=subwrd(result,4)
dirvento10m=math_format('%3.0f',dirvento10m)

'define intvento10m=max(mag(U_10m*1.94,V_10m*1.94),t='%ta',t='%ta+4')'
'd intvento10m'
intvento10m=subwrd(result,4)
intvento10m=math_format('%3.0f',intvento10m)

'define ventomax10m=max(vmax_10m*1.94384,t='%ta',t='%ta+4')'
'd ventomax10m'
intventmax10m=subwrd(result,4)
intventmax10m=math_format('%3.0f',intventmax10m)

if(ta=_ta1)
dirvento10ms=dirvento10m
intvento10ms=intvento10m
intventmax10ms=intventmax10m
endif
if(ta>_ta1)
dirvento10ms=dirvento10ms','dirvento10m
intvento10ms=intvento10ms','intvento10m
intventmax10ms=intventmax10ms','intventmax10m
endif

ta=ta+4
endwhile

say dirvento10ms
say intvento10ms
say intventmax10ms

*meteo=write('S4_UNITAS_'_local'_'_hh'.txt',''lat1';'lon1';TWIND@SFC;'tempo'')
meteo=write('S4_UNITAS_'_local'_'_hh'.txt',''lat1','lon1',DIRWIND@SFC,'dirvento10ms'')
meteo=write('S4_UNITAS_'_local'_'_hh'.txt',''lat1','lon1',INTWIND@SFC,'intvento10ms'')
meteo=write('S4_UNITAS_'_local'_'_hh'.txt',''lat1','lon1',MAXWIND@SFC,'intventmax10ms'')

return
*################################################################################
