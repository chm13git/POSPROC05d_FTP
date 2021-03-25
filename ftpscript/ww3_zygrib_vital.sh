#!/bin/bash
# --------------------------------------------------
#
# Script para gerar o zygrib do WW3 para a comissão
# 
# --------------------------------------------------

#pegar o .grb2 na 01/31
#transformar pra .grb
#cortar lat lon (olhar na 31)
#modificar o nome
#mover para zygrib
#apagar DIRETORIOWORK/*.grb



if [ $# -lt 3 ]
then
    echo
    echo "Entre com a forçante (gfs, icon ou cosmo), horario de referencia (00 ou 12),"
    echo "caminho (01 ou 31) e data (opcional)"
    echo
    echo "Ex: ww3_grib_vital.sh cosmo 00 31 20210318"
    exit
fi

### ---------------------------
### Definindo argumentos e data
mod=$1
cyc=$2
cam=$3
flag=1

if [ $4 ]; then
    date=$4
else
    date=`date +%Y%m%d`
fi


### Definindo diretorios e nomes dos arquivos
# Diretorios da 31 ou 01
grb2dir31="/mnt/nfs/dpns32/data2/operador/mod_ondas/ww3_418/output/ww3${mod}/wave.${date}"
grb2dir01="/mnt/nfs/dpns33/data1/ww3desenv/mod_ondas/ww3_418/output/ww3${mod}/wave.${date}"

# Diretorios na 05d
workdir="/home/operador/grads/cosmo/cosmomet/zygrib${cyc}/work"
zygribdir="/home/operador/grads/cosmo/cosmomet/zygrib${cyc}"

# Nomes dos arquivos
grb2file="met_${date}_${cyc}.grb2"
grbfile="met_${date}_${cyc}.grb"
zygribfile="ww3${mod}_${cyc}_metarea5_comissaovital_${date}.grb"


### Copiando o .grb2 da 31/01 para a 05d
## Checando em qual máquina rodou
# Usando 31 como argumento 
if [ $3 == 31 ]; then
    while [ $flag -eq 1 ]; do
        # DPNS31
        if [[ -f "${grb2dir31}/${grb2file}" ]] ; then
            echo "O .grb2 foi gerado na DPNS31"
            flag=0
            cam=31
            grb2dir=${grb2dir31}

        # DPNS01
        elif [[ -f "${grb2dir01}/${grb2file}" ]]; then
            echo "O .grb2 não foi gerado na DPNS31. Será usado o da DPNS01"
            flag=0
            cam=01
            grb2dir=${grb2dir01}

        # NÃO RODOU            
        else
            k=`expr $ni + 1`
            ni=$k
            echo "O modelo não rodou em nenhuma máquina"
            echo "Aguardando o fim da rodada do ww3${mod} das ${cyc}Z"
            sleep 60

            if [ $ni -ge 480 ] ; then
                echo "Apos 8 horas abortei a rodada !!!!"
                exit 12
            fi
        fi
    done

# Usando 01 como argumento
elif [ $3 == 01 ]; then
    while [ $flag -eq 1 ]; do
        # DPNS01
        if [[ -f "${grb2dir01}/${grb2file}" ]]; then
            echo "O .grb2 foi gerado na DPNS01"
            flag=0
            cam=01
            grb2dir=${grb2dir01}

        # DPNS31
        elif [[ -f "${grb2dir31}/${grb2file}" ]]; then
            echo "O .grb2 não foi gerado na DPNS01. Será usado o da DPNS31"
            flag=0
            cam=31
            grb2dir=${grb2dir31}

        # NÃO RODOU
        else
            k=`expr $ni + 1`
            ni=$k
            echo "O modelo não rodou em nenhuma máquina"
            echo "Aguardando o fim da rodada do ww3${mod} das ${cyc}Z"
            sleep 60

            if [ $ni -ge 480 ] ; then
                echo "Apos 8 horas abortei a rodada !!!!"
                exit 12
            fi
        fi
    done
fi


## Copiando para a 05d
echo "Copiando da DPNS${cam} para a 05d..."
cp "${grb2dir}/${grb2file}" "${workdir}"

### Manobrando os dados
# Convertendo de .grb2 para grb2
echo "Convertendo de .grb2 para .grb..."
/home/operador/cnvgrib-3.2.0/cnvgrib -g21 "${workdir}/${grb2file}" "${workdir}/${grbfile}"

# Cortando para as lat/lon desejadas
echo "Cortando as lat/lon..."
cdo -f grb sellonlatbox,-55,-20,-35,-20 "${workdir}/${grbfile}" "${workdir}/${zygribfile}"

# Movendo para o diretório do zygrib
echo "Movendo para o diretório do zygrib..."
mv "${workdir}/${zygribfile}" "${zygribdir}/${zygribfile}"

# Apagando diretório /work
rm "${workdir}/${grb2file}"
rm "${workdir}/${grbfile}"
