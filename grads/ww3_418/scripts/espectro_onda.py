#!/home/operador/anaconda3/envs/hycomemerg/bin/python
# -*- coding: utf-8 -*-
# -*- coding: iso-8859-1 -*-
# This program reads WAVEWATCHIII point output netcdf file _spec.nc from ww3_ounp
# It organizes and creates figures of power spectra (1D) and directional spectra (2D)
# It additionally divides each directional spectrum (2D) in five frequency band to be further ploted using PLEDS/WW3 (Parente (1999); a time evolution plot of frequency bands)
# Customize and select your options in lines 40 to 68.
# 
# v1.2, 17/02/2016
#
# Ricardo Martins Camposk
# riwave@gmail.com
# ----------------------------------------------------------------------------------------
# CENTEC-IST, REMO-CHM  
# MotorDePopa Wave Research Group
# ----------------------------------------------------------------------------------------
# Contributions: Jose Henrique Alves (EMC NCEP/NOAA), Luiz Alexandre Guerra (CENPES/PETROBRAS), Carlos Eduardo Parente (LIOC/PENO/COPPE/UFRJ), Nelson Violante (LIOC/PENO/COPPE/UFRJ) and Fred Ostritz (Blues player).
# ----------------------------------------------------------------------------------------
import datetime, time
import os, sys
#import matplotlib.pylab as plab
#import pyresample as pr
#import numpy as np

if len(sys.argv) < 3:
    print('+------------Utilização---------------+')
    print('                                       ')
    print('       spectral.py mod HH data         ')
    print('                                       ')
    print('  ex: '+sys.argv[0]+' gfs 00 20191111  ')
    print('+-------------------------------------+')
    sys.exit(1)

print('Inicio')

forc=sys.argv[1]
cyc=sys.argv[2]
ymd=sys.argv[3]
data = datetime.date.today()
datai = data.strftime('%Y%m%d')
data_fim = (data + datetime.timedelta(days=+5)).strftime('%Y%m%d')
datas=range(int(datai),int(data_fim))

print(str(forc) + str(cyc) +str(ymd))


# Python Libraries. Pay attention to the pre-requisites and libraries
import matplotlib
matplotlib.use('Agg')
import os
import pylab
from pylab import *
import matplotlib.pyplot as plt
import numpy as np
import netCDF4
import time
from time import strptime, gmtime, strftime
from calendar import timegm
# Palette and colors for plotting the figures
from mpl_toolkits.basemap import cm
colormap = cm.GMT_polar
palette = plt.cm.gist_stern_r
# palette.set_bad('aqua', 10.0)
import matplotlib.colors as colors
import matplotlib.gridspec as gridspec
from matplotlib.mlab import *




# Decision of ploting output figures and(or) writing output files. If equal to 0 the output will not be created. If equal to 1 the output will be created
# Power Spectra (1D) Plot 
pspdecp=0
# Directional Wave spectra (2D) Plot
dspdecp=0
# Directional Wave spectra (2D) Plot plus Power spectra and info
cspdecp=1
# PREP PLEDS output file
ppoutf=0
#
# lowest period (upper limit frequency) for the directional wave spectra (2D) polar plot
lper=4.0
# lowest period (upper limit frequency) for the power spectra (2D) plot
lper2=2.0
# Prep PLEDS (spectral partitioning) ---------------------------------------------------
# Index limits for each frequency band. Take a look at the file directions_frequencies.txt and choose the frequency interval ans its indexes.
# 1) initialFreq-la, 2) la-lb, 3) lb-lc, 4) lc-ld, 5) ld-finalFreq  : Total of 5 bands 
la=5
lb=9
lc=12
ld=17
# Output path
lpath='/mnt/nfs/dpns32/data1/operador/mod_ondas/ww3_418/backup/ww3'+str(forc)+'/specs'
#lpath='/mnt/nfs/dpns32/data1/ww3desenv/home/mod_ondas/backup/ww3gfs/specs'
# Path and Name of spectra output file
# /home/thai/forecastop/output/ww3_thaiOP.20160214/POINTOUTPUT/ww3.20160214_spec.nc
aux=strftime("%Y-%m-%d %H:%M:%S", gmtime()); 
# initimestrg=aux[0:4]+aux[5:7]+aux[8:10]; fname=lpath+'/ww3_thaiOP.'+initimestrg+'/POINTOUTPUT/ww3.'+initimestrg+'_spec.nc'
fname=lpath+'/spec_ww3'+forc+'_'+str(ymd)+str(cyc)+'.nc'
# final path for saving figures
fpath='/home/operador/grads/gif/ww3_418/ww3spectral/ww3'+forc+'/'
#fpath'/home/operador/grads/gif/ww3/ww3gfs/espectral'
print(lpath)
print(fname)
# --------------------------------------------------------------------------

