function geratabelasar(args)

_datai=subwrd(args,1)
_dataf=subwrd(args,2)
__lati=subwrd(args,3)
_loni=subwrd(args,4)
_comissao=subwrd(args,5)

'reinit'

* Carregando variaveis de tempo
_aaaai=substr(_datai,1,4)
_mmi=substr(_datai,5,2)
_ddi=substr(_datai,7,2)
_hhi=substr(_datai,9,2)

_aaaaf=substr(_dataf,1,4)
_mmf=substr(_dataf,5,2)
_ddf=substr(_dataf,7,2)
_hhf=substr(_dataf,9,2)


say 'Extraindo dados lat  '%_lati' lon '%_loni
say ''
arqatm='/home/operador/grads/cosmo_met.ctl'
arqond='/mnt/nfs/dpns32/data2/operador/mod_ondas/ww3_418/output/ww3icon/wave.'%aaaa%mm%dd'/met.t'_hh'z.ctl'
arqoce='/mnt/nfs/dpns32/data1/operador/previsao/hycom_2_2/output/Previsao_1_12/Ncdf/'%aaaa%mm%dd'/HYCOM_MV_'%aaaa%mm%dd'.nc'

*################################################################################

* _tamax equivale ao ultimo horario de extracao do dado e nao o ultimo horario
* de dado disponivel

_tamax=37
_tomax=(_tamax+2)/3

*'open '%arqatmz

args=_lati" "_loni

tempo(args)
nebulosidade(args)
weather(args)
temp2m(args)
teto(args)
vento10m(args)
visibilidade(args)

tsm(args)

ondas(args)

'quit'

return



*################################################################################
* FUNCOES PARA CADA VARIAVEL
*################################################################################
* Plotando o Tempo
function tempo(args)
'reinit'

* Abrindo os arquivos dos modelos
'open '%arqatm

'reset'
lat1=subwrd(args,1)
lon1=subwrd(args,2)
'set lat 'lat1
'set lon 'lon1

* ta 13 equivale ao horario 12 apos o inicio da rodada.
ta=_ta1

while(ta<=_tamax)
'set t 'ta
'q time'
tempt=subwrd(result,3)
if(ta=_ta1)
tempo=tempt
endif
if(ta>_ta1)
tempo=tempo','tempt
endif
ta=ta+3
endwhile

say tempo

meteo=write('meteograma_UNITAS_'_local'_'_hh'.txt',''lat1','lon1',TEMPO,'tempo'')
return

*################################################################################

* Plotando Temperatura a 2 metros
function temp2m(args)
'reinit'

* Abrindo os arquivos dos modelos
'open '%arqatm


'reset'
lat1=subwrd(args,1)
lon1=subwrd(args,2)
'set lat 'lat1
'set lon 'lon1

* ta 13 equivale ao horario 12 apos o inicio da rodada.
ta=_ta1

while(ta<=_tamax)
'set t 'ta

'q time'
tempt=subwrd(result,3)
if(ta=_ta1)
tempo=tempt
endif
if(ta>_ta1)
tempo=tempo','tempt
endif

'd tmax2m'
tempmaxc=subwrd(result,4)-273
*tempmaxf=((tempmaxc*9)/5 + 32)
tempmaxc=math_format('%4.0f',tempmaxc)
if(ta=_ta1)
temperaturasmax=tempmaxc
endif
if(ta>_ta1)
temperaturasmax=temperaturasmax','tempmaxc
endif

'd tmin2m'
tempminc=subwrd(result,4)-273
*tempminf=((tempminc*9)/5 + 32)
tempminc=math_format('%4.0f',tempminc)
if(ta=_ta1)
temperaturasmin=tempminc
endif
if(ta>_ta1)
temperaturasmin=temperaturasmin','tempminc
endif

ta=ta+3
endwhile

say temperaturasmin
say temperaturasmax

*meteo=write('meteograma_UNITAS_'_local'_'_hh'.txt',''lat1','lon1',TAIR TEMP,'tempo'')
meteo=write('meteograma_UNITAS_'_local'_'_hh'.txt',''lat1','lon1',AIR TEMP MAX,'temperaturasmax'')
meteo=write('meteograma_UNITAS_'_local'_'_hh'.txt',''lat1','lon1',AIR TEMP MIN,'temperaturasmin'')
return

*################################################################################

* Plotando a Nebulosidade
function nebulosidade(args)
'reinit'

* Abrindo os arquivos dos modelos
'open '%arqatm


'reset'
lat1=subwrd(args,1)
lon1=subwrd(args,2)
'set lat 'lat1
'set lon 'lon1

* ta 13 equivale ao horario 12 apos o inicio da rodada.
ta=_ta1

while(ta<=_tamax)
'set t 'ta

'q time'
tempt=subwrd(result,3)
if(ta=_ta1)
tempo=tempt
endif
if(ta>_ta1)
tempo=tempo','tempt
endif

