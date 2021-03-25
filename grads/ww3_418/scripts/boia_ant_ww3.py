#!/home/operador/anaconda3/bin/python
# -*- coding: utf-8 -*-
# -*- coding: iso-8859-1 -*-
#-----------------------------------------------------#
# inicio SET2017    fim NOV2017                       #
# modificação saídas horárias NOV2018                 # 
# Autora: 1T(RM2-T) Andressa D'Agostini               # 
# Adaptado por 1T(T) Damião e 1T(T) Liana             #
#-----------------------------------------------------#

###################################################################
#                                                                 #
# Script para gerar dados para comparação com a boia da Antártica #
#                                                                 #
#        Ex: ww3_boia_santos.py icon                              #
#        Ex: ww3_boia_santos.py icon 2020 12 01                   #
#                                                                 #
###################################################################


from netCDF4 import Dataset
from matplotlib import pyplot as plt
from matplotlib import colors
import datetime, time
import os, sys
import matplotlib.pylab as plab
import pyresample as pr
import numpy as np
import math
import matplotlib as mpl
#mpl.use('Agg') # Force matplotlib to not use any Xwindows backend.
import warnings
warnings.filterwarnings("ignore")


model    = sys.argv[1]
cyc      = '00'

# Data
if len(sys.argv)==2: # se não entrar com os argumentos da data
    data = datetime.date.today()
else: # entrou com os argumentos da data
    year = int(sys.argv[2])
    mon  = int(sys.argv[3])
    day  = int(sys.argv[4])
    data = datetime.date(year, mon, day)
datai    = data.strftime('%Y%m%d')
data_fim = (data + datetime.timedelta(days=+5)).strftime('%Y%m%d')
datas    = range(int(datai),int(data_fim))
data_z2  = data.strftime('%b')

if data_z2 == 'Jan':
 data_z2 = 'JAN'
if data_z2 == 'Feb':
 data_z2 = 'FEV'
if data_z2 == 'Mar':
 data_z2 = 'MAR'
if data_z2 == 'Apr':
 data_z2 = 'ABR'
if data_z2 == 'May':
 data_z2 = 'MAI'
if data_z2 == 'Jun':
 data_z2 = 'JUN'
if data_z2 == 'Jul':
 data_z2 = 'JUL'
if data_z2 == 'Aug':
 data_z2 = 'AGO'
if data_z2 == 'Sep':
 data_z2 = 'SET'
if data_z2 == 'Oct':
 data_z2 = 'OUT'
if data_z2 == 'Nov':
 data_z2 = 'NOV'
if data_z2 == 'Dec':
 data_z2 = 'DEZ'

print('Rodando:', 'ww3'+model, datai)

# ---------------------
# Definindo Diretorios
os.getcwd()

ww3dir    = '/mnt/nfs/dpns32/data1/operador/mod_ondas/ww3_418'
outdirbck = '{0}/backup/ww3{1}'.format(ww3dir, model)
savedir   = '/home/operador/grads/gif/ww3_418/boias/ww3ant00/'


# ----------------------------------------
# Extraindo as variaveis da saida do WW3
nc_f     = '{0}/ww3{1}_ant_{2}00.nc'.format(outdirbck, model, datai)
nc_fid   = Dataset(nc_f, 'r')
lat      = nc_fid.variables['latitude'][:]
lon      = nc_fid.variables['longitude'][:]
lon      = lon-360
lon_grid,lat_grid=plab.meshgrid(lon,lat)
grid     = pr.geometry.GridDefinition(lats=lat_grid, lons=lon_grid)
hs       = nc_fid.variables['hs'][:]
dire     = nc_fid.variables['dir'][:]
dp       = nc_fid.variables['dp'][:]
u_wnd    = nc_fid.variables['uwnd'][:]
v_wnd    = nc_fid.variables['vwnd'][:]
prg      = np.size(u_wnd)
freqpeak = nc_fid.variables['fp'][:] #wave peak frequency
perpeak  = 1/freqpeak

#nc_f=outdirbck+'ww3cosmo_met_2019100300.nc'
#nc_fid=Dataset(nc_f, 'r')
#lat=nc_fid.variables['LATITUDE'][:]
#lon=nc_fid.variables['LONGITUDE'][:]
#lon=lon-360
#lon_grid,lat_grid=plab.meshgrid(lon,lat)
#grid = pr.geometry.GridDefinition(lats=lat_grid, lons=lon_grid)
#hs = nc_fid.variables['HS'][:]
#dire = nc_fid.variables['DIR'][:]
#dp = nc_fid.variables['DP'][:]
#u_wnd=nc_fid.variables['UWND'][:]
#v_wnd=nc_fid.variables['VWND'][:]
#prg=np.size(u_wnd)
#freqpeak = nc_fid.variables['FP'][:] #wave peak frequency
#perpeak = 1/freqpeak