if forc == 'gfs':
    mod ='GFS'
if forc == 'icon':
    mod ='ICON'
if forc == 'cosmo':
    mod = 'COSMO'

loc = {77:'Oiapoque', 78:'Foz_Amazonas', 79:'SPedro_SPaulo', 80:'Pirata_1', 81:'Salinopolis', 82:'Sao_Luis', 83:'Fortaleza', 84:'Fernando_Noronha', 85:'Touros', 86:'Natal', 87:'Cabedelo', 88:'Pirata_2', 89:'Recife', 90:'PNBOIA_Recife', 91:'Tamandare', 92:'Maceio', 93: 'Aracaju', 94:'Aracaju_2', 95:'Salvador', 96:'Pirata_3', 97:'Ilheus', 98: 'Porto_Seguro', 99:'PNBOIA_Porto_Seguro', 100:'Abrolhos', 101:'Pirata_4', 102:'Vitoria', 103:'Marataizes', 104:'Sao_Tome', 105:'Cabo_Frio', 106:'Trindade', 107:'Rio_Janeiro', 108:'Ilha_Grande', 109:'Sao_Sebastiao', 110:'Santos', 111:'Peruibe', 112:'Iguape', 113:'Cananeia', 114:'PNBOIA_Santos', 115:'Ilha_Mel', 116:'Guaratuba', 117:'SFrancisco_Sul', 118:'Itajai', 119:'Floripa', 120:'PNBOIA_SC', 121:'Garopaba', 122:'Sta_Marta', 123:'Balneario_Rincao', 124:'Torres',  125:'Tramandai', 126:'PNBOIA_RG', 127:'Mostardas', 128:'Rio_Grande', 129:'Chui'} 

loc2 = {77:'Oiapoque', 78:'Foz do Amazonas', 79:'Sao Pedro e Sao Paulo', 80:'Pirata 1', 81:'Salinopolis', 82:'Sao Luis', 83:'Fortaleza', 84:'Fernando de Noronha', 85:'Touros', 86:'Natal', 87:'Cabedelo', 88:'Pirata 2', 89:'Recife', 90:'PNBOIA Recife', 91:'Tamandare', 92:'Maceio', 93: 'Aracaju', 94:'Aracaju 2', 95:'Salvador', 96:'Pirata 3', 97:'Ilheus', 98: 'Porto Seguro', 99:'PNBOIA Porto_Seguro', 100:'Abrolhos', 101:'Pirata 4', 102:'Vitoria', 103:'Marataizes', 104:'Sao Tome', 105:'Cabo Frio', 106:'Trindade', 107:'Rio de Janeiro', 108:'Ilha Grande', 109:'Sao Sebastiao', 110:'Santos', 111:'Peruibe', 112:'Iguape', 113:'Cananeia', 114:'PNBOIA Santos', 115:'Ilha do Mel', 116:'Guaratuba', 117:'Sao Francisco do Sul', 118:'Itajai', 119:'Florianopolis', 120:'PNBOIA SC', 121:'Garopaba', 122:'Cabo de Santa Marta', 123:'Balneario Rincao', 124:'Torres', 125:'Tramandai', 126:'PNBOIA RG', 127:'Mostardas', 128:'Rio Grande', 129:'Chui'} 

