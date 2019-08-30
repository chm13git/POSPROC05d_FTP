* Alterar o nome da função ACD com o modelo
function geradatcosmo(args)

_datai=subwrd(args,1)
_hh=substr(_datai,9,2)

'reinit'

say 'Serao gerados dados para a Rodada: '_datai

* Entrar com o nome do arq com todos os prog a ser aberto pelo GRADS
arq='cosmo_met_'_hh'_M.ctl'

'open 'arq
*'sdfopen 'arqnc

* Inserir o tempo do modelo equivalente ao prog 96h
tf=33

* Inserir o tempo de intervalo para que o prog fique de 6h/6h
tint=2


tempo=1
while (tempo<=tf)

tcal=(tempo-1)*3
'!caldate '%_datai' + 'tcal'h yyyymmddhh > dataprog'
rc=read(dataprog)
data=sublin(rc,2)
rc=close(dataprog)
say data
'!rm dataprog'

aaaa=substr(data,1,4)
mm=substr(data,5,2)
dd=substr(data,7,2)
prog=substr(data,9,2)

* Removendo DAT dos prog a serem escritos
'!rm cosmo_met_'%aaaa%mm%dd%prog'.dat'

'set t 'tempo
'set gxout fwrite'
* Entrar com o nome do arq DAT (cosmo_met, ww3icon_met ou hycom112_met)
'set fwrite -sq cosmo_met_'%aaaa%mm%dd%prog'.dat'
* Entrar com variavel 1
'd u_10m*1.94384'
'disable fwrite'
* Entrar com variavel 2
'set fwrite -sq -ap cosmo_met_'%aaaa%mm%dd%prog'.dat'
'd v_10m*1.94384'
'disable fwrite'
* Entrar com variavel 3
'set fwrite -sq -ap cosmo_met_'%aaaa%mm%dd%prog'.dat'
'd t2m-273.15'
'disable fwrite'

tempo=tempo+tint
endwhile

'quit'
return (_datai)

