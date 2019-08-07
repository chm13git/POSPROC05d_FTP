'reinit'
*MET script 
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

*OIAPOQUE 
'c'
'set lat 3.13'
'set lon 309.87'
plota()
'draw string 4.2 10.8 OIAPOQUE '
'draw string 4.2 10.3 lat: 3.13 lon: -50.13 (91km da costa)'
'draw string 4.2 9.8 Ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_OIAPOQUE.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_OIAPOQUE.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_OIAPOQUE.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_OIAPOQUE.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3car00/ondograma_OIAPOQUE.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3car00/ondograma_OIAPOQUE.jpg'

*FOZ_AMAZON   
'c'
'set lat 0.08'
'set lon 310.98'
plota()
'draw string 4.2 10.8 FOZ AMAZONAS '
'draw string 4.2 10.3 lat: 0.08 lon: -49.02 (27km da costa)'
'draw string 4.2 9.8 Ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_FOZ_AMAZON.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_FOZ_AMAZON.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_FOZ_AMAZON.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_FOZ_AMAZON.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3car00/ondograma_FOZ_AMAZON.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3car00/ondograma_FOZ_AMAZON.jpg'

*SPED_SPAUL    
'c'
'set lat 0.91'
'set lon 330.65'
plota()
'draw string 4.2 10.8 SAO PEDRO SAO PAULO '
'draw string 4.2 10.3 lat: 0.91 lon: -29.35 '
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_SPED_SPAUL.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_SPED_SPAUL.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_SPED_SPAUL.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_SPED_SPAUL.jpg'

*PIRATA_1 
'c'
'set lat 0.02'
'set lon 325.04'
plota()
'draw string 4.2 10.8 PIRATA_1'
'draw string 4.2 10.3 lat: 0.02 lon: -34.96 (560km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_PIRATA_1.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_PIRATA_1.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_PIRATA_1.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_PIRATA_1.jpg'

*SALINOPOLIS
'c'
'set lat -0.07'
'set lon 312.93'
plota()
'draw string 4.2 10.8 SALINOPOLIS '
'draw string 4.2 10.3 lat: -0.07 lon: -47.07 (60km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_SALINOPOLIS.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_SALINOPOLIS.jpg'  
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_SALINOPOLIS.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_SALINOPOLIS.jpg' 

*SAO_LUIZ
'c'
'set lat -1.05'
'set lon 316.23'
plota()
'draw string 4.2 10.8 SAO LUIZ '
'draw string 4.2 10.3 lat: -1.05 lon: -43.77 (150km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_SAO_LUIZ.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_SAO_LUIZ.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_SAO_LUIZ.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_SAO_LUIZ.jpg'

*FORTALEZA  
'c'
'set lat -3.07'
'set lon 321.93'
plota()
'draw string 4.2 10.8 FORTALEZA'
'draw string 4.2 10.3  lat: -3.07 lon: -38.07 (80km da costa)'
'draw string 4.2 9.8  ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_FORTALEZA.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_FORTALEZA.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_FORTALEZA.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_FORTALEZA.jpg'

*F_NORONHA  
'c'
'set lat -3.85'
'set lon 327.58'
plota()
'draw string 4.2 10.8 FERNANDO DE NORONHA'
'draw string 4.2 10.3  lat: -3.85 lon: -32.42'
'draw string 4.2 9.8  ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_F_NORONHA.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_F_NORONHA.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_F_NORONHA.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_F_NORONHA.jpg'

*TOUROS 
'c'
'set lat -5.09'
'set lon 324.81'
plota()
'draw string 4.2 10.8 TOUROS'
'draw string 4.2 10.3  lat: -5.09 lon: -35.19 (27km da costa)'
'draw string 4.2 9.8  ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_TOUROS.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_TOUROS.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_TOUROS.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_TOUROS.jpg'

*NATAL  
'c'
'set lat -5.75'
'set lon 325.1'
plota()
'draw string 4.2 10.8 NATAL'
'draw string 4.2 10.3 lat: -5.75 lon: -34.9 (27km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_NATAL.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_NATAL.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_NATAL.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_NATAL.jpg'