#pp = [78, 82, 83, 84, 86, 89, 92, 93, 95, 98, 100, 102, 105, 107, 108, 109, 110, 113, 115, 118, 119, 122, 124, 128, 129] 
pp2 = [105, 107, 108, 109, 110, 113, 115, 118, 119, 122, 124, 128, 129]

otf=0; c=1 # Wait up to 18 hours for the output file fname
while otf==0 and c<226:
	if os.path.isfile(fname):
		otf=1
	else:
		c=c+1
		if c>10:
			time.sleep(300)


if otf==1:

	try:
		# open output file, Check if it is properly opened
		nfile = netCDF4.Dataset(fname)
	except:
		print('Problems trying to open file '+fname)
	else:
		# efth(time, station, frequency, direction)
		dspec=nfile.variables['efth'][:,:,:,:]

		# number of time outputs 
		nt=dspec.shape[0]
		# number of point outputs 
		npo=dspec.shape[1]
		# number of directions
		nd=dspec.shape[3]
		# number of frequencies
		nf=dspec.shape[2]

		# directions
		dire=nfile.variables['direction'][:]
		# frequencies
		freq=nfile.variables['frequency'][:]
		# wind intensity and wind direction
		wnds=nfile.variables['wnd'][:,:]
		wndd=nfile.variables['wnddir'][:,:]
		# days since 1990-01-01T00:00:00Z to seconds since 1979-01-01T00:00:00Z
		atime=nfile.variables['time'][:]
		ntime=np.zeros((nt),'d')
		for t in range(0,nt):
		    ntime[t]=atime[t]*3600*24 + timegm( strptime('19900101','%Y%m%d') )

		# water depth (constant in time)
		depth1=nfile.variables['dpt'][:,:]
		depth=np.zeros((depth1.shape[1]),'f')
		for i in range(0,depth1.shape[1]):
		    depth[i]=depth1[:,i].mean()

		del depth1
		stationid=nfile.variables['station'][:]
		stationname=nfile.variables['station_name'][:]
		lon=nfile.variables['longitude'][0,:]
		lat=nfile.variables['latitude'][0,:]

		nfile.close()

		# -----------------------------------------------------


		# organizing directions  -----
		adspec=np.copy(dspec); inddire=int(find(dire==min(dire)))
		for t in range(0,nt):
		    for p in range(0,npo):
		        adspec[t,p,:,0:nd-(inddire+1)]=dspec[t,p,:,(inddire+1):nd]
		        adspec[t,p,:,nd-(inddire+1):nd]=dspec[t,p,:,0:(inddire+1)]
		        for i in range(0,nd):
		            dspec[t,p,:,i]=adspec[t,p,:,nd-i-1]
			    
		        adspec[t,p,:,0:int(nd/2)]=dspec[t,p,:,int(nd/2):nd]
		        adspec[t,p,:,int(nd/2):nd]=dspec[t,p,:,0:int(nd/2)]
		        dspec[t,p,:,:]=adspec[t,p,:,:]

		dire=np.sort(dire)
		# -----
		# for the 2D polar plot:
		indf=int(find(abs(freq-(1/lper))==min(abs(freq-(1/lper)))))
		indf2=int(find(abs(freq-(1/lper2))==min(abs(freq-(1/lper2)))))
		ndire=np.zeros((dire.shape[0]+2),'f'); ndire[1:-1]=dire[:]; ndire[0]=0; ndire[-1]=360
		angle = np.radians(ndire)
		r, theta = np.meshgrid(freq[0:indf], angle);
		# ---


		sdate=np.zeros((nt,4),'i')
		for t in range(0,nt):
		    sdate[t,0]=int(time.gmtime(ntime[t])[0])
		    sdate[t,1]=int(time.gmtime(ntime[t])[1])
		    sdate[t,2]=int(time.gmtime(ntime[t])[2])
		    sdate[t,3]=int(time.gmtime(ntime[t]+10)[3])

		# DF in frequency (dfim)  
		fretab=np.zeros((nf),'f');  dfim=np.zeros((nf),'f')	
		fre1 = freq[0] ; fretab[0] = fre1
		co = freq[(nf-1)]/freq[(nf-2)] 
		dfim[0] = (co-1) * np.pi / nd * fretab[0] 
		for ifre in range(1,nf-1):
			fretab[ifre] = fretab[ifre-1] * co 
			dfim[ifre] = (co-1) * np.pi / nd * (fretab[ifre]+fretab[ifre-1]) 

		fretab[nf-1] = fretab[nf-2]*co
		dfim[nf-1] = (co-1) * np.pi / nd * fretab[(nf-2)]       
		# ------------------ 

		# intialization of variables that will be used to calculate the energy, Hs and Dp of each band(PLEDS).
		ef=np.zeros((nt,npo,5),'f') 
		dpf=np.zeros((nt,npo,5),'f')     
		pws=np.zeros((nt,npo,nf),'f')
		pwst=np.zeros((nt,npo,nf),'f') 
		hs=np.zeros((nt,npo,5),'f') 
		hstot=np.zeros((nt,npo),'f') 
		indd=np.zeros((nt,npo,5),'i') 
		# -----

		# Main loop in time
		for t in range(0,nt,3):
			# second loop: point outputs 
