*'open ~/grads/cosmo/cosmomet/ctl/ctl00/cosmo_met_00_M.ctl'
'open cosmo_met_00_M.ctl'

tempo=1
while (tempo<=)

'set t 1'
'set gxout fwrite'
'set fwrite -sq cosmo_met_2019082300.dat'
'd u_10m'
'disable fwrite'
'set fwrite -sq -ap cosmo_met_2019082300.dat'
'd v_10m'
'disable fwrite'

'set t 3'
'set gxout fwrite'
'set fwrite  -sq cosmo_met_2019082306.dat'
'd u_10m'
'disable fwrite'
'set fwrite -sq -ap cosmo_met_2019082306.dat'
'd v_10m'
'disable fwrite'

'quit'