*CABEDELO  
'c'
'set lat -6.97'
'set lon 325.42'
plota()
'draw string 4.2 10.8 CABEDELO '
'draw string 4.2 10.3 lat: -6.97 lon: -34.58 (28km da costa)'
'draw string 4.2 9.8  ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_CABEDELO.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_CABEDELO.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_CABEDELO.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_CABEDELO.jpg'

*PIRATA_2  
'c'
'set lat -7.91'
'set lon 329.51'
plota()
'draw string 4.2 10.8 PIRATA_2'
'draw string 4.2 10.3  lat: -7.91 lon: -30.49 (479km da costa)'
'draw string 4.2 9.8  ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_PIRATA_2.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_PIRATA_2.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_PIRATA_2.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_PIRATA_2.jpg'

*RECIFE   
'c'
'set lat -8.05'
'set lon 325.37'
plota()
'draw string 4.2 10.8 RECIFE'
'draw string 4.2 10.3 lat: -8.05 lon: -34.63 (28km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_RECIFE.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_RECIFE.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_RECIFE.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_RECIFE.jpg'

*PNBOIA_REC   
'c'
'set lat -8.16'
'set lon 325.44'
plota()
'draw string 4.2 10.8 PNBOIA_RECIFE'
'draw string 4.2 10.3 lat: -8.16 lon: -34.56 (31km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_PNBOIA_REC.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_PNBOIA_REC.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_PNBOIA_REC.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_PNBOIA_REC.jpg'

*TAMANDARE   
'c'
'set lat -8.75'
'set lon 325.15'
plota()
'draw string 4.2 10.8 TAMANDARE'
'draw string 4.2 10.3 lat: -8.75 lon: -34.85 (23km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_TAMANDARE.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_TAMANDARE.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_TAMANDARE.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_TAMANDARE.jpg'


*MACEIO    
'c'
'set lat -9.65'
'set lon 324.6'
plota()
'draw string 4.2 10.8 MACEIO'
'draw string 4.2 10.3 lat: -9.65 lon: -35.4 (29km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_MACEIO.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_MACEIO.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_MACEIO.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_MACEIO.jpg'

*ARACAJU   
'c'
'set lat -10.90'
'set lon 323.43'
plota()
'draw string 4.2 10.8 ARACAJU '
'draw string 4.2 10.3 lat: -10.90 lon: -36.57 (37km da costa) '
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_ARACAJU.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_ARACAJU.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_ARACAJU.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_ARACAJU.jpg'

*BOIA ARACAJU   
'c'
'set lat -10.86'
'set lon 323.13'
plota()
'draw string 4.2 10.8 ARACAJU 2'
'draw string 4.2 10.3 lat: -10.86 lon: -36.87 (8km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_ARACAJU2.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_ARACAJU2.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_ARACAJU2.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_ARACAJU2.jpg'

*SALVADOR  
'c'
'set lat -13.43'
'set lon 321.55'
plota()
'draw string 4.2 10.8 SALVADOR'
'draw string 4.2 10.3 lat: -13.43 lon: -38.45 (47km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_SALVADOR.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_SALVADOR.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_SALVADOR.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_SALVADOR.jpg'

*PIRATA_3
'c'
'set lat -13.56'
'set lon 327.39'
plota()
'draw string 4.2 10.8 PIRATA_3'
'draw string 4.2 10.3 lat: -13.56 lon: -32.61 (560km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_PIRATA_3.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_PIRATA_3.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_PIRATA_3.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_PIRATA_3.jpg'

*ILHEUS 
'c'
'set lat -14.78'
'set lon 321.3'
plota()
'draw string 4.2 10.8 ILHEUS'
'draw string 4.2 10.3 lat: -14.78 lon: -38.7 (33km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_ILHEUS.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_ILHEUS.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_ILHEUS.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_ILHEUS.jpg'