#			for p in range(0,npo):
#			for p in range(107,108):
			for p in pp:
                                estac=loc[p]
                                estac2=loc2[p]  
#                                estac =''
#                               for a in stationname[p][0:10]:
#                                        estac += str(a)                               
				# PREP PLEDS (Campos&Parente 2009) -------------------------------------------------
				for il in range(0,nf):	
		     			# efth(time, station, frequency, direction)
					pwst[t,p,il]=sum(dspec[t,p,il,:])

				pwst[t,p,:]=pwst[t,p,:]*dfim[:]	
		
				# Total energy at each frequency band
				ef[t,p,0]=sum(pwst[t,p,0:la])
				ef[t,p,1]=sum(pwst[t,p,la:lb])
				ef[t,p,2]=sum(pwst[t,p,lb:lc])
				ef[t,p,3]=sum(pwst[t,p,lc:ld])
				ef[t,p,4]=sum(pwst[t,p,ld:])
				# Significant wave height at each frequency band
				hs[t,p,0]=4.01*np.sqrt(ef[t,p,0])
				hs[t,p,1]=4.01*np.sqrt(ef[t,p,1])
				hs[t,p,2]=4.01*np.sqrt(ef[t,p,2])
				hs[t,p,3]=4.01*np.sqrt(ef[t,p,3])
				hs[t,p,4]=4.01*np.sqrt(ef[t,p,4])
		
				# Just for checking the total significant wave height. It must be equal to 4.01*np.sqrt(sum(pwst[t,p,:]))
				hstot[t,p]=np.sqrt(hs[t,p,0]**2 + hs[t,p,1]**2 + hs[t,p,2]**2 + hs[t,p,3]**2 + hs[t,p,4]**2)
				
				# Directional index of the maximum energy at each band				
				indd[t,p,0] = int(dspec[t,p,0:la,:].argmax()/dspec[t,p,0:la,:].shape[0])
				indd[t,p,1] = int(dspec[t,p,la:lb,:].argmax()/dspec[t,p,la:lb,:].shape[0]) 			
				indd[t,p,2] = int(dspec[t,p,lb:lc,:].argmax()/dspec[t,p,lb:lc,:].shape[0]) 
				indd[t,p,3] = int(dspec[t,p,lc:ld,:].argmax()/dspec[t,p,lc:ld,:].shape[0]) 
				indd[t,p,4] = int(dspec[t,p,ld:nf,:].argmax()/dspec[t,p,ld:nf,:].shape[0]) 	
				
				dpf[t,p,0] = dire[indd[t,p,0]]
				dpf[t,p,1] = dire[indd[t,p,1]]
				dpf[t,p,2] = dire[indd[t,p,2]]
				dpf[t,p,3] = dire[indd[t,p,3]]
				dpf[t,p,4] = dire[indd[t,p,4]]	
				# --------------------------------------------------------------------------------------------


				# SPECTRAL PLOTS 

				# Power Spectra Plot -------------------------------------------------
				if pspdecp==1:
					fig=plt.figure(figsize=(8,6))
					plt.plot(1/(freq[0:indf2]),pwst[t,p,0:indf2],'k',linewidth=3.0)
					zpwst = np.zeros((pwst[t,p,0:indf2].shape[0]),'f')
					plt.fill_between(1/(freq[0:indf2]),pwst[t,p,0:indf2], where=pwst[t,p,0:indf2]>=zpwst, interpolate=True, color='0.5')
					plt.grid()
                                        plt.ylim(0,0.08)
					plt.xlabel('Periodo (s)')
					plt.ylabel('Espectro de Energia (m^2/Hz)')         
					title('WAVEWATCH III - Espectro de Energia de Onda     '+str(sdate[t,0]).zfill(4)+'/'+str(sdate[t,1]).zfill(2)+'/'+str(sdate[t,2]).zfill(2)+' '+str(sdate[t,3]).zfill(2)+'Z', fontsize=11)		
					plt.figtext(0.6,0.88,"Profundidade: "+repr(depth[p])[0:6]+" m",fontsize=9)
					plt.figtext(0.6,0.85,"Velocidade do Vento: "+repr(wnds[t,p])[0:4]+" m/s",fontsize=9)
					plt.figtext(0.6,0.82,"Direcao do Vento: "+repr(wndd[t,p])[0:4]+" graus",fontsize=9)
					plt.figtext(0.6,0.79,"Altura significativa de onda: "+repr(4.01*np.sqrt(sum(pwst[t,p,:])))[0:4]+" m",fontsize=9)
					plt.savefig(fpath+'pspec_p'+str(p+1).zfill(3)+'_t'+str(t).zfill(3)+'.png', dpi=None, facecolor='w', edgecolor='w', orientation='portrait', papertype=None, format='png', transparent=False, bbox_inches=None, pad_inches=0.1)
					plt.close()
				# -------------------------------------------------------------------


				# Directional Spectra 2D Plot ---------------------------------
				if dspdecp==1:

					# Polar Plot ===========================================
					ndspec=np.zeros((freq.shape[0],ndire.shape[0]),'f')
					ndspec[:,1:-1]=dspec[t,p,:,:]
					for i in range(0,freq.shape[0]):
						ndspec[i,-1]=(dspec[t,p,i,0]+dspec[t,p,i,-1])/2
						ndspec[i,0]=(dspec[t,p,i,0]+dspec[t,p,i,-1])/2

					fig=plt.figure(figsize=(9,6))
					gs = gridspec.GridSpec(10,10)
					sp = plt.subplot(gs[1:,:], projection='polar')
					sp.set_theta_zero_location('N')
					sp.set_theta_direction(-1)


					levels=[0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1]
					plt.contourf(theta, r, ndspec[0:indf,:].T,levels,cmap='Purples',norm=colors.Normalize(vmin=0.0,vmax=1,clip=False), extent=[-3,3,-3,3])
					ax1 = plt.gca()
					pos1 = ax1.get_position()
					l1, b1, w1, h1 = pos1.bounds
					cax1 = plt.axes([l1+w1-0.1, b1+0.01, 0.02, h1-0.01]) # setup colorbar axes.
					cbar=plt.colorbar(cax=cax1, orientation='vertical',format='%3.1f');cbar.ax.tick_params(labelsize=8)
					plt.colorbar(cax=cax1) # draw colorbar
					plt.axes(ax1)  # make the original axes current again

					levels=[1,2,3,4,5,6,7,8,9,10]
					plt.contourf(theta, r, ndspec[0:indf,:].T,levels,cmap='viridis',norm=colors.Normalize(vmin=1,vmax=10,clip=False), extent=[-3,3,-3,3])

					ax2 = plt.gca()
					pos2 = ax2.get_position()
					l2, b2, w2, h2 = pos1.bounds
					cax2 = plt.axes([l2+w2+0.005, b2+0.01, 0.02, h2-0.01]) # setup colorbar axes.
					cbar=plt.colorbar(cax=cax2, orientation='vertical',format='%3.1f');cbar.ax.tick_params(labelsize=8)
					plt.colorbar(cax=cax2) # draw colorbar
					plt.axes(ax2)  # make the original axes current again


					levels=[10,15,20,25,30,35,40,45,50]
					plt.contourf(theta, r, ndspec[0:indf,:].T,levels,cmap='spring_r',norm=colors.Normalize(vmin=10,vmax=50,clip=False), extent=[-3,3,-3,3])
					
					plt.figtext(0.15,0.93,'WW3GFS - CHM - Espectro Direcional de Onda    '+str(sdate[t,0]).zfill(4)+'/'+str(sdate[t,1]).zfill(2)+'/'+str(sdate[t,2]).zfill(2)+' '+str(sdate[t,3]).zfill(2)+'Z', fontsize=13)