lat_pd = [-62.07307] 
lon_pd = [-57.76023] 

swath  = pr.geometry.SwathDefinition(lons=lon_pd, lats=lat_pd)

_, _, index_array, distance_array = pr.kd_tree.get_neighbour_info(
    source_geo_def=grid, target_geo_def=swath, radius_of_influence=10000,
    neighbours=1)

index_array_2d = np.unravel_index(index_array, grid.shape)
index_array_l  = list(index_array_2d)
pos_lat_pd     = index_array_l[0]
pos_lon_pd     = index_array_l[1]


pts        = np.size(lat_pd[:])
tempo      = np.size(hs[:,0,0])
hs_pd      = np.zeros((tempo,pts))
dire_pd    = np.zeros((tempo,pts))
dp_pd      = np.zeros((tempo,pts))
perpeak_pd = np.zeros((tempo,pts))
u_wnd_pd   = np.zeros((tempo,pts))
v_wnd_pd   = np.zeros((tempo,pts))
mag_wnd_pd = np.zeros((tempo,pts))
dir_wnd_pd = np.zeros((tempo,pts))

i = 0
a = pos_lat_pd[i]
b = pos_lon_pd[i]
for ttt in range(0,tempo): 
    #print(ttt)
    hs_pd[ttt,i]      = float("{0:.1f}".format(hs[ttt,a,b]))
    dp_pd[ttt,i]      = float("{0:.1f}".format(dp[ttt,a,b]))
    dire_pd[ttt,i]    = float("{0:.1f}".format(dire[ttt,a,b]))
    perpeak_pd[ttt,i] = float("{0:.1f}".format(perpeak[ttt,a,b]))
    u_wnd_pd[ttt,i]   = float("{0:.1f}".format(u_wnd[ttt,a,b]))
    v_wnd_pd[ttt,i]   = float("{0:.1f}".format(v_wnd[ttt,a,b]))   
    aux = []
    aux = (math.sqrt((u_wnd_pd[ttt,i]**2)+(v_wnd_pd[ttt,i]**2)))*1.944 # calculo da magnitude - m/s para nós
    mag_wnd_pd[ttt,i] = float("{0:.1f}".format(aux))
    aux = []
    aux = np.mod(180+np.rad2deg(np.arctan2(u_wnd_pd[ttt,i], v_wnd_pd[ttt,i])),360) # calculo da direção do vetor
    dir_wnd_pd[ttt,i] = float("{0:.1f}".format(aux))


hs_sv      = []
dire_sv    = []
dp_sv      = []
perpeak_sv = []
mag_wnd_sv = []
dir_wnd_sv = []

#inter=6 #intervalo de tempo entre prognósticos para a tabela
inter = 1

for i in range(0,tempo,inter):
    #print(i)
    aux = []; aux = hs_pd[i]
    hs_sv.append(aux)
    aux = []; aux = dire_pd[i]
    dire_sv.append(aux)
    aux = []; aux = dp_pd[i]
    dp_sv.append(aux)
    aux = []; aux = perpeak_pd[i]
    perpeak_sv.append(aux)
    aux = []; aux = mag_wnd_pd[i]
    mag_wnd_sv.append(aux)
    aux = []; aux = dir_wnd_pd[i]
    dir_wnd_sv.append(aux)

os.chdir(savedir)
#tbl_s=np.array(hs_sv)
#np.savetxt('tbl_Drake_'+str(datai)+'.txt',tbl)

dias = []
dt   = 0
if (str(cyc)=='00'):
   #for d in range(0,4):
    for d in range(0,1):
       aux = (data + datetime.timedelta(days=+dt)).strftime('%d')
       dias.append(aux+data_z2)
       dt  = dt+1
#else:
#   for d in range(0,6):
#       aux=(data + datetime.timedelta(days=+dt)).strftime('%d')
#       print('Dia: '+aux)
#       dias.append(aux)
#       dt=dt+1



if (str(cyc)=='00'):
  # Hrs = ['00Z','06Z','12Z','18Z','00Z','06Z','12Z','18Z','00Z','06Z','12Z','18Z','00Z','06Z','12Z','18Z','00Z','06Z','12Z','18Z']
    Hrs = ['00Z', '01Z','02Z','03Z','04Z','05Z','06Z','07Z','08Z','09Z','10Z','11Z','12Z','13Z','14Z','15Z','16Z','17Z','18Z','19Z','20Z','21Z','22Z','23Z']