*PORTO_SEGU
'c'
'set lat -16.45'
'set lon 321.25'
plota()
'draw string 4.2 10.8 PORTO SEGURO'
'draw string 4.2 10.3 lat: -16.45 lon: -38.75 (30km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_PORTO_SEGU.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_PORTO_SEGU.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_PORTO_SEGU.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_PORTO_SEGU.jpg'

*PNBOIA_P_S 
'c'
'set lat -15.99'
'set lon 322.07'
plota()
'draw string 4.2 10.8 PNBOIA_P_S'
'draw string 4.2 10.3 lat: -15.99 lon: -37.93 (100km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_PNBOIA_P_S.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_PNBOIA_P_S.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_PNBOIA_P_S.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_PNBOIA_P_S.jpg'

*ABROLHOS
'c'
'set lat -17.95'
'set lon 321.3'
plota()
'draw string 4.2 10.8 ABROLHOS'
'draw string 4.2 10.3 lat: -17.95 lon: -38.7 (57km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_ABROLHOS.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_ABROLHOS.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_ABROLHOS.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3ne00/ondograma_ABROLHOS.jpg'

*PIRATA_4
'c'
'set lat -18.92'
'set lon 325.31'
plota()
'draw string 4.2 10.8 PIRATA_4'
'draw string 4.2 10.3 lat: -18.92 lon: -34.69 (530km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_PIRATA_4.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_PIRATA_4.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_PIRATA_4.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_PIRATA_4.jpg'

*VITORIA
'c'
'set lat -20.32'
'set lon 320.17'
plota()
'draw string 4.2 10.8 VITORIA'
'draw string 4.2 10.3 lat: -20.32 lon: -39.83 (47km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_VITORIA.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_VITORIA.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_VITORIA.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_VITORIA.jpg'

*ITAOCA 
'c'
'set lat -20.97'
'set lon 319.43'
plota()
'draw string  4.2 10.8 ITAOCA'
'draw string 4.2 10.3 lat: -20.97 lon: -40.57 (25km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_ITAOCA.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_ITAOCA.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_ITAOCA.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_ITAOCA.jpg'

*MARATAIZES 
'c'
'set lat -21.08'
'set lon 319.76'
plota()
'draw string 4.2 10.8 MARATAIZES'
'draw string 4.2 10.3 lat: -21.08 lon: -40.24 (60km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_MARATAIZES.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_MARATAIZES.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_MARATAIZES.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_MARATAIZES.jpg'

*SAO_TOME 
'c'
'set lat -22.44'
'set lon 319.56'
plota()
'draw string 4.2 10.8 SAO TOME'
'draw string 4.2 10.3 lat: -22.44 lon: -40.44 (77km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_SAO_TOME.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_SAO_TOME.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_SAO_TOME.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_SAO_TOME.jpg'

*CABO_FRIO 
'c'
'set lat -22.97'
'set lon 318.2'
plota()
'draw string 4.2 10.8 CABO FRIO'
'draw string 4.2 10.3 lat: -22.97 lon: -41.8 (25km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_CABO_FRIO.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_CABO_FRIO.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_CABO_FRIO.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_CABO_FRIO.jpg'

*TRINDADE 
'c'
'set lat -20.50'
'set lon 330.68'
plota()
'draw string 4.2 10.8 TRINDADE'
'draw string 4.2 10.3 lat: -20.5 lon: -29.32 (1141km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_TRINDADE.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_TRINDADE.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_TRINDADE.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_TRINDADE.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_TRINDADE.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_TRINDADE.jpg'

*RIO_JANEIR
'c'
'set lat -23.08'
'set lon 316.97'
plota()
'draw string 4.2 10.8 RIO DE JANEIRO'
'draw string 4.2 10.3 lat: -23.08 lon: -43.03 (11km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_RIO_JANEIR.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_RIO_JANEIR.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_RIO_JANEIR.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_RIO_JANEIR.jpg'

*ILHAGRANDE
'c'
'set lat -23.77'
'set lon 316.00'
plota()
'draw string 4.2 10.8 ILHA GRANDE'
'draw string 4.2 10.3 lat: -23.77 lon: -44.00 (70km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_ILHAGRANDE.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_ILHAGRANDE.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_ILHAGRANDE.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_ILHAGRANDE.jpg'

