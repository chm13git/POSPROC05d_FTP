#!/usr/bin/env python
# -*- coding: utf-8 -*-
# -*- coding: iso-8859-1 -*-

import numpy as np
from netCDF4 import Dataset


#----------------------------------------------
# altera no arq escolhido (file) 
# a string velha (str1) pela string nova (str2)

def alteraStr(file,str1,str2):
    s = open(file).read()
    s = s.replace(str1, str2)
    f = open(file, 'w')
    f.write(s)
    f.close()
    return


def alteraDia(file,dataini,datai,datafim,dataf):
    s = open(file).read()
    s = s.replace('dataini', datai)
    s = s.replace('datafim', dataf)
    f = open(file, 'w')
    f.write(s)
    f.close()
    return


def verificaRod(file):
    for line in open(file):
        if 'CONFLICTING TIMES' in line:
            temp=tuple(line[1:-1].split(' '))
            datarod = temp[10]+' '+temp[12] 

    return True 



def calcFreqs(NF,fini,freq_fac):
    freq = []
    for i in range(1,NF):
        freq.append(fini*freq_fac**(i-1)) #frequencias
    return freq


def horarios(data):
    horas = []
    ano   = data[0:4]
    mes   = data[4:6]
    dia   = data[6:8]
    horas.append(ano)
    horas.append(mes)
    horas.append(dia)
    return horas 



# -----------------------
# ideias para desenvolver
#
#def defineDir
#def defHorarios


# Transformar dir em u, v
def dir2uv(dir):
    # colocando máscara na terra
    dir = np.where((dir<0) | (dir>360), np.nan, dir)

    # decompondo a direção
    v   = np.cos(dir*np.pi/180)
    u   = np.sin(dir*np.pi/180)
    return u, v


# Transformar u, v em dir, mag
def uv2magdir(u, v):
    # colocando máscara na terra
    u = np.where((u<-100) | (u>100), np.nan, u)
    v = np.where((v<-100) | (v>100), np.nan, v)

    # calculando direção
    dir = np.arctan2(u,v)
    dir = dir*180/np.pi # para grau
    dir = np.where(dir<0, dir+360, dir)

    # calculando magnitude
    mag = np.sqrt(u**2+v**2)
    return mag, dir


# Criar netcdf
def create_nc(ncname, varin, lat, lon, time, time_units, var_units='degrees', var_standard_name='', var_long_name='', 
              missing_value=-999., time_calendar='standard', lat_units='degrees_north', lon_units='degrees_east',
              lat_long_name='latitude', lon_long_name='longitude'):

    """ Write netcdf file.

    This fuction is adapted to WW3 data.

    :param ncname:            the netcdf file name
    :type  ncname:            str
    :param varin:             the wave direction data
    :type  varin:             numpy array
    :param lat:               latitude
    :type  lat:               list
    :param lon:               longitude
    :type  lon:               list
    :param time:              time
    :type  time:              list
    :param time_units:        the initial forecast time
    :type  time_units:        str
    :param var_units:         wave direction data units
    :type  var_units:         str
    :param var_standard_name: standart variable name
    :type  var_standard_name: str
    :param var_long_name:     long variable name
    :type  var_long_name:     str
    :param missing_value:     missing value
    :type  missing_value:     float
    :param time_calendar:     the pattern used in calendar
    :type  time_calendar:     str
    :param lat_units:         latitude units
    :param lat_units:         str
    :param lon_units:         longitude units
    :param lon_units:         str
    :param lat_long_name:     latitude name
    :param lat_long_name:     str
    :param lon_long_name:     longitude name
    :param lon_long_name:     str
    :return: WW3 dir/dp in netcdf
    """
    foo = Dataset(ncname, 'w')

    foo.createDimension('time',      time.shape[0])
    foo.createDimension('latitude',  lat.shape[0])
    foo.createDimension('longitude', lon.shape[0])

    times             = foo.createVariable('time', 'f8', 'time')
    times.units       = time_units
    times.calendar    = time_calendar
    times[:]          = time

    laty              = foo.createVariable('latitude', 'f4', 'latitude')
    laty.units        = lat_units
    laty.long_name    = lat_long_name
    laty[:]           = lat

    lonx              = foo.createVariable('longitude', 'f4', 'longitude')
    lonx.units        = lon_units
    lonx.long_name    = lon_long_name
    lonx[:]           = lon

    var               = foo.createVariable(var_standard_name, 'f', ('time', 'latitude', 'longitude'))
    var.units         = var_units
    var.long_name     = var_long_name
    var.missing_value = missing_value
    var[:]            = varin

    foo.close()