#else:
#   Hrs = ['12Z','18Z','00Z','06Z','12Z','18Z','00Z','06Z','12Z','18Z','00Z','06Z','12Z','18Z','00Z','06Z','12Z','18Z','00Z','06Z'] 

# Tabela para HS
#cells  = [hs_sv[0:16][:],dire_sv[0:16][:],perpeak_sv[0:16][:],mag_wnd_sv[0:16][:]]
cells   = [hs_sv[0:24][:],dire_sv[0:24][:],perpeak_sv[0:24][:],mag_wnd_sv[0:24][:],dir_wnd_sv[0:24][:]]
#cmap   = colors.ListedColormap(['mediumspringgreen','yellow','lightsalmon'])
#bounds = [0,1.5,2.5,25]
#norm   = colors.BoundaryNorm(bounds, cmap.N)

# =================================================================================

# CRIANDO ARQUIVO TXT PARA OS DADOS DO PONTO:
f=open('Tabela_ww3{0}_{1}.txt'.format(model, datai),'w')

# Escrevendo cabeçalho:
f.write('CHM/WW3i{0} - '.format(str(model).upper()) + datai + ' Lat:'+str(lat_pd[0])+' / Lon:'+str(lon_pd[0])+'\n') #titulo
f.write('Variáveis: Hs(m) DirHs(°) Tp(s) U10(kn) DirU10(°)'+'\n') #variaveis
s1=' '.join(Hrs); f.write(s1); f.write('\n') #prognostico

# Escrevendo dados:
for i in range(len(cells)):
    for j in range(len(cells[i])):
        f.write(str(cells[i][j][0])+' ')
    f.write('\n')
f.close()

print('Arquivo txt finalizado')

# =================================================================================

#img = plt.imshow(cells, cmap=cmap, norm=norm)
#img = plt.imshow(cells)
#img.set_visible(False)
if (str(cyc)=='00'):
#   header = plt.table(cellText=[['  ']*4],
#                         colLabels=[dias[0],dias[1],dias[2],dias[3]], 
#                         loc='center',
#                         bbox=[0, 0.8, 1.0, 0.18]    #bbox=[x,y,width,heigh]
#                         )
#else:
   header_0 = plt.table(cellText=[['']*1],
                         colLabels=[dias[0]],
                         loc='center',
                         bbox=[0, 0.8, 1.0, 0.18]    #bbox=[x,y,width,heigh]
                         )
#   header_1 = plt.table(cellText=[['']*4],
#                         colLabels=[dias[1],dias[2],dias[3],dias[4]],
#                         loc='center',
#                         bbox=[0.1, 0.8, 0.8, 0.18]    #bbox=[x,y,width,heigh]
#                         )
#   header_2 = plt.table(cellText=[['']*1],
#                         colLabels=[dias[5]],
#                         loc='center',
#                         bbox=[0.9, 0.8, 0.1, 0.18]    #bbox=[x,y,width,heigh]
#                         )

tb = plt.table(cellText = cells, 
    rowLabels = ['Hs (m)','Dir ('+chr(0x00B0)+')', 'Tp (s)', 'U10 (kn)', 'Dir('+chr(0x00B0)+')'], rowLoc = 'center', rowColours = ['lightgray', 'lightgray', 'lightgray', 'lightgray', 'lightgray'],
    colLabels = Hrs, colLoc ='center', colColours = ['lightgray', 'lightgray', 'lightgray', 'lightgray', 'lightgray', 'lightgray', 'lightgray', 'lightgray', 'lightgray', 'lightgray', 'lightgray', 'lightgray', 'lightgray', 'lightgray', 'lightgray', 'lightgray', 'lightgray','lightgray', 'lightgray', 'lightgray', 'lightgray', 'lightgray', 'lightgray', 'lightgray', 'lightgray', 'lightgray'],
    loc = 'center',
    bbox=[0, 0, 1, 0.9], fontsize=11)
plt.axis('off')
plt.title('Dados de Vento e Onda CHM/WW3{0} '.format(str(model).upper()) +datai+ ' - 00Z',fontsize=10,loc='left')
#plt.show()
plt.savefig('boia_ant_ww3{0}_{1}.png'.format(model, datai), bbox_inches='tight',dpi=600)
plt.close('all')


print('Fim')
print()