*SAO_SEBAST   
'c'
'set lat -24.27'
'set lon 315.29'
plota()
'draw string 4.2 10.8 SAO SEBASTIAO'
'draw string 4.2 10.3 lat: -24.27 lon: -44.71 (70km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_SAO_SEBAST.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_SAO_SEBAST.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_SAO_SEBAST.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_SAO_SEBAST.jpg'

*SANTOS 
'c'
'set lat -24.38'
'set lon 314.09'
plota()
'draw string 4.2 10.8 SANTOS'
'draw string 4.2 10.3 lat: -24.38 lon: -45.91 (58km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_SANTOS.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_SANTOS.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_SANTOS.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_SANTOS.jpg'

*PERUIBE  
'c'
'set lat -24.31'
'set lon 313.66'
plota()
'draw string 4.2 10.8 PERUIBE'
'draw string 4.2 10.3 lat: -24.31 lon: -46.34 (37km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_PERUIBE.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_PERUIBE.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_PERUIBE.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_PERUIBE.jpg'

*IGUAPE  
'c'
'set lat -25.02'
'set lon 312.92'
plota()
'draw string 4.2 10.8 IGUAPE'
'draw string 4.2 10.3  lat: -25.02 lon: -47.08 (50km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_IGUAPE.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_IGUAPE.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_IGUAPE.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_IGUAPE.jpg'

*CANANEIA  
'c'
'set lat -25.23'
'set lon 312.6'
plota()
'draw string  4.2 10.8 CANANEIA'
'draw string 4.2 10.3  lat: -25.23 lon: -47.4 (48km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_CANANEIA.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_CANANEIA.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_CANANEIA.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_CANANEIA.jpg'

*PNBOIA_STS  
'c'
'set lat -25.28'
'set lon 315.07'
plota()
'draw string  4.2 10.8 PNBOIA_STS'
'draw string 4.2 10.3  lat: -25.28 lon: -44.93 (190km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_PNBOIA_STS.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_PNBOIA_STS.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_PNBOIA_STS.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_PNBOIA_STS.jpg'

*ILHA_MEL  
'c'
'set lat -25.70'
'set lon 312.13'
plota()
'draw string  4.2 10.8 ILHA DO MEL'
'draw string 4.2 10.3  lat: -25.7 lon: -47.87 (45km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_ILHA_MEL.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_ILHA_MEL.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_ILHA_MEL.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_ILHA_MEL.jpg'


*GUARATUBA  
'c'
'set lat -25.87'
'set lon 311.88'
plota()
'draw string  4.2 10.8 GUARATUBA'
'draw string 4.2 10.3  lat: -25.87 lon: -48.12 (40km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_GUARATUBA.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_GUARATUBA.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_GUARATUBA.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_GUARATUBA.jpg'

*S_FRAN_SUL 
'c'
'set lat -26.23'
'set lon 311.8'
plota()
'draw string  4.2 10.8 SAO FRANCISCO DO SUL'
'draw string 4.2 10.3  lat: -26.23 lon: -48.2 (28km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_S_FRAN_SUL.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_S_FRAN_SUL.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_S_FRAN_SUL.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_S_FRAN_SUL.jpg'

*ITAJAI   
'c'
'set lat -26.92'
'set lon 311.92'
plota()
'draw string   4.2 10.8 ITAJAI'
'draw string 4.2 10.3 lat: -26.92 lon: -48.08 (56km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_ITAJAI.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_ITAJAI.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_ITAJAI.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_ITAJAI.jpg'

*FLORIPA   
'c'
'set lat -27.55'
'set lon 312.03'
plota()
'draw string  4.2 10.8  FLORIANOPOLIS'
'draw string 4.2 10.3  lat: -27.55 lon: -47.97 (40km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_FLORIPA.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_FLORIPA.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_FLORIPA.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_FLORIPA.jpg'