#					plt.yticks([0.05, 0.1, 0.15, 0.2] , ["20", "10", "6.17", "5"])
					ax = plt.gca()
					pos = ax.get_position()
					l, b, w, h = pos.bounds
					cax = plt.axes([l+w+0.01, b+0.01, 0.02, h-0.01]) # setup colorbar axes.
                                        cbar=plt.colorbar(cax=cax, orientation='vertical',format='%3.1f');cbar.ax.tick_params(labelsize=8)
					plt.colorbar(cax=cax) # draw colorbar
					plt.axes(ax)  # make the original axes current again
					plt.savefig(fpath+'dspec_'+estac+'_t'+str(t).zfill(3)+'.png', dpi=None, facecolor='w', edgecolor='w',orientation='portrait', papertype=None, format='png',transparent=False, bbox_inches=None, pad_inches=0.1)
					plt.close()
					# ===================================================


				# Directional Spectra 2D Plot plus Power spectra and info  ---------------------------
				if cspdecp==1:
                                        print('plotando')
					# Polar Plot ===========================================
					ndspec=np.zeros((freq.shape[0],ndire.shape[0]),'f')
					ndspec[:,1:-1]=dspec[t,p,:,:]
					for i in range(0,freq.shape[0]):
						ndspec[i,-1]=(dspec[t,p,i,0]+dspec[t,p,i,-1])/2
						ndspec[i,0]=(dspec[t,p,i,0]+dspec[t,p,i,-1])/2
  
					fig=plt.figure(figsize=(11,6))
					gs = gridspec.GridSpec(20,20,left=0.09)
					sp = plt.subplot(gs[1:,9:18], projection='polar')
					sp.set_theta_zero_location('N')
					sp.set_theta_direction(-1)