'd clct'
temp=subwrd(result,4)
neb=temp
neb=math_format('%3.0f',neb)

*if(temp <= 25)
*neb="Clear"
*endif
*if(temp > 25 & temp <= 62.5)
*neb="Partly-Cloudy"
*endif
*if(temp > 62.5 & temp <= 87.5)
*neb="Cloudy"
*endif
*if(temp > 87.5)
*neb="Overcast"
*endif

if(ta=_ta1)
*temps=temp
nebs=neb
endif
if(ta>_ta1)
*temps=temps','temp
nebs=nebs','neb
endif
ta=ta+3
endwhile

say nebs

*meteo=write('meteograma_UNITAS_'_local'_'_hh'.txt',''lat1','lon1',TCLOUDINESS,'tempo'')
meteo=write('meteograma_UNITAS_'_local'_'_hh'.txt',''lat1','lon1',CLOUDINESS,'nebs'')
return

*################################################################################

* Plotando a Precipitacao
function weather(args)
'reinit'

* Abrindo os arquivos dos modelos
'open '%arqatm


'reset'
lat1=subwrd(args,1)
lon1=subwrd(args,2)
'set lat 'lat1
'set lon 'lon1

* ta 13 equivale ao horario 12 apos o inicio da rodada.
ta=_ta1

while(ta<=_tamax)
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
'define prec=TOT_PREC-TOT_PREC(t-3)'
'd prec'
prec=subwrd(result,4)
if(ta=_ta1)
precs=prec
endif
if(ta>_ta1)
precs=precs','prec
endif
ta=ta+3
endwhile

say precs

*meteo=write('meteograma_UNITAS_'_local'_'_hh'.txt',''lat1','lon1',TWEATHER,'tempo'')
meteo=write('meteograma_UNITAS_'_local'_'_hh'.txt',''lat1','lon1',WEATHER,'precs'')
return

*################################################################################

* Plotando a Base das Nuvens

function teto(args)
'reinit'

* Abrindo os arquivos dos modelos
'open '%arqatm


* Setando as coordenadas geograficas
'reset'
lat1=subwrd(args,1)
lon1=subwrd(args,2)
'set lat 'lat1
'set lon 'lon1

* ta 13 equivale ao horario 12 apos o inicio da rodada.
ta=_ta1

* Buscando INFO da Base da Nuvem
temps=' '
while(ta<=_tamax)
'set t 'ta

'q time'
tempt=subwrd(result,3)
if(ta=_ta1)
tempo=tempt
endif
if(ta>_ta1)
tempo=tempo','tempt
endif

'define ceiling=var157sfc'
'd ceiling'
teto=subwrd(result,4)
tetom=math_format('%5.0f',teto)
*tetoft=(teto*3.2808)
*tetoft=math_format('%5.0f',tetoft)

* Definindo valores limites para base de nuvens conforme tabela de THRESHOLD!
*if(teto <= 500)
*restriteto=vermelho
*endif
*if(teto > 500 & teto < 1000)
*restriteto=amarelo
*else
*restriteto=verde
*endif

* Criando as STRINGS da base de nuvens e seus limites.
if(ta=_ta1)
tetos=tetom
*restritetos=restriteto
endif
if(ta>_ta1)
tetos=tetos','tetom
*restritetos=restriteto';'restritetos
endif
ta=ta+3
endwhile

* Plotando os valores e escrevendo no arquivo
say tetos
*say restritetos

*meteo=write('meteograma_UNITAS_'_local'_'_hh'.txt',''lat1','lon1',TCEILING,'tempo'')
meteo=write('meteograma_UNITAS_'_local'_'_hh'.txt',''lat1','lon1',CEILING,'tetos'')
*meteo=write('meteograma_UNITAS_'_local'_'_hh'.txt',''lat1';'lon1';RESTRICEILING;'restritetos'')
return

*################################################################################

* Plotando a Visibilidade
function visibilidade(args)
'reinit'

* Abrindo os arquivos dos modelos
'open '%arqatm


'reset'
lat1=subwrd(args,1)
lon1=subwrd(args,2)
'set lat 'lat1
'set lon 'lon1

* ta 13 equivale ao horario 12 apos o inicio da rodada.
ta=_ta1

temps=' '
while(ta<=_tamax)
'set t 'ta

'q time'
tempt=subwrd(result,3)
if(ta=_ta1)
tempo=tempt
endif
if(ta>_ta1)
tempo=tempo','tempt
endif

'd hvis_nsfc'
temp=subwrd(result,4)
if(ta=_ta1)
temps=temp
endif
if(ta>_ta1)
temps=temps','temp
endif
ta=ta+3
endwhile

say temps

*meteo=write('meteograma_UNITAS_'_local'_'_hh'.txt',''lat1';'lon1';TVISIBILITY;'tempo'')
meteo=write('meteograma_UNITAS_'_local'_'_hh'.txt',''lat1','lon1',VISIBILITY,'temps'')
return