*PNBOIA_SC   
'c'
'set lat -27.4'
'set lon 312.74'
plota()
'draw string  4.2 10.8  PNBOIA_SC'
'draw string 4.2 10.3  lat: -27.4 lon: -47.26 (108km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_PNBOIA_SC.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_PNBOIA_SC.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_PNBOIA_SC.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_PNBOIA_SC.jpg'

*GAROPABA   
'c'
'set lat -28.03'
'set lon 311.75'
plota()
'draw string  4.2 10.8  GAROPABA'
'draw string 4.2 10.3  lat: -28.03 lon: -48.25 (35km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_GAROPABA.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_GAROPABA.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_GAROPABA.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_GAROPABA.jpg'

*STA_MARTA 
'c'
'set lat -28.64'
'set lon 311.56'
plota()
'draw string  4.2 10.8 SANTA MARTA'
'draw string 4.2 10.3 lat: -28.64 lon: -48.44 (33km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_STA_MARTA.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_STA_MARTA.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_STA_MARTA.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_STA_MARTA.jpg'

*BAL_RINCAO  
'c'
'set lat -28.85'
'set lon 311.13'
plota()
'draw string  4.2 10.8  BALNEARIO RINCAO'
'draw string 4.2 10.3 lat: -28.85 lon: -48.87 (22km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_BAL_RINCAO.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_BAL_RINCAO.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_BAL_RINCAO.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_BAL_RINCAO.jpg'

*TORRES  
'c'
'set lat -29.35'
'set lon 310.63'
plota()
'draw string  4.2 10.8  TORRES'
'draw string 4.2 10.3 lat: -29.35 lon: -49.37 (29km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_TORRES.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_TORRES.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_TORRES.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_TORRES.jpg'

*TRAMANDAI  
'c'
'set lat -30.01'
'set lon 310.32'
plota()
'draw string  4.2 10.8  TRAMANDAI'
'draw string 4.2 10.3 lat: -30.01 lon: -49.68 (43km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_TRAMANDAI.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_TRAMANDAI.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_TRAMANDAI.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_TRAMANDAI.jpg'

*PNBOIA_RG  
'c'
'set lat -31.59'
'set lon 310.12'
plota()
'draw string  4.2 10.8  PNBOIA_RG'
'draw string 4.2 10.3 lat: -31.59 lon: -49.88 (98km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_PNBOIA_RG.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_PNBOIA_RG.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_PNBOIA_RG.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_PNBOIA_RG.jpg'

*MOSTARDAS  
'c'
'set lat -31.15'
'set lon 309.65'
plota()
'draw string  4.2 10.8  MOSTARDAS'
'draw string 4.2 10.3 lat: -31.15 lon: -50.35 (35km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_MOSTARDAS.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_MOSTARDAS.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_MOSTARDAS.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_MOSTARDAS.jpg'

*RIO_GRANDE
'c'
'set lat -32.18'
'set lon 308.3'
plota()
'draw string 4.2 10.8 RIO GRANDE'
'draw string 4.2 10.3 lat: -32.18 lon: -51.7 (33km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_RIO_GRANDE.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_RIO_GRANDE.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_RIO_GRANDE.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_RIO_GRANDE.jpg'

*CHUI 
'c'
'set lat -33.81'
'set lon 307.53'
plota()
'draw string  4.2 10.8  CHUI'
'draw string 4.2 10.3 lat: -33.81 lon: -52.47 (65km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_CHUI.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_CHUI.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_CHUI.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3sse00/ondograma_CHUI.jpg'

*B01 
'c'
'set lat 14.59'
'set lon 321.99'
plota()
'draw string 4.2 10.8 B01'
'draw string 4.2 10.3 lat: 14.59 lon: -38.01'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_B01.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_B01.jpg'

*B02 
'c'
'set lat 11.30'
'set lon 321.98'
plota()
'draw string 4.2 10.8 B02'
'draw string 4.2 10.3 lat: 11.30 lon: -38.02'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_B02.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_B02.jpg'