#                                        if dspec[t,p,:,:].max()<39:

					levels=[0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1]
					plt.contourf(theta, r, ndspec[0:indf,:].T,levels,cmap='Purples',norm=colors.Normalize(vmin=0.0,vmax=1,clip=False), extent=[-3,3,-3,3])
					ax1 = plt.gca()
					pos1 = ax1.get_position()
					l1, b1, w1, h1 = pos1.bounds
					cax1 = plt.axes([l1+w1+0.04, b1+0.1, 0.017, h1-0.2]) # setup colorbar axes.
					cbar=plt.colorbar(cax=cax1, orientation='vertical',format='%3.1f');cbar.ax.tick_params(labelsize=7)
					plt.colorbar(cax=cax1) # draw colorbar
					plt.axes(ax1)  # make the original axes current again

					levels=[1,2,3,4,5,6,7,8,9,10]
					plt.contourf(theta, r, ndspec[0:indf,:].T,levels,cmap='viridis',norm=colors.Normalize(vmin=1,vmax=10,clip=False), extent=[-3,3,-3,3])

					ax2 = plt.gca()
					pos2 = ax2.get_position()
					l2, b2, w2, h2 = pos1.bounds
					cax2 = plt.axes([l2+w2+0.08, b2+0.1, 0.017, h2-0.2]) # setup colorbar axes.
					cbar=plt.colorbar(cax=cax2, orientation='vertical',format='%3.1f');cbar.ax.tick_params(labelsize=7)
					plt.colorbar(cax=cax2) # draw colorbar
					plt.axes(ax2)  # make the original axes current again


					levels=[10,20,30,40,50,60,70,80,90,100]
					plt.contourf(theta, r, ndspec[0:indf,:].T,levels,cmap='spring_r',norm=colors.Normalize(vmin=10,vmax=100,clip=False), extent=[-3,3,-3,3])


