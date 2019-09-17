*################################################################################
* Inicio da funcao GERATABELASAR
*################################################################################

function geratabelasar(argsf)

* Carregando argumentos
_datai=subwrd(argsf,1)
_dataf=subwrd(argsf,2)
_lati=subwrd(argsf,3)
_loni=subwrd(argsf,4)
_nsar=subwrd(argsf,5)

say 'Data inicial: '_datai
say 'Data final:   '_dataf
say 'Latitude:     '_lati
say 'Longitude:    '_loni
say 'Nome SAR:     '_nsar

* Testando se todos os args foram passados
if(_datai='') | (_dataf='') | (_lati='') | (_loni='') | (_nsar='')
say '### ARGUMENTOS INSUFICIENTES! ###'
say 'Entre com a data inicial, a data final, a latitude, a longitude e o nome do SAR, conforme SOL pelo pedido de abertura de SAR.'
say 'Ex.: dadosponto_SAR.gs 2019083000 2019090100 -23.4 -43.1 SSE023'
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

* Definindo emails a serem enviados para cada regiao de SAR

*emailbrasil='mrccbrazil@marinha.mil.br mrccbrazil@gmail.com'
*emailbrasil='felipenc2@gmail.com'

*if (_sar='SUL')
*emailregional='mrccriogrande@marinha.mil.br'
*endif
*if (_sar='SUESTE')
*emailregional='mrccrio@marinha.mil.br'
*endif
*if (_sar='SUL_SUESTE')
*emailregional='mrccsaopaulo@marinha.mil.br'
*endif
*if (_sar='LESTE')
*emailregional='mrccsalvador@marinha.mil.br'
*endif
*if (_sar='CENTRO_OESTE')
*emailregional='rccbrasilia@marinha.mil.br'
*endif
*if (_sar='NORDESTE')
*emailregional='mrccnatal@marinha.mil.br'
*endif
*if (_sar='NORTE')
*emailregional='mrccbelem@marinha.mil.br'
*endif
*if (_sar='OESTE')
*emailregional='rccladario@marinha.mil.br'
*endif
*if (_sar='NOROESTE')
*emailregional='rccmanaus@marinha.mil.br'
*endif


* Definindo diretorio de trabalho
dirsar='/home/operador/grads/sar'

* Definindo caminnhoarq dos modelos
_arqatm=dirsar'/ctl/cosmo_met.ctl'
_arqond=dirsar'/ctl/ww3icon_met.ctl'
_arqoce=dirsar'/ctl/hycom_met.ctl'

* Gravando args lat e lon numa var para uso nas funcoes
args=_lati" "_loni

** Colhendo tempo ti e tf
'open '%_arqatm

* ti
'set time '_timei
'q dims'
linha=sublin(result,5)
_ti=subwrd(linha,9)

* tf
'set time '_timef
'q dims'
linha=sublin(result,5)
_tf=subwrd(linha,9)

* Executando as funcoes das variaveis. A ordem das var respeita a ordem de chamada da funcao
tempo(args)
vento10m(args)
ondas(args)
corrente(args)
temp2m(args)
tsm(args)

* Eliminando espacos desnecessarios e movendo para o dir tabelas
*'!sed -e "s/ ,g" tabela_'%_nsar%'.txt'
*'!mail -s "TABELA BPME SAR '_nsar'" -t '_emailbrasil' '_emailregional' -A tabela_'_sar'.txt'
*'!cat msg_padrao.txt | mail -s "TABELA BPME SAR '_nsar'" '_emailbrasil' -A tabela_'_sar'.txt'
'!mv tabela_'_nsar'.txt 'dirsar'/tabelas/tabela_'_nsar'.txt'

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
'open '%_arqatm
say 'Escrevendo o TEMPO'

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
ta=ta+1
endwhile

say tempo

meteo=write('tabela_'_nsar'.txt','TEMPO,'tempo'')
return

*################################################################################
* Fim da funcao TEMPO
*################################################################################

*=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=

*################################################################################
* Inicio da funcao TEMP2M
*################################################################################

function temp2m(args)
'reinit'

* Abrindo os arquivos dos modelos
'open '%_arqatm
say 'Escrevendo o T2M'

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

'd t2m'
temp2m=subwrd(result,4)-273.15
temp2m=math_format('%2.1f',temp2m)

if(ta=_ti)
tempo=tempt
temp2ms=temp2m
endif
if(ta>_ti)
tempo=tempo','tempt
temp2ms=temp2ms','temp2m
endif

ta=ta+1
endwhile

say temp2ms
*say temperaturasmax

*meteo=write('tabela_'_nsar'.txt','TAIR TEMP,'tempo'')
meteo=write('tabela_'_nsar'.txt','TEMP AR,'temp2ms'')
return

*################################################################################
* Fim da funcao TEMP2M
*################################################################################

*=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=

*################################################################################
* Inicio da funcao VENTO 10m (dir e int)
*################################################################################

function vento10m(args)
'reinit'

* Abrindo os arquivos dos modelos
'open '%_arqatm
say 'Escrevendo o V10M'


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