*B03 
'c'
'set lat 07.54'
'set lon 321.93'
plota()
'draw string 4.2 10.8 B03'
'draw string 4.2 10.3 lat: 07.54 lon: -38.07'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_B03.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_B03.jpg'


*B04 
'c'
'set lat 04.00'
'set lon 322.44'
plota()
'draw string  4.2 10.8  B04'
'draw string 4.2 10.3 lat: 04.00 lon: -37.56 (800km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_B04.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_B04.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_B04.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_B04.jpg'

*B05 
'c'
'set lat 00.01'
'set lon 325.43'
plota()
'draw string  4.2 10.8  B05'
'draw string 4.2 10.3 lat: 00.01 lon: -34.57 (590km da costa)' 
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_B05.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_B05.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_B05.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_B05.jpg'

*B06 
'c'
'set lat -07.02'
'set lon 326.63'
plota()
'draw string  4.2 10.8  B06'
'draw string 4.2 10.3 lat: -07.02 lon: -33.37 (150km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_B06.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_B06.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_B06.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_B06.jpg'

*B07 
'c'
'set lat -13.32'
'set lon 327.64'
plota()
'draw string  4.2 10.8  B07'
'draw string 4.2 10.3 lat: -13.32 lon: -32.36 (545km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_B07.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_B07.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_B07.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_B07.jpg'

*B08 
'c'
'set lat -18.52'
'set lon 325.59'
plota()
'draw string  4.2 10.8  B08'
'draw string 4.2 10.3 lat: -18.52 lon: -34.41 (505km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_B08.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_B08.jpg'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_B08.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_B08.jpg'

*LHFC_W 
'c'
'set lat -23.28'
'set lon 316.05'
plota()
'draw string  4.2 10.8  LHFC_W'
'draw string 4.2 10.3 lat: -23.28 lon: -43.95 (25km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_LHFC_W.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_LHFC_W.jpg'

*LHFC_E 
'c'
'set lat -23.23'
'set lon 316.40'
plota()
'draw string  4.2 10.8  LHFC_E'
'draw string 4.2 10.3 lat: -23.23 lon: -43.60 (21km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_LHFC_E.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3met00/ondograma_LHFC_E.jpg'


*GUYANA 
'c'
'set lat 9.50'
'set lon 303'
plota()
'draw string 4.2 10.8 GUYANA'
'draw string 4.2 10.3 lat: 9.50  lon: -57.0 (260km da costa)'
'draw string 4.2 9.8  ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3car00/ondograma_GUYANA.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3car00/ondograma_GUYANA.jpg'

*PARAMARIBO
'c'
'set lat 6.44'
'set lon 304.78'
plota()
'draw string 4.2 10.8 PARAMARIBO'
'draw string 4.2 10.3 lat: 6.44  lon: -55.22 (33km da costa)'
'draw string 4.2 9.8  ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3car00/ondograma_PARAMARIBO.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3car00/ondograma_PARAMARIBO.jpg'

*FORTLAUDER
'c'
'set lat 26.05'
'set lon 279.93'
plota()
'draw string 4.2 10.8 FORT LAUDERDALE'
'draw string 4.2 10.3 lat: 26.05  lon: -80.07 (8km da costa)'
'draw string 4.2 9.8  ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3car00/ondograma_FORTLAUDER.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3car00/ondograma_FORTLAUDER.jpg'

*PORTOPRINCI
'c'
'set lat 18.59'
'set lon 287.26'
plota()
'draw string 4.2 10.8 PORTO PRINCIPE'
'draw string 4.2 10.3 lat: 18.67  lon: -72.74 (11km da costa)'
'draw string 4.2 9.8  ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3car00/ondograma_PORTOPRINCI.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3car00/ondograma_PORTOPRINCI.jpg'


*GRANADA 
'c'
'set lat 12.02'
'set lon 298.55'
plota()
'draw string 4.2 10.8 GRANADA'
'draw string 4.2 10.3 lat: 12.02  lon: -61.45 (20km da costa)'
'draw string 4.2 9.8  ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3car00/ondograma_GRANADA.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3car00/ondograma_GRANADA.jpg'