*################################################################################

* Plotando INFO Vento a 10 metros
function vento10m(args)
'reinit'

* Abrindo os arquivos dos modelos
'open '%arqatm


'reset'
lat1=subwrd(args,1)
lon1=subwrd(args,2)
'set lat 'lat1
'set lon 'lon1

* ta 13 equivale ao horario 12 apos o inicio da rodada.
ta=_ta1

temps=' '
while(ta<=_tamax)
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

* Definindo valores limites para a intensidade do vento conforme tabela de THRESHOLD!
*if(intventmax10m < 20)
*restrivento=verde
*endif
*if(intventmax10m >= 20 & intventmax10m <= 30)
*restrivento=amarelo
*endif
*if(intventmax10m > 30)
*restrivento=vermelho
*endif

* Criando as STRINGS da base de nuvens e seus limites.
if(ta=_ta1)
dirvento10ms=dirvento10m
intvento10ms=intvento10m
intventmax10ms=intventmax10m
*vento10m=dirvento10m'/'intvento10m'-'intventmax10m'KT'
*restriventos=retrivento
endif
if(ta>_ta1)
dirvento10ms=dirvento10ms','dirvento10m
intvento10ms=intvento10ms','intvento10m
intventmax10ms=intventmax10ms','intventmax10m
*restriventos=restrivento';'restriventos
endif
ta=ta+3
endwhile

say dirvento10ms
say intvento10ms
say intventmax10ms

*meteo=write('meteograma_UNITAS_'_local'_'_hh'.txt',''lat1';'lon1';TWIND@SFC;'tempo'')
meteo=write('meteograma_UNITAS_'_local'_'_hh'.txt',''lat1','lon1',DIRWIND@SFC,'dirvento10ms'')
meteo=write('meteograma_UNITAS_'_local'_'_hh'.txt',''lat1','lon1',INTWIND@SFC,'intvento10ms'')
meteo=write('meteograma_UNITAS_'_local'_'_hh'.txt',''lat1','lon1',MAXWIND@SFC,'intventmax10ms'')
*meteo=write('meteograma_UNITAS_'_local'_'_hh'.txt',''lat1';'lon1';RESTRWIND@SFC;'restriventos'')
return

*################################################################################

* Plotando a direcao e altura das ondas
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

* to 5 equivale ao horario 12 apos o inicio da rodada.
to=5

ondas=' '
while(to<=_tomax)
'set t 'to

'q time'
tempt=subwrd(result,3)
if(to=5)
tempo=tempt
endif
if(to>5)
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
if(to=5)
dirondas=dironda
endif
if(to>5)
dirondas=dirondas','dironda
endif

'd hs'
onda=subwrd(result,4)
onda=math_format('%2.1f',onda)
if(to=5)
ondas=onda
endif
if(to>5)
ondas=ondas','onda
endif
to=to+1
endwhile

say dirondas
say ondas

*meteo=write('meteograma_UNITAS_'_local'_'_hh'.txt',''lat1';'lon1';TWAVES;'tempo'')
meteo=write('meteograma_UNITAS_'_local'_'_hh'.txt',''lat1','lon1',DIRWAVES,'dirondas'')
meteo=write('meteograma_UNITAS_'_local'_'_hh'.txt',''lat1','lon1',WAVES,'ondas'')
return

*################################################################################

* Plotando a TSM
function tsm(args)
'reinit'

* Abrindo o arquivo de TSM
'sdfopen '%arqoce

'reset'

lat1=subwrd(args,1)
lon1=subwrd(args,2)
'set lat 'lat1
'set lon 'lon1
'set z 33'

* to 5 equivale ao horario 12 apos o inicio da rodada no WW3

to=5

* tc 3 equivale ao horario 12 apos o inicio da rodada no HYCOM
if(_hh=00)
tc=3
endif
* tc 5 equivale ao horario 24 apos o inicio da rodada no HYCOM
if(_hh=12)
tc=5
endif


tsms=' '
while(to<=_tomax)

if(to=5)
'set t 'tc

'q time'
tempt=subwrd(result,3)
tempo=tempt

'd temperature'
tsm=subwrd(result,4)
tsm=math_format('%2.1f',tsm)
tsms=tsm
endif

if(to>5)
resto=math_fmod(to,2)
if(resto=0)
tsms=tsms',NULL'
tempo=tempo',NULL'
else
tc=tc+1
'set t 'tc

'q time'
tempt=subwrd(result,3)
tempo=tempo','tempt

'd temperature'
tsm=subwrd(result,4)
tsm=math_format('%2.1f',tsm)
tsms=tsms','tsm
endif
endif
to=to+1
endwhile

say tsms

*meteo=write('meteograma_UNITAS_'_local'_'_hh'.txt',''lat1';'lon1';TTSM;'tempo'')
meteo=write('meteograma_UNITAS_'_local'_'_hh'.txt',''lat1','lon1',TSM,'tsms'')
return

*################################################################################

