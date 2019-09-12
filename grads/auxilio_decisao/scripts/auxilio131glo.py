#!/home/operador/anaconda3/envs/auxdechycom/bin/python
# -*- coding: utf-8 -*-
# -*- coding: iso-8859-1 -*-
#-----------------------------------------------------#
# AGO2019                                             #
# Autor: 1T(T) Damião e demais oficiais do CH-131     #
#-----------------------------------------------------#

import datetime, time
import os, sys, shutil
from  ww3Funcs import alteraStr, alteraDia, horarios

if len(sys.argv) < 3:
    print('+------------Utilização------------+')
    print('                                    ')
    print(' auxilio131.py DataCorrente ')
    print('                                    ')
    print('  ex: '+sys.argv[0]+' gfs 20160603  ')
    print('+----------------------------------+')
    sys.exit(1)

mod=sys.argv[1]
data = horarios(sys.argv[2])
data = datetime.date(int(data[0]),int(data[1]),int(data[2]))
data_s  = data.strftime('%Y%m%d')
datai = data.strftime('%Y%m%d')

# Delimitando a área de interesse
lat_sul = '-33'   # latitude mais ao sul do recorte desejado
lat_norte = '-7' # latitude mais ao norte do recorte desejado
lon_oeste = '-45'   # longitude mais à oeste do recorte desejado
lon_leste = '-10'   # longitude mais à leste do recorte desejado

import numpy as np
import matplotlib as mpl
mpl.use('Agg') # Force matplotlib to not use any Xwindows backend.
import matplotlib.pylab as plab
from netCDF4 import Dataset
import scipy
from numpy import ma
import os

# Definindo Diretorios
os.getcwd()

ww3dir  ='/mnt/nfs/dpns32/data1/operador/mod_ondas/ww3_418/'
outdirbck=ww3dir+'backup/ww3'+mod+'/'

import numpy as np
import matplotlib as mpl
mpl.use('Agg') # Force matplotlib to not use any Xwindows backend.
import matplotlib.pylab as plab
from netCDF4 import Dataset
import scipy
from numpy import ma
import os


# ----------------------------------------
# Extraindo as variaveis da saida do WW3

nc_f=outdirbck+'ww3'+mod+'_glo_'+str(datai)+'00.nc'
nc_fid=Dataset(nc_f, 'r')
lat=nc_fid.variables['latitude'][:]
lon=nc_fid.variables['longitude'][:]
lon=lon-360
lon_grid,lat_grid=plab.meshgrid(lon,lat)
hs = nc_fid.variables['hs'][:]
dire = nc_fid.variables['dir'][:]
dp = nc_fid.variables['dp'][:]
u=nc_fid.variables['uwnd'][:]
v=nc_fid.variables['vwnd'][:]
u0=np.copy(u)  
v0=np.copy(v)
h0=np.copy(hs)
prg=np.size(u0)
freqpeak = nc_fid.variables['fp'][:] #wave peak frequency
perpeak = 1/freqpeak
p0=np.copy(perpeak)



#A partir daqui é necessário editar______________________________________

# Criando um array dos horários de prognósticos para o título da figura
prog=49
tit_tempo=['00','03','06','09']
for tt in range(12,int(prog),3):
     tit_tempo.append(tt)



# Criando a figura para N prognósticos

from mpl_toolkits.basemap import Basemap
import matplotlib.pyplot as plt
iii=0
print ('')
print ('Total de horas de prognosticos: ',(prog))
print ('')


pt=np.zeros((121,321,720))

for ii in range(0,int(prog),3):
    uu=(u0[ii,:,:])
    vv=(v0[ii,:,:])
    hh=(h0[ii,:,:])
    pp=(perpeak[ii,:,:])
    ptpt=(pt[ii,:,:])
    for i in range(0,321):
        for j in range(0,720):
            if uu[i,j]>1.0e+30:
                uu[i,j]=np.nan
            if vv[i,j]>1.0e+30:
                vv[i,j]=np.nan
            if hh[i,j]>1.0e+30:
                hh[i,j]=np.nan
            if pp[i,j]>1.0e+30:
                pp[i,j]=np.nan
    ww=np.sqrt(uu**2+vv**2)             
    for i in range(0,321):
        for j in range(0,720):
            if ww[i,j] >= 7.5 and ww[i,j] < 10:
                ptpt[i,j]=ptpt[i,j]+3
            if ww[i,j]>=10:
                ptpt[i,j]=ptpt[i,j]+4
            if hh[i,j] >=1 and hh[i,j] <1.5:
                ptpt[i,j]=ptpt[i,j]+3.5
            if hh[i,j] >=1.5 and hh[i,j] <2:
                ptpt[i,j]=ptpt[i,j]+4.5 
            if hh[i,j] >=2:
                ptpt[i,j]=ptpt[i,j]+6.5
            if pp[i,j] >=15:
                ptpt[i,j]=ptpt[i,j]+0.5

   

    fig=plt.figure()
    rect = fig.patch
    rect.set_facecolor('white')
    m=Basemap(projection='merc',llcrnrlat=float(lat_sul),urcrnrlat=float(lat_norte),llcrnrlon=float(lon_oeste),urcrnrlon=float    (lon_leste),resolution='h')
    x,y=m(*np.meshgrid(lon,lat))
    dado=pt[ii,:,:]
    CS=m.contourf(x,y,dado,levels=[0,6.49,7.99,11],colors=['mediumseagreen','yellow','tomato'])
    m.drawcoastlines()
    m.fillcontinents(color='white',lake_color='aqua')
    m.drawparallels(np.arange(float(lat_sul),float(lat_norte),5), linewidth=0.3, labels=[1,0,0,0], labelstyle='+/-', fmt='%g')
    m.drawmeridians(np.arange(float(lon_oeste),float(lon_leste),5), linewidth=0.3, labels=[0,0,0,1], labelstyle='+/-')
    m.drawcountries(linewidth=0.8, color='k', antialiased=1, ax=None, zorder=None)
    m.readshapefile('/home/operador/grads/auxilio_decisao/scripts/shapefiles/BRA_adm1','BRA_adm1',linewidth=0.50,color='dimgray')
    m.readshapefile('/home/operador/grads/auxilio_decisao/scripts/shapefiles/salvamar2','salvamar2',linewidth=0.50,color='black')
    plt.hold(True)
    tit=str(tit_tempo[iii])
    iii=iii+1
    plt.suptitle('Auxílio à Navegação - Comando do 2oDN \n'+data_s+' Prog. +'+tit+'Z', fontsize=11)
    cbar=plt.colorbar(CS, format='%.1f', orientation='horizontal', pad=0.1, shrink=0.3)
    cbar.ax.set_xlabel('Categoria de Risco')
#    plt.table(cellText = [['0 a 6.49', '6.5 a 7.9', '8 a 11']], cellLoc='center', loc ='bottom', cellColours = [['mediumseagreen','yellow','tomato']], fontsize=8)
#    plt.figtext(0.3, 0.0, 'Área hachurada em Verde: Pontuação abaixo de 6.5 \n Área hachurada em Amarelo: Pontuação entre 6.5 e 7.9 \n Área hachurada em Vermelho: Pontuação acima de 8', va='baseline', fontsize=8)
    plt.savefig('/home/operador/grads/gif/ww3_418/ww3'+mod+'/auxilionovo/glo/auxilio2odn_'+data_s+'_'+tit+'.png', bbox_inches='tight', pad_inches=0.2, dpi=200)

quit()