*HAITI
'c'     
'set lat  19.00'
'set lon  286'
plota()
'draw string 4.2 10.8 HAITI'
'draw string 4.2 10.3 lat: 19.0 lon: -74.0 (71km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_HAITI.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_HAITI.jpg'


*SPED_SPA   
'c'
'set lat 0.80'
'set lon 330.9'
plota()
'draw string 4.2 10.8 SAO PEDRO SAO PAULO'
'draw string 4.2 10.3 lat: 0.8 lon: -29.1'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_SPED_SPA.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_SPED_SPA.jpg'

*FERNOR 
'c'
'set lat -3.70'
'set lon 327.6'
plota()
'draw string 4.2 10.8 FERNANDO DE NORONHA'
'draw string 4.2 10.3 lat: -3.7 lon: -32.4'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_FERNOR.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_FERNOR.jpg'

*TRINDADE 
'c'
'set lat -20.50'
'set lon 330.6'
plota()
'draw string 4.2 10.8 TRINDADE'
'draw string 4.2 10.3 lat: -20.5 lon: -29.4'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_TRINDADE.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_TRINDADE.jpg'

*MONTEVIDEU 
'c'
'set lat -35.04'
'set lon 304.43'
plota()
'draw string 4.2 10.8 MONTEVIDEU'
'draw string 4.2 10.3 lat: -35.04 lon: -55.57 (35km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_MONTEVIDEU.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_MONTEVIDEU.jpg'

*MARDELPLATA 
'c'
'set lat -38.00'
'set lon 302.82'
plota()
'draw string 4.2 10.8 MAR DEL PLATA'
'draw string 4.2 10.3 lat: -38.00 lon: -57.18 (33km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_MARDELPLATA.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_MARDELPLATA.jpg'

*DRAKE   
'c'     
'set lat  -59.00'
'set lon  298'
plota()
'draw string 4.2 10.8 DRAKE'
'draw string 4.2 10.3 lat: -59.0 lon: -62.0 (500km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_DRAKE.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_DRAKE.jpg'


*EACF  
'c'     
'set lat  -62.00'
'set lon  302'
plota()
'draw string 4.2 10.8 EACF'
'draw string 4.2 10.3 lat: -62.00 lon: -58.00'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_EACF.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_EACF.jpg'


*MALVINAS_W
'c'     
'set lat  -52.00'
'set lon  295'
plota()
'draw string 4.2 10.8 MALVINAS_W'
'draw string 4.2 10.3 lat: -52.0 lon: -65.0 (260km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_MALVINAS_W.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_MALVINAS_W.jpg'

*MALVINAS_E
'c'     
'set lat -52.00 '
'set lon 308'
plota()
'draw string 4.2 10.8 MALVINAS_E'
'draw string 4.2 10.3 lat: -52.0 lon: -52.0 (385km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_MALVINAS_E.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_MALVINAS_E.jpg'

*NW_N_OCE  
'c'
'set lat 7.10'
'set lon 320.4'
plota()
'draw string 4.2 10.8 NW_N_OCE'
'draw string 4.2 10.3 lat: 7.1 lon: -39.6 (1050km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_NW_N_OCE.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_NW_N_OCE.jpg'

*NE_N_OCE   
'c'
'set lat 7.10'
'set lon 339.9'
plota()
'draw string 4.2 10.8 NE_N_OCE'
'draw string 4.2 10.3 lat: 7.1 lon: -20.1 (2077km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_NE_N_OCE.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_NE_N_OCE.jpg'

*HOTEL    
'c'
'set lat 2.60'
'set lon 315'
plota()
'draw string 4.2 10.8 HOTEL'
'draw string 4.2 10.3 lat: 2.6 lon: -45.0 (400km da costa)'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_HOTEL.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_HOTEL.jpg'

*GOLF     
'c'
'set lat -2.50'
'set lon 324.9'
plota()
'draw string 4.2 10.8 GOLF'
'draw string 4.2 10.3 lat: -2.5 lon: -35.1'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_GOLF.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_GOLF.jpg'

