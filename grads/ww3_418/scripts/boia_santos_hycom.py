#!/home/operador/anaconda3/bin/python
# -*- coding: utf-8 -*-
# -*- coding: iso-8859-1 -*-
#-----------------------------------------------------#
# inicio SET2017    fim NOV2017                       #
# modificação saídas horárias NOV2018                 # 
# Autora: 1T(RM2-T) Andressa D'Agostini               # 
# Adaptado por 1T(T) Damião e 1T(T) Liana             #
#-----------------------------------------------------#

################################################################
#                                                              #
# Script para gerar dados para comparação com a boia de Santos #
#                                                              #
#        Ex: ww3_boia_santos_hycom.py met                      #
#        Ex: ww3_boia_santos_hycom.py met 2020 12 01           #
#                                                              #
################################################################

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
from netCDF4 import Dataset
from matplotlib import pyplot as plt
from matplotlib import colors


# Modelo, área e horário
area = sys.argv[1]
cyc  = '00'

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


print('Rodando:', 'HYCOM', datai)

# ---------------------
# Definindo Diretorios
os.getcwd()
hycomdir = '/mnt/nfs/dpns32/data1/operador/previsao/hycom_2_2/output/Previsao_1_24_nova/Ncdf/{0}'.format(datai)
savedir  = '/home/operador/grads/gif/ww3_418/boias/ww3santos00/'


# ----------------------------------------
# Extraindo as variaveis de TSM 
output_tsm = '{0}/hycom124_3zt_{1}.nc'.format(hycomdir, datai) # arquivo com temperatura
nc_f       = '{0}'.format(output_tsm)
nc_fid     = Dataset(nc_f, 'r')
tsm        = nc_fid.variables['temperature'][:,0,:,:] # camada superficial
lat        = nc_fid.variables['Latitude'][:]
lon        = nc_fid.variables['Longitude'][:]
lon_grid,lat_grid = plab.meshgrid(lon,lat)
grid       = pr.geometry.GridDefinition(lats=lat_grid, lons=lon_grid)

# Extraindo as variaveis de correntes
output_cor = '{0}/hycom124_2du_{1}.nc'.format(hycomdir, datai)  # arquivo com U e V das correntes
nc_f       = '{0}'.format(output_cor)
nc_fid     = Dataset(nc_f, 'r')
u_cor      = nc_fid.variables['u_velocity'][:,0,:,:] # camada superficial
v_cor      = nc_fid.variables['v_velocity'][:,0,:,:] # camada superficial

# Coordenadas da boia
lat_pd = [-25.51] 
lon_pd = [-42.74] 
swath  = pr.geometry.SwathDefinition(lons=lon_pd, lats=lat_pd)

_, _, index_array, distance_array = pr.kd_tree.get_neighbour_info(source_geo_def=grid, target_geo_def=swath, radius_of_influence=10000, neighbours=1)

index_array_2d = np.unravel_index(index_array, grid.shape)
index_array_l  = list(index_array_2d)
pos_lat_pd     = index_array_l[0]
pos_lon_pd     = index_array_l[1]

pts        = np.size(lat_pd[:])
tempo      = np.size(tsm[:,0,0])
tsm_pd     = np.zeros((tempo,pts))
u_cor_pd   = np.zeros((tempo,pts))
v_cor_pd   = np.zeros((tempo,pts))
mag_cor_pd = np.zeros((tempo,pts))
dir_cor_pd = np.zeros((tempo,pts))

i = 0
a = pos_lat_pd[i]
b = pos_lon_pd[i]
for ttt in range(0,tempo): 
    tsm_pd[ttt,i]     = float("{0:.1f}".format(tsm[ttt,a,b]))
    u_cor_pd[ttt,i]   = float("{0:.1f}".format(u_cor[ttt,a,b]))
    v_cor_pd[ttt,i]   = float("{0:.1f}".format(v_cor[ttt,a,b]))   
    aux = []
    aux = (math.sqrt((u_cor_pd[ttt,i]**2)+(v_cor_pd[ttt,i]**2)))*1.944 # calculo da magnitude - m/s para nós
    mag_cor_pd[ttt,i] = float("{0:.1f}".format(aux))
    aux = []
    aux = np.mod(180+np.rad2deg(np.arctan2(u_cor_pd[ttt,i], v_cor_pd[ttt,i])),360) # calculo da direção do vetor
    dir_cor_pd[ttt,i] = float("{0:.1f}".format(aux))


tsm_sv     = []
mag_cor_sv = []
dir_cor_sv = []

inter=1 # intervalo de tempo entre prognósticos para a tabela

for i in range(0,tempo,inter):
    aux = []; aux = tsm_pd[i]
    tsm_sv.append(aux)
    aux = []; aux = mag_cor_pd[i]
    mag_cor_sv.append(aux)
    aux = []; aux = dir_cor_pd[i]
    dir_cor_sv.append(aux)

os.chdir(savedir)

dias=[]
dt=0
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
cells   = [tsm_sv[0:24][:],mag_cor_sv[0:24][:],dir_cor_sv[0:24][:]]


# =================================================================================
# CRIANDO ARQUIVO TXT PARA OS DADOS DO PONTO:
f = open('Tabela_hycom_{0}.txt'.format(datai),'w')

# Escrevendo cabeçalho:
f.write('CHM/HYCOM {0} - '.format(datai) + ' Lat:'+str(lat_pd[0])+' / Lon:'+str(lon_pd[0])+'\n') #titulo
f.write('Variáveis: TSM(ºC) VelCor(kn) DirCor(º)'+'\n') #variaveis
s1 = ' '.join(Hrs); f.write(s1); f.write('\n') #prognostico

# Escrevendo dados:
for i in range(len(cells)):
    for j in range(len(cells[i])):
        f.write(str(cells[i][j][0])+' ')
    f.write('\n')
f.close()

print('Arquivo txt finalizado')


# =================================================================================
if (str(cyc)=='00'):
#   header = plt.table(cellText=[['  ']*4],
#                         colLabels=[dias[0],dias[1],dias[2],dias[3]], 
#                         loc='center',
#                         bbox=[0, 0.8, 1.0, 0.18]    #bbox=[x,y,width,heigh]
#                         )
#else:
   header_0 = plt.table(cellText=[['']*1], colLabels=[dias[0]], loc='center', bbox=[0, 0.8, 1.0, 0.18]) #bbox=[x,y,width,heigh]
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

tb = plt.table(cellText = cells, rowLabels = ['TSM (ºC)','VelCor (kn)', 'DirCor('+chr(0x00B0)+')'], rowLoc = 'center', 
               rowColours = ['lightgray', 'lightgray', 'lightgray', 'lightgray', 'lightgray'],
               colLabels = Hrs, colLoc ='center', colColours = ['lightgray', 'lightgray', 'lightgray', 'lightgray', 'lightgray', 'lightgray', 'lightgray', 'lightgray', 'lightgray', 'lightgray', 'lightgray', 'lightgray', 'lightgray', 'lightgray', 'lightgray', 'lightgray', 'lightgray','lightgray', 'lightgray', 'lightgray', 'lightgray', 'lightgray', 'lightgray', 'lightgray', 'lightgray', 'lightgray'],
               loc = 'center',
               bbox=[0, 0, 1, 0.9], fontsize=11)
plt.axis('off')
plt.title('Dados de TSM e Correntes CHM/HYCOM ' +datai+ ' - 00Z',fontsize=10,loc='left')
plt.savefig('boia_santos_hycom_{0}.png'.format(datai), bbox_inches='tight',dpi=600)
plt.close('all')
print('Tabela finalizada')

print('Fim')
print()

quit()
