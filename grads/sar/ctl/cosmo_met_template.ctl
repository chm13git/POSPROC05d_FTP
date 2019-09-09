dset /home/operador/grads/sar/dat/cosmo_met_%y4%m2%d2%h2.dat
undef 9.999E+20
title Files cosmo_met
options template
options sequential
xdef 866  linear -71.969 0.0625
ydef 1039 linear -49.9   0.0625
zdef 1 levels 1
tdef 123 linear HHZDDMMANO 6hr
vars 3 
u_10m	0 9,9	vento zonal (m/s)
v_10m	0 9,9	vento meridional (m/s)
t2m	0 11	2m Temperature (K)
endvars