*S_N_OCEA 
'c'
'set lat -10.00'
'set lon 339.9'
plota()
'draw string 4.2 10.8 S_N_OCEA'
'draw string 4.2 10.3 lat: -10.0 lon: -20.1'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_S_N_OCEA.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_S_N_OCEA.jpg'

*N_S_OCEA  
'c'
'set lat -19.90'
'set lon 339.9'
plota()
'draw string 4.2 10.8 N_S_OCEA'
'draw string 4.2 10.3 lat: -19.9 lon: -20.1'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_N_S_OCEA.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_N_S_OCEA.jpg'

*SE_S_OCE 
'c'
'set lat -34.90'
'set lon 339.9'
plota()
'draw string 4.2 10.8 SE_S_OCE'
'draw string 4.2 10.3 lat: -34.9 lon: -20.1'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_SE_S_OCE.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_SE_S_OCE.jpg'

*SW_S_OCE  
'c'
'set lat -34.9'
'set lon 324.9'
plota()
'draw string 4.2 10.8 SW_S_OCE'
'draw string 4.2 10.3 lat: -34.9 lon: -35.1'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_SW_S_OCE.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_SW_S_OCE.jpg'

*FOXTROT 
'c'
'set lat -10.00'
'set lon 327.6'
plota()
'draw string 4.2 10.8 FOXTROT'
'draw string 4.2 10.3 lat: -10.0 lon: -32.4'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_FOXTROT.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_FOXTROT.jpg'

*ECHO   
'c'
'set lat -17.50'
'set lon 324.9'
plota()
'draw string 4.2 10.8 ECHO'
'draw string 4.2 10.3 lat: -17.5 lon: -35.1'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_ECHO.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_ECHO.jpg'

*DELTA    
'c'
'set lat -22.60'
'set lon 322.5'
plota()
'draw string 4.2 10.8 DELTA'
'draw string 4.2 10.3 lat: -22.6 lon: -37.5'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_DELTA.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_DELTA.jpg'

*BRAVO    
'c'
'set lat -27.40'
'set lon 317.4'
plota()
'draw string 4.2 10.8 BRAVO'
'draw string 4.2 10.3 lat: -27.4 lon: -42.6'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_BRAVO.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_BRAVO.jpg'


*ALFA     
'c'
'set lat -32.50'
'set lon 312.6'
plota()
'draw string 4.2 10.8 ALFA'
'draw string 4.2 10.3 lat: -32.5 lon: -47.4'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_ALFA.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_ALFA.jpg'

*62029     
'c'     
'set lat  49.00'
'set lon  348'
plota()
'draw string 4.2 10.8 62029'
'draw string 4.2 10.3 lat: 49.0 lon: -12.0'
'draw string 4.2 9.8 ref: 'var'.'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_62029.gif'
'printim /home/operador/ondogramas/ww3_418/ww3icon/ww3iap00/ondograma_62029.jpg'


'quit'



*---------------------------------------------------
function plota()
'set vpage 0 8 6.7 9.8'
'set cmark 0'
'set grads off'
'set gxout line'
'set ccolor 4'
'set cthick 5'
*'set ylopts 1'
'set cstyle 1'
'set vrange 0 5'
'd HS'
'set ccolor 1'
'set grads off'
'u=(cos(dir)*3.14/180)'
'v=(sin(dir)*3.14/180)'
'd const(u,2.5); u ; v' 
'draw title Alt. significativa (m) e Direcao Media'
*--------------------------------------------------
'set vpage 0 8 3.6 6.7'
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
'set vpage 0 8 0.5 3.6'
'set cmark 0'    
'set grads off'
'set gxout line'
'set ccolor 4'
'set cthick 5'
*'set ylopts 1'
'set cstyle 1'
'set vrange 0 32'
'd mag(uwnd,vwnd)*1.944 ' 
'set ccolor 1'
'd const(uwnd,16); uwnd ; vwnd'                                 
'draw title Vento a 10m (nos)'
'set vpage off'
return


