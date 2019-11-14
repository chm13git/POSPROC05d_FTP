#!/bin/bash
################################################################
# Scripts para backupear os dados do ICON com 13km 
#
# Feito por 1T(RM2-T) Luz em 31OUT2019
# Modified by CT(T)Alana 04th of november 2019 
# Modificado por 1T(RM2-T) Luz em 08NOV2019
###############################################################
set -x
HH=$1

if [ $# -lt 1 ]
then
echo " Entre com o horario de referencia 00 ou 12"
exit 12
fi

DIRBKP=/home/operador/grads/icon_13km/backup

### Criando o diretorio com a data do dia ###
data=`date +%Y%m%d`
echo $data
mkdir -p ${DIRBKP}/backup${HH}/${data}

##### Movendo os dados para o diretorio do dia
mv ${DIRBKP}/backup${HH}/*${data}${HH}* ${DIRBKP}/backup${HH}/${data}/

######Comprimindo o diretorio dos dias em bz2
cd ${DIRBKP}/backup${HH}/  
tar -jcvf icon_global_icosahedral_${data}_${HH}.tar.bz2 ${data}

### Fazendo Backup dos dados na DPNS32
echo "FAZENDO BACKUP DO ICON 13km NA DPNS32"

rsync  -auvzhlL /home/operador/grads/icon_13km/backup/backup${HH}/*.bz2 admbackup@10.13.100.32:/data2/backup_icon/backup_icon13km

echo "O Backup dos dados do ICON foi realizado com sucesso ${data}${HH}Z" 
echo | mail -s 'O Backup dos dados do ICON foi realizado com sucesso ${data}${HH}Z' alana@smm.mil.br, priscila.luz@smm.mil.br, supervisor@smm.mil.br

echo
################################################################################################
# APAGAR dados anteriores ha 2 dias na DPNS05d
#################################################################################################

#Pega a data atual
DATA=`date +%Y%m%d`
echo "$DATA"

DIR05d="/home/operador/grads/icon_13km/backup/backup${HH}"

echo "Apagando dados anteriores ha 2 dias"

# O programa fara dois processos:
# 1) Saber se existe o arquivo com mais de 2 dias ; e
# 2) Apagar o arquivo se a data for anterior ao que devera estar armazenado

#Setar o numero de dias que precisam estar no diretorio (neste caso 2 dias anteriores) 

n=2

#Colocar um valor maior que n para o while calcular o menor que 
# (neste caso checa se existem dados entre 2 e 5 dias anteriores) 

while [ ${n} -le 5 ]; do

        DATAANTERIOR=`/usr/bin/caldate ${DATA} - ${n}d  'yyyymmdd'`
        echo "$DATAANTERIOR"

        cd ${DIR05d}
	# O nome dos arquivos a serem apagados:
	if [ -f ${DIR05d}/icon_global_icosahedral_${DATAANTERIOR}_${HH}.tar.bz2 ]; then
                echo "existe o dado icon_global_icosahedral_${DATAANTERIOR}_${HH}.tar.bz2"
                echo "vou apagar o dado e o diretorio"
                rm icon_global_icosahedral_${DATAANTERIOR}_${HH}.tar. bz2
		cd ${DIR05d}
                cd ${DATAANTERIOR}
		rm *.bz2
		cd ${DIR05d}
		rmdir ${DATAANTERIOR} 
	else
		echo "nao existe o dado"
	fi

n=`expr $n + 1`
done