'define dirvento10m=(57.3*atan2(u_10m,v_10m)+180)'
'd dirvento10m'
dirvento10m=subwrd(result,4)
dirvento10m=math_format('%3.0f',dirvento10m)

'define intvento10m=mag(U_10m*1.94,V_10m*1.94)'
'd intvento10m'
intvento10m=subwrd(result,4)
intvento10m=math_format('%3.0f',intvento10m)

dirintvento10m=dirvento10m'-'intvento10m

* Criando as STRINGS com os dados de vento
if(ta=_ti)
tempo=tempt
dirvento10ms=dirvento10m
intvento10ms=intvento10m
dirintvento10ms=dirintvento10m
endif
if(ta>_ti)
tempo=tempo','tempt
dirvento10ms=dirvento10ms','dirvento10m
intvento10ms=intvento10ms','intvento10m
dirintvento10ms=dirintvento10ms','dirintvento10m
endif

ta=ta+1
endwhile

say dirintvento10ms

meteo=write('tabela_'_nsar'.txt','VENTOS,'dirintvento10ms'')
return

*################################################################################
* Fim da funcao VENTO 10m (dir e int)
*################################################################################

*=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=

*################################################################################
* Fim da funcao ONDAS (hs e dp)
*################################################################################

function ondas(args)
'reinit'

* Abrindo o arquivo de ondas
'open '%_arqond
say 'Escrevendo o ONDAS'

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
'set t 'ta

'q time'
tempt=subwrd(result,3)

* Convertendo de radianos para graus. Usando a direcao de pico (dp) como REF
'define u =cos(dp)'
'define v =sin(dp)'
'define dironda=(57.325*atan2(-u,-v))'
'd dironda'
dironda=subwrd(result,4)
* Convertendo coord lon para ficar REF inicando em Leste (so o modond precisa disso)
if(dironda<=0)
dironda=360+dironda
endif
dironda=math_format('%3.0f',dironda)

'd hs'
onda=subwrd(result,4)
onda=math_format('%2.1f',onda)

dirhs=dironda'-'onda

if(ta=_ti)
tempo=tempt
dirondas=dironda
ondas=onda
dirhss=dirhs
endif
if(ta>_ti)
tempo=tempo','tempt
dirondas=dirondas','dironda
ondas=ondas','onda
dirhss=dirhss','dirhs
endif

ta=ta+1
endwhile

say dirhss

meteo=write('tabela_'_nsar'.txt','ONDAS,'dirhss'')
return

*################################################################################
* Fim da funcao ONDAS (hs e dp)
*################################################################################

*=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=

*################################################################################
* Inicio da funcao TSM
*################################################################################
function tsm(args)
'reinit'

* Abrindo o arquivo de TSM
'open '%_arqoce
say 'Escrevendo o TSM'

lat1=subwrd(args,1)
lon1=subwrd(args,2)
'set lat 'lat1
'set lon 'lon1

ta=_ti

*tsms=' '
while(ta<=_tf)

'set t 'ta

'q time'
tempt=subwrd(result,3)

'd temperature'
tsm=subwrd(result,4)
tsm=math_format('%2.1f',tsm)


if(ta=_ti)
tempo=tempt
tsms=tsm
endif
if(ta>_ti)
tempo=tempo','tempt
tsms=tsms','tsm
endif

ta=ta+1
endwhile

say tsms

*meteo=write('tabela_'_nsar'.txt',''lat1';'lon1';TTSM;'tempo'')
meteo=write('tabela_'_nsar'.txt','TSM,'tsms'')
return

*################################################################################
* Fim da funcao TSM
*################################################################################

*=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=

*################################################################################
* Inicio da funcao CORRENTE
*################################################################################
function corrente(args)
'reinit'

* Abrindo o arquivo
'open '%_arqoce
say 'Escrevendo o CORRENTE'

lat1=subwrd(args,1)
lon1=subwrd(args,2)
'set lat 'lat1
'set lon 'lon1

ta=_ti

*correntes=' '
while(ta<=_tf)
'set t 'ta

'q time'
tempt=subwrd(result,3)

* Calculando direcao de corrente em graus
'define dircorr=(57.325*atan2(u,v)+180)'
'd dircorr'
dircorr=subwrd(result,4)
if(dircorr<=0)
dircorr=360+dircorr
endif
dircorr=math_format('%3.0f',dircorr)

'd mag(u*1.94384,v*1.94384)'
corrente=subwrd(result,4)
corrente=math_format('%2.1f',corrente)

dircorrente=dircorr'-'corrente

if(ta=_ti)
tempo=tempt
dircorrs=dircorr
correntes=corrente
dircorrentes=dircorrente
endif
if(ta>_ti)
tempo=tempo','tempt
dircorrs=dircorrs','dircorr
correntes=correntes','corrente
dircorrentes=dircorrentes','dircorrente
endif

ta=ta+1
endwhile

say dircorrentes

meteo=write('tabela_'_nsar'.txt','CORRENTES,'dircorrentes'')
return

*################################################################################
* Fim da funcao CORRENTE
*################################################################################
