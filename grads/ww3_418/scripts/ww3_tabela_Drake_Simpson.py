#!/home/operador/anaconda3/bin/python
# -*- coding: utf-8 -*-
# -*- coding: iso-8859-1 -*-
#-----------------------------------------------------#
# inicio SET2017    fim NOV2017                       #
# modificação saídas horárias NOV2018                 #
# Autora: 1T(RM2-T) Andressa D'Agostini               #
# Ultima modificação: 1T(T) Liana 12FEV2021           #
#-----------------------------------------------------#

from matplotlib import pyplot as plt
from matplotlib import colors
from netCDF4 import Dataset
import datetime, time
import os, sys
import matplotlib.pylab as plab
import pyresample as pr
import numpy as np
import math
import matplotlib as mpl
mpl.use('Agg') # Force matplotlib to not use any Xwindows backend.
import datetime, time


if len(sys.argv) < 3:
    print('+------------Utilização-------+')
    print('                               ')
    print('   ww3_tabela_Drake.py mod HH  ') 
    print('                               ')
    print('  ex: '+sys.argv[0]+' gfs 00   ')
    print('+-----------------------------+')
    sys.exit(1)

print('Inicio')

mod      = sys.argv[1]
cyc      = sys.argv[2]
data     = datetime.date.today()
datai    = data.strftime('%Y%m%d')
data_fim = (data + datetime.timedelta(days=+5)).strftime('%Y%m%d')
datas    = range(int(datai),int(data_fim))

print('')
print(' Data: '+datai)
print('')

# ----------------------------------------
# Definindo Diretorios
os.getcwd()
savedir   = '/home/operador/ondogramas/ww3_418/ww3'+mod+'/ww3ant'+str(cyc)+'/'
savedir2  = '/home/operador/grads/produtos_operantar/'+str(cyc)+'hmg/'

# Definindo máquina (31 ou 01) 
ww3dirbkp31 = '/mnt/nfs/dpns32/data1/operador/mod_ondas/ww3_418/backup/ww3{0}' .format(mod)
ww3dirbkp01 = '/mnt/nfs/dpns33/data1/ww3desenv/mod_ondas/ww3_418/backup/ww3{0}'.format(mod)
nc_f31      = ww3dirbkp31+'/ww3'+mod+'_ant_'+str(datai)+str(cyc)+'.nc'
nc_f01      = ww3dirbkp01+'/wave.'+str(datai)+'/ant.t'+str(cyc)+'z.nc'

flag=0
while flag==0:
    if os.path.exists(nc_f31):
        print('Usando o dado da DPNS31')
        nc_f = nc_f31
        flag=1
    elif not os.path.exists(nc_f31) and os.path.exists(nc_f01):
        nc_f = nc_f01
        print('Usando o dado da DPNS01')
        flag=1
    else:
        print('Esperando o ww3 terminar em alguma máquina')
        time.sleep(60)

# ----------------------------------------
# Extraindo as variaveis da saida do WW3
nc_fid   = Dataset(nc_f, 'r')
lat      = nc_fid.variables['latitude'][:]
lon      = nc_fid.variables['longitude'][:]
lon      = lon-360
lon_grid,lat_grid = plab.meshgrid(lon,lat)
grid     = pr.geometry.GridDefinition(lats=lat_grid, lons=lon_grid)
hs       = nc_fid.variables['hs'][:]
dire     = nc_fid.variables['dir'][:]
dp       = nc_fid.variables['dp'][:]
u_wnd    = nc_fid.variables['uwnd'][:]
v_wnd    = nc_fid.variables['vwnd'][:]
prg      = np.size(u_wnd)
freqpeak = nc_fid.variables['fp'][:] #wave peak frequency
perpeak  = 1/freqpeak
# Pontos da derrota da Passagem do Drake: 
#lat_pd = [-55.42,-56.26,-57.19,-58.00,-58.78,-59.67,-60.57,-61.32,-62.20]
#lon_pd = [-66.33,-65.51,-64.59,-63.77,-62.97,-61.82,-61.05,-60.06,-59.38]
# Pontos CT(T) Alana Entrando por Simpson:
lat_pd = [-55.51,-56.13,-56.94,-57.76,-58.58,-59.39,-60.22,-61.05,-61.88] 
lon_pd = [-66.41,-65.44,-64.39,-63.27,-62.15,-60.99,-59.81,-58.60,-57.35] 
swath  = pr.geometry.SwathDefinition(lons=lon_pd, lats=lat_pd)

_, _, index_array, distance_array = pr.kd_tree.get_neighbour_info(source_geo_def=grid, target_geo_def=swath, radius_of_influence=10000, neighbours=1)

index_array_2d = np.unravel_index(index_array, grid.shape)
index_array_l  = list(index_array_2d)
pos_lat_pd     = index_array_l[0]
pos_lon_pd     = index_array_l[1]

#print("Indices of nearest neighbours:", index_array_2d)
#print("Longitude of nearest neighbours:", lon_grid[index_array_2d])
#print("Latitude of nearest neighbours:", lat_grid[index_array_2d])
#print("Great Circle Distance:", distance_array)

