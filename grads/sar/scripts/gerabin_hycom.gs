'reinit'
say 'Serao gerados dados para a Rodada: 'MODEL' 'AMDHH
'sdfopen MODEL.nc'
var1="VAR1"
var2="VAR2"
var3="VAR3"
tf=TF
tint=TINT

**********************************
tempo=1
while (tempo<=tf)
tcal=(tempo-1)*6
'!caldate 'AMD' + 'tcal'h yyyymmddhh > dataprog'
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
'set t 'tempo
'set z 33'

say 'A variavel eh='var1
'set gxout fwrite'
'set fwrite -sq MODEL_met_'%aaaa%mm%dd%prog'.bin'
'd 'var1
'disable fwrite'

say 'A variavel eh='var2
'set gxout fwrite'
'set fwrite -sq -ap MODEL_met_'%aaaa%mm%dd%prog'.bin'
'd 'var2
'disable fwrite'

say 'A variavel eh='var3
'set gxout fwrite'
'set fwrite -sq -ap MODEL_met_'%aaaa%mm%dd%prog'.bin'
'd 'var3
'disable fwrite'

tempo=tempo+tint
endwhile

'quit'
return (AMD)