#					if dspec[t,p,:,:].max()<6.0:
#						levels=[0.02,0.04,0.08,0.1,0.2,0.3,0.5,0.8,1,2,3,4,5,6]
#						plt.contourf(theta, r, ndspec[0:indf,:].T,levels,cmap=palette,norm=colors.Normalize(vmin=0.02,vmax=6.0,clip=False), extent=[-3,3,-3,3])
#					else:
#						levels=np.linspace(0.1,dspec[t,p,:,:].max(), num=12, endpoint=True, retstep=False)
#						plt.contourf(theta, r, ndspec[0:indf,:].T,levels.round(1),cmap=palette,norm=colors.Normalize(vmin=0.1,vmax=dspec[t,p,:,:].max(),clip=False), extent=[-3,3,-3,3])

					plt.figtext(0.2,0.93,'WW3'+mod+' - CHM - Espectro de Onda  '+str(sdate[t,2]).zfill(2)+'/'+str(sdate[t,1]).zfill(2)+'/'+str(sdate[t,0]).zfill(4)+' '+str(sdate[t,3]).zfill(2)+'Z  - '+estac2+'', fontsize=14)
					plt.yticks([0.05, 0.1, 0.15, 0.2] , ["20", "10", "7", "5"])
					ax = plt.gca()
					pos = ax.get_position()
					l, b, w, h = pos.bounds
					cax = plt.axes([l+w+0.12, b+0.1, 0.017, h-0.2]) # setup colorbar axes.
					cbar=plt.colorbar(cax=cax, orientation='vertical',format='%3.1f');cbar.ax.tick_params(labelsize=7)
					plt.colorbar(cax=cax) # draw colorbar
					plt.axes(ax)  # make the original axes current again
					plt.figtext(0.57,0.05,"Dir. de Onda (de onde vem)",fontsize=8)
					plt.figtext(0.88,0.15,"$(m^{2}/Hz)/rad$",fontsize=10)

					# Power spectrum
					sp2 = plt.subplot(gs[10::,0:8])
					plt.plot((freq[0:indf2]),pwst[t,p,0:indf2],'k',linewidth=3.0)
					sp2.tick_params(labelsize=7)
					zpwst = np.zeros((pwst[t,p,0:indf2].shape[0]),'f')
					plt.fill_between((freq[0:indf2]),pwst[t,p,0:indf2], where=pwst[t,p,0:indf2]>=zpwst, interpolate=True, color='0.5')
					plt.grid()
					plt.ylim(0,0.2)
					plt.xlim(0,0.25)
					plt.xlabel('Periodo (s)',fontsize=9)
					plt.xticks([0, 0.05, 0.1, 0.15, 0.2] , ["25", "20", "10", "7", "5"] )
					plt.ylabel('Densidade de Energia ($m^{2}$/Hz)',fontsize=9)
					plt.figtext(0.17,0.51,"Espectro de Energia",fontsize=11)         
					# table of info
					if lat[p]>=0.0:
						fllat='N'
					else:
						fllat='S'
					if lon[p]>=0.0:
						fllon='E'
					else:
						fllon='W'

					plt.figtext(0.09,0.82,"Latitude: "+str(round(abs(lat[p]),2))+fllat+"    Longitude: "+str(round(abs(lon[p]),2))+fllon,fontsize=12)
					plt.figtext(0.09,0.78,"Profundidade: "+str(round(depth[p],1))+" m",fontsize=13)
					plt.figtext(0.09,0.74,"Alt. Significativa de Onda: "+str(round(4.01*np.sqrt(sum(pwst[t,p,:])),2))+" m",fontsize=13)
					plt.figtext(0.09,0.70,"Vel. Vento: "+str(round(wnds[t,p],2))+" m/s",fontsize=13)
					plt.figtext(0.09,0.66,"Dir. Vento: "+str(round(wndd[t,p]))+" graus",fontsize=13)
					plt.savefig(fpath+'dspec_full_'+estac+'_t'+str(t).zfill(3)+'.png', dpi=None, facecolor='w', edgecolor='w',
					orientation='portrait', papertype=None, format='png',
					transparent=False, bbox_inches=None, pad_inches=0.1)
					plt.close()
					# ===================================================

				# -----------------------------------------

				plt.close('all')

		# Writing output text files
		# PREP PLEDS output file ---------------------------------------------
		if ppoutf==1:
			for p in range(0,npo):

				vf=file(fpath+'prepPLEDS_p'+str(p+1).zfill(3)+'.txt','w')
				vf.write('% WAVEWATCH III PREP_PLEDS - Input file for PLEDS-WW3 plots (Campos&Parente 2009)')
				vf.write('\n')
				vf.write('% Position:  Lat '+repr(lat[p])[0:6]+'   Lon '+repr(lon[p])[0:6])
				vf.write('\n')
				vf.write('% depth:  '+repr(depth[p])+' m')
				vf.write('\n')
				vf.write('% Freq Band (s):    1) '+repr(1/freq[0])[0:5]+'-'+repr(1/freq[la])[0:5]+'        2) '+repr(1/freq[la])[0:5]+'-'+repr(1/freq[lb])[0:5]+'        3) '+repr(1/freq[lb])[0:5]+'-'+repr(1/freq[lc])[0:5]+'        4) '+repr(1/freq[lc])[0:5]+'-'+repr(1/freq[ld])[0:5]+'        5) '+repr(1/freq[ld])[0:5]+'-'+repr(1/freq[nf-1])[0:5])         
				vf.write('\n')
				vf.write('% Date(Y M D H)     En(1) Hs(1) Dp(1)     En(2) Hs(2)  Dp(2)    En(3) Hs(3) Dp(3)     En(4) Hs(4) Dp(4)     En(5) Hs(5) Dp(5)')
				vf.write('\n')
				np.savetxt(vf,np.transpose([sdate[:,0],sdate[:,1],sdate[:,2],sdate[:,3],ef[:,p,0],hs[:,p,0],dpf[:,p,0],ef[:,p,1],hs[:,p,1],dpf[:,p,1],ef[:,p,2],hs[:,p,2],dpf[:,p,2],ef[:,p,3],hs[:,p,3],dpf[:,p,3],ef[:,p,4],hs[:,p,4],dpf[:,p,4]]),fmt="%4i %2i %2i %2i %12.5f %4.2f %5.1f %10.5f %4.2f %5.1f %10.5f %4.2f %5.1f %10.5f %4.2f %5.1f %10.5f %4.2f %5.1f",delimiter='/t') 
				vf.close()

		# -------------------------------------------------------------------