#minlon=lon[0]
#minlat = lat[0]
#xcellsize = 0.10 #longitude_resolution: 0.1000000
#ycellsize = 0.10 #latitude_resolution: 0.1000000
#ii=0
# pos_lon_pd = [0,0,0,0,0,0,0,0,0]
#pos_lat_pd = [0,0,0,0,0,0,0,0,0]
#for ii in range(0,np.size(lat_pd)):
#   px = (lat_pd[ii]-minlat)/xcellsize
#   py = (lon_pd[ii]-minlon)/ycellsize
#   pos_lat_pd[ii] = np.round(px).astype(np.int)
#   pos_lon_pd[ii] = np.round(py).astype(np.int)
pts        = np.size(lat_pd[:])
tempo      = np.size(hs[:,0,0])
hs_pd      = np.zeros((tempo,pts))
dire_pd    = np.zeros((tempo,pts))
perpeak_pd = np.zeros((tempo,pts))
u_wnd_pd   = np.zeros((tempo,pts))
v_wnd_pd   = np.zeros((tempo,pts))
mag_wnd_pd = np.zeros((tempo,pts))

for i in range(0,np.size(lat_pd[:])):
   a = pos_lat_pd[i]
   b = pos_lon_pd[i]
   for ttt in range(0,tempo): 
      hs_pd[ttt,i]      = float("{0:.1f}".format(hs[ttt,a,b]))
      dire_pd[ttt,i]    = float("{0:.1f}".format(dire[ttt,a,b]))
      perpeak_pd[ttt,i] = float("{0:.1f}".format(perpeak[ttt,a,b]))
      u_wnd_pd[ttt,i]   = float("{0:.1f}".format(u_wnd[ttt,a,b]))
      v_wnd_pd[ttt,i]   = float("{0:.1f}".format(v_wnd[ttt,a,b]))   
      aux=[]
      aux=(math.sqrt((u_wnd_pd[ttt,i]**2)+(v_wnd_pd[ttt,i]**2)))*1.944   #m/s para nós   
      mag_wnd_pd[ttt,i] = float("{0:.1f}".format(aux))


hs_sv      = []
dire_sv    = []
perpeak_sv = []
mag_wnd_sv = []

inter=6 #intervalo de tempo entre prognósticos para a tabela

for i in range(0,tempo,inter):
   aux = []; aux = hs_pd[i]
   hs_sv.append(aux)
   aux = []; aux = dire_pd[i]
   dire_sv.append(aux)
   aux = []; aux = perpeak_pd[i]
   perpeak_sv.append(aux)
   aux = []; aux = mag_wnd_pd[i]
   mag_wnd_sv.append(aux)


os.chdir(savedir)
#tbl_s=np.array(hs_sv)
#np.savetxt('tbl_Drake_'+str(datai)+'.txt',tbl)

dias=[]
dt=0
if (str(cyc)=='00'):
   for d in range(0,5):
       aux = (data + datetime.timedelta(days=+dt)).strftime('%d')
       dias.append(aux)
       dt  = dt+1
else:
   for d in range(0,6):
       aux = (data + datetime.timedelta(days=+dt)).strftime('%d')
       dias.append(aux)
       dt  = dt+1


#d_rep=np.repeat(dias,4) 
#pts=['J9   00 ','J8   60 ','J7   120 ','J6   180 ','J5   240 ','J4   300 ','J3   360 ','J2   420 ','J1   480 ']
pts = ['J1(N) 00 ','J2      60 ','J3     120 ','J4     180 ','J5     240 ','J6     300 ','J7     360 ','J8     420 ','J9(S) 480 ']

if (str(cyc) == '00'):
   Hrs = ['00Z','06Z','12Z','18Z','00Z','06Z','12Z','18Z','00Z','06Z','12Z','18Z','00Z','06Z','12Z','18Z','00Z','06Z','12Z','18Z']
else:
   Hrs = ['12Z','18Z','00Z','06Z','12Z','18Z','00Z','06Z','12Z','18Z','00Z','06Z','12Z','18Z','00Z','06Z','12Z','18Z','00Z','06Z']



if (mod   == 'cosmo'):
   MOD     = 'COSMO';
elif (mod == 'gfs'):
   MOD     = 'GFS';
elif (mod == 'icon'):
   MOD     = 'ICON';
elif (mod == 'ico13'):
   MOD     = 'ICON'; 

# Tabela para HS
cells  = np.array(hs_sv[0:20]); cells=cells.T               
cmap   = colors.ListedColormap(['mediumspringgreen','yellow','lightsalmon'])
bounds = [0,3,4,25]
norm   = colors.BoundaryNorm(bounds, cmap.N)

img = plt.imshow(cells, cmap=cmap, norm=norm)
img.set_visible(False)
if (str(cyc)=='00'):
   header   = plt.table(cellText=[['']*5], colLabels=[dias[0],dias[1],dias[2],dias[3], dias[4]], loc='center', bbox=[0, 0.8, 1.0, 0.18]) #bbox=[x,y,width,heigh]
