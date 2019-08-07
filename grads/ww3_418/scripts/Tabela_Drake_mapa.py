#!/home/operador/anaconda3/bin python
# -*- coding: utf-8 -*-
# -*- coding: iso-8859-1 -*-
#-----------------------------------------------------#
#                                                     #
# Script para gerar figuras das grades do WW3         #
#                                                     #  
# Autora: 1T(RM2-T) Andressa D'Agostini               #
#                                                     #
#-----------------------------------------------------#

import datetime, time
import os, sys, shutil
from  ww3Funcs import alteraStr, alteraDia, horarios

if len(sys.argv) < 3:
    print('+------------Utilização------------+')
    print('                                    ')
    print(' Fig_Corrente_Hycom.py DataCorrente ')
    print('                                    ')
    print('  ex: '+sys.argv[0]+' gfs 20160603  ')
    print('+----------------------------------+')
    sys.exit(1)

mod=sys.argv[1]
data = horarios(sys.argv[2])
data = datetime.date(int(data[0]),int(data[1]),int(data[2]))
data_s  = data.strftime('%Y%m%d')

# Delimitando a área de interesse
lat_sul = '-65'   # latitude mais ao sul do recorte desejado
lat_norte = '-50' # latitude mais ao norte do recorte desejado
lon_oeste = '-75'   # longitude mais à oeste do recorte desejado
lon_leste = '-55'   # longitude mais à leste do recorte desejado

import numpy as np
import matplotlib as mpl
mpl.use('Agg') # Force matplotlib to not use any Xwindows backend.
import matplotlib.pylab as plab
from netCDF4 import Dataset
import scipy
from numpy import ma
import os

# ----------------------------------------
# Extraindo as variaveis da saida do Hycom

ww3dir  ='/mnt/nfs/dpns32/data1/operador/mod_ondas/ww3_418/'
outdirbck=ww3dir+'backup/ww3'+mod+'/'
nc_f=outdirbck+'nc3_ww3'+mod+'_ant_'+data_s+'00.nc'
nc_fid=Dataset(nc_f, 'r')
lat=nc_fid.variables['latitude'][:]
lon=nc_fid.variables['longitude'][:]
lon= lon-360
lons,lats=plab.meshgrid(lon,lat)
lat_s=float(lat_sul);lat_n=float(lat_norte)
lat_media=-((-lat_s)+(-lat_n))/2
lat_media=str(lat_media)
hs=nc_fid.variables['hs'][:,:,:] 

# Pontos de interesse da travessia da Passagem de Drake
# Pontos CC Peixoto Entrando por Nelson: lat_pd = [-55.42,-56.26,-57.18,-58.00,-58.77,-59.67,-60.57,-61.32,-62.20]
# Pontos CC Peixoto Entrando por Nelson: lon_pd = [-66.33,-65.51,-64.58,-63.77,-62.97,-61.82,-61.13,-60.06,-59.37]
# Pontos CT(T) Alana Entrando por Simpson:
lat_pd = [-55.51,-56.13,-56.94,-57.76,-58.58,-59.39,-60.22,-61.05,-61.88] 
lon_pd = [-66.41,-65.44,-64.39,-63.27,-62.15,-60.99,-59.81,-58.60,-57.35] 
pts=['J1','J2','J3','J4','J5','J6','J7','J8','J9']

# Criando a figura para N prognósticos
from mpl_toolkits.basemap import Basemap
import matplotlib.pyplot as plt
#H=(hs[0,:,:]);H=np.squeeze(H)
fig=plt.figure()
rect = fig.patch
rect.set_facecolor('white')
m=Basemap(projection='merc',llcrnrlat=float(lat_sul),urcrnrlat=float(lat_norte),llcrnrlon=float(lon_oeste),urcrnrlon=float(lon_leste),resolution='h')
x,y=m(lons,lats)
#cores=scipy.linspace(0,10.5,num=21)
#CS=m.contourf(x,y,H,levels=cores,cmap=plt.cm.Blues)
m.drawcoastlines()
m.fillcontinents(color='coral',lake_color='aqua')
m.drawparallels(np.arange(float(lat_sul),float(lat_norte),5), labels=[1,0,0,0],fmt='%g')
m.drawmeridians(np.arange(float(lon_oeste),float(lon_leste),5), labels=[0,0,0,1])
m.drawcountries(linewidth=0.8, color='k', antialiased=1, ax=None, zorder=None)
plt.hold(True)
for i in range(0,np.size(lat_pd)):
   A,B = m(lon_pd[i], lat_pd[i])
   m.plot(A, B, 'k*', markersize=10)
   pNome=pts[i]
   plt.text(A,B,' '+str(pNome)+'', ha='left', color='k')

plt.tight_layout()
plt.savefig('Tabela_Drake_mapa_pts.png')
#plt.show()

quit()
