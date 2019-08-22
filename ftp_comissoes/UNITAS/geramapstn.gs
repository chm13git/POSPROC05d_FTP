'reinit'

*ctldir="/home/gempak/grads/cosmo/ctl"
*dadosdir="/home/gempak/cosmo/dados00"

'sdfopen /mnt/nfs/dpns32/data1/operador/previsao/hycom_2_2/output/Previsao_1_12/Ncdf/20190818/HYCOM_MV_20190818.nc'

'set mpdset brmap_hires.dat'
*'set display color white'
'c'
'set lat -25 -22'
'set lon -45 -42'
'set z 33'
*'set cmin 0'
*'set cmax 0'
'set grads off'
'set gxout shaded'
'd temperature'

'!cat lista | wc -l > nest'
rc=read(nest)
nestacoes=sublin(rc,2)
say 'Numero de Estacoes: 'nestacoes
say ''
rc=close(nest)
'!rm nest'

n=1
while (n<=nestacoes)

'!head -'n' lista | tail -1 > dados.txt'
rc=read(dados.txt)
dados=sublin(rc,2)
rc=close(dados.txt)
* Se nao remover nao funciona!
'!rm dados.txt'
nome=subwrd(dados,1)
*cod=subwrd(dados,2)
lat=subwrd(dados,2)
lon=subwrd(dados,3)
ind=subwrd(dados,4)

say 'Desenhando Estacao '%nome
***Plot info station****
* Ex.: lon=-40.0 e Lat= -20.12
'q w2xy '%lon' '%lat
linhastn=sublin(result,1)
xstn=subwrd(linhastn,3)
ystn=subwrd(linhastn,6)
say xstn" "ystn
'set line 2 1 6'
'draw mark 3 '%xstn' '%ystn' 0.05'
'set strsiz 0.1'
'draw string '%xstn' '%ystn' '%nome

n=n+1
endwhile

'draw title Pontos Corrigidos'
*'printim met5stnmap.gif -t 0 x770 y800 white'
'printim met5stnmap.gif x770 y800 white'

'quit'