else:
   header_0 = plt.table(cellText=[['']*1], colLabels=[dias[0]], loc='center', bbox=[0, 0.8, 0.1, 0.18]) #bbox=[x,y,width,heigh]
   header_1 = plt.table(cellText=[['']*4], colLabels=[dias[1],dias[2],dias[3],dias[4]], loc='center', bbox=[0.1, 0.8, 0.8, 0.18]) #bbox=[x,y,width,heigh]
   header_2 = plt.table(cellText=[['']*1], colLabels=[dias[5]], loc='center', bbox=[0.9, 0.8, 0.1, 0.18]) #bbox=[x,y,width,heigh]

tb = plt.table(cellText = cells, rowLabels = pts, colLabels = Hrs, loc = 'center', cellColours = img.to_rgba(cells), bbox=[0, 0, 1, 0.9])
plt.axis('off')
plt.title('Altura Significativa de Onda (m) CHM/WW3/'+MOD+' '+str(cyc)+'Z '+datai+' Simpson',fontsize=9,loc='left')
plt.savefig('Tabela_Drake_'+datai+'_hs_ww3'+mod+'_'+str(cyc)+'_Simpson.png', bbox_inches='tight',dpi=1500)
plt.close('all')

# Tabela para VENTO a 10m
cells  = np.array(mag_wnd_sv[0:20]); cells=cells.T               
cmap   = colors.ListedColormap(['darkturquoise','burlywood','orangered'])
bounds = [0,20,30,150] #0,12.86,15.43,100 m/s
norm   = colors.BoundaryNorm(bounds, cmap.N)
img    = plt.imshow(cells, cmap=cmap, norm=norm)
img.set_visible(False)
if (str(cyc) == '00'):
   header = plt.table(cellText=[['']*5], colLabels=[dias[0],dias[1],dias[2],dias[3], dias[4]], loc='center', bbox=[0, 0.8, 1.0, 0.18]) #bbox=[x,y,width,heigh]
else:
   header_0 = plt.table(cellText=[['']*1], colLabels=[dias[0]], loc='center', bbox=[0, 0.8, 0.1, 0.18]) #bbox=[x,y,width,heigh]
   header_1 = plt.table(cellText=[['']*4], colLabels=[dias[1],dias[2],dias[3],dias[4]], loc='center', bbox=[0.1, 0.8, 0.8, 0.18]) #bbox=[x,y,width,heigh]
   header_2 = plt.table(cellText=[['']*1], colLabels=[dias[5]], loc='center', bbox=[0.9, 0.8, 0.1, 0.18]) #bbox=[x,y,width,heigh]

tb = plt.table(cellText = cells, rowLabels = pts, colLabels = Hrs, loc = 'center', cellColours = img.to_rgba(cells), bbox=[0, 0, 1, 0.9])
plt.axis('off')
plt.title('Vento a 10m (n'u'ós) CHM/WW3/'+MOD+' '+str(cyc)+'Z '+datai+' Simpson',fontsize=9,loc='left')
plt.savefig('Tabela_Drake_'+datai+'_wnd10'+mod+''+str(cyc)+'_Simpson.png', bbox_inches='tight',dpi=1500)
plt.close('all')

# Tabela para periodo de pico
cells  = np.array(perpeak_sv[0:20]); cells=cells.T               
cmap   = colors.ListedColormap(['paleturquoise','sandybrown','firebrick'])
bounds = [0,7,10,30] #0,12.86,15.43,100 m/s
norm   = colors.BoundaryNorm(bounds, cmap.N)
img    = plt.imshow(cells, cmap=cmap, norm=norm)
img.set_visible(False)
if (str(cyc) == '00'):
   header = plt.table(cellText=[['']*5], colLabels=[dias[0],dias[1],dias[2],dias[3], dias[4]], loc='center', bbox=[0, 0.8, 1.0, 0.18]) #bbox=[x,y,width,heigh]
else:
   header_0 = plt.table(cellText=[['']*1], colLabels=[dias[0]], loc='center', bbox=[0, 0.8, 0.1, 0.18])    #bbox=[x,y,width,heigh]              
   header_1 = plt.table(cellText=[['']*4], colLabels=[dias[1],dias[2],dias[3],dias[4]], loc='center', bbox=[0.1, 0.8, 0.8, 0.18])    #bbox=[x,y,width,heigh]
   header_2 = plt.table(cellText=[['']*1], colLabels=[dias[5]], loc='center', bbox=[0.9, 0.8, 0.1, 0.18])    #bbox=[x,y,width,heigh]

tb = plt.table(cellText = cells, 
    rowLabels   = pts, 
    colLabels   = Hrs, 
    loc         = 'center',
    cellColours = img.to_rgba(cells),
    bbox        = [0, 0, 1, 0.9])
plt.axis('off')
plt.title('Per'u'íodo de Pico (seg) CHM/WW3/'+MOD+' '+str(cyc)+'Z '+datai+' Simpson',fontsize=9,loc='left')
plt.savefig('Tabela_Drake_'+datai+'_perpeak_ww3'+mod+'_'+str(cyc)+'_Simpson.png', bbox_inches='tight',dpi=1500)
plt.close('all')


print('')
print('Fim')
print('')

quit()
