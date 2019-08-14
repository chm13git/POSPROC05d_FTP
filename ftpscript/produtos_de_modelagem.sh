#!/bin/bash
################################################################
# Scripts para backupear figuras de pos-processamento para uso 
# rapido dos clientes!!!!!!!!!!
# Feito por CT(T)Alana em 26JUL2018
###############################################################
set -xv
HH=$1

if [ $# -lt 1 ]
then
echo " Entre com o horario de referencia 00 ou 12"
exit 12
fi

### Criando pasta com a data do dia ### 
data=`date +%d%m%Y`
ano=`date +%Y`
mes=`date +%B` 

mkdir -p /home/operador/backup_produtos_modelagem/$ano/$mes/$data

echo "FAZENDO BACKUP DO FAX"

mkdir -p /home/operador/backup_produtos_modelagem/$ano/$mes/$data/fax${HH}/
dirgif="/home/operador/grads/gif/faxsimile${HH}"
dirbackup="/home/operador/backup_produtos_modelagem/$ano/$mes/$data/fax${HH}/"
	cp -p ${dirgif}/*.gif ${dirbackup}

echo "FAZENDO BACKUP DO ICON ATL"

mkdir -p /home/operador/backup_produtos_modelagem/$ano/$mes/$data/iconatl${HH}
dirgif="/home/operador/grads/gif/iconatl${HH}"
dirbackup="/home/operador/backup_produtos_modelagem/$ano/$mes/$data/iconatl${HH}"

	cp -p ${dirgif}/esp+vor_*.gif ${dirbackup}
	cp -p ${dirgif}/precpress_*.gif ${dirbackup}
	cp -p ${dirgif}/vertical_*.gif ${dirbackup}
	cp -p ${dirgif}/vento_atl_*.gif ${dirbackup}
	cp -p ${dirgif}/vent250_*.gif ${dirbackup}
	cp -p ${dirgif}/vor+geo500_*.gif ${dirbackup}

echo "FAZENDO BACKUP DO ICON ANT"

mkdir -p /home/operador/backup_produtos_modelagem/$ano/$mes/$data/iconant${HH}
dirgif="/home/operador/grads/gif/iconant${HH}"
dirbackup="/home/operador/backup_produtos_modelagem/$ano/$mes/$data/iconant${HH}"

	cp -p ${dirgif}/esp+vor_ant_*.gif ${dirbackup}
	cp -p ${dirgif}/precpress_ant_*.gif ${dirbackup}
	cp -p ${dirgif}/vertical_ant_*.gif ${dirbackup}
	cp -p ${dirgif}/vent_atl_*.gif ${dirbackup}
	cp -p ${dirgif}/vent250_ant_*.gif ${dirbackup}
	cp -p ${dirgif}/espessu_*.gif ${dirbackup}
	cp -p ${dirgif}/neve12_total_ant_*.gif ${dirbackup}

echo "FAZENDO BACKUP DO COSMO MET "

mkdir -p /home/operador/backup_produtos_modelagem/$ano/$mes/$data/cosmomet_${HH}
mkdir -p /home/operador/backup_produtos_modelagem/$ano/$mes/$data/meteogramas_cosmomet${HH}
dirgif="/home/operador/grads/gif/cosmomet_${HH}"
dirbackup="/home/operador/backup_produtos_modelagem/$ano/$mes/$data/cosmomet_${HH}"
dirgifmeteo="/home/operador/meteogramas/cosmomet${HH}"
dirbackupmeteo="/home/operador/backup_produtos_modelagem/$ano/$mes/$data/meteogramas_cosmomet${HH}"

	cp -p ${dirgif}/*.gif ${dirbackup}
	cp -p ${dirgifmeteo}/*.gif ${dirbackupmeteo}

	echo "FAZENDO BACKUP DO COSMO SSE "

mkdir -p /home/operador/backup_produtos_modelagem/$ano/$mes/$data/cosmosse_${HH}
dirgif="/home/operador/grads/gif/cosmosse_${HH}"
dirbackup="/home/operador/backup_produtos_modelagem/$ano/$mes/$data/cosmosse_${HH}"

	cp -p ${dirgif}/espvor*.gif ${dirbackup}
	cp -p ${dirgif}/precpress_*.gif ${dirbackup}
	cp -p ${dirgif}/ventmax_*.gif ${dirbackup}
	cp -p ${dirgif}/vertical*.gif ${dirbackup}
	cp -p ${dirgif}/flux850_*.gif ${dirbackup}
	cp -p ${dirgif}/vent10m_*.gif ${dirbackup}
	cp -p ${dirgif}/vorgeo500_*.gif ${dirbackup}
	cp -p ${dirgif}/vent250_*.gif ${dirbackup}
	cp -p ${dirgif}/carta_extremos_*.gif ${dirbackup}
	cp -p ${dirgif}/visibilidade_*.gif ${dirbackup}
	cp -p ${dirgif}/basenuvens_*.gif ${dirbackup}


        echo "FAZENDO BACKUP DO COSMO SSE-2.2km "

mkdir -p /home/operador/backup_produtos_modelagem/$ano/$mes/$data/cosmosse22_${HH}
dirgif="/home/operador/grads/gif/cosmosse22_${HH}"
dirbackup="/home/operador/backup_produtos_modelagem/$ano/$mes/$data/cosmosse22_${HH}"

        cp -p ${dirgif}/*.gif ${dirbackup}

        echo "FAZENDO BACKUP DO COSMO SSE-2.2km ZOOM"

mkdir -p /home/operador/backup_produtos_modelagem/$ano/$mes/$data/cosmo_sse22zoom_${HH}
dirgif="/home/operador/grads/gif/cosmo_sse22zoom_${HH}"
dirbackup="/home/operador/backup_produtos_modelagem/$ano/$mes/$data/cosmo_sse22zoom_${HH}"

        cp -p ${dirgif}/*.gif ${dirbackup}

	echo "FAZENDO BACKUP DO COSMO ANT"

mkdir -p /home/operador/backup_produtos_modelagem/$ano/$mes/$data/cosmoant_${HH}
mkdir -p /home/operador/backup_produtos_modelagem/$ano/$mes/$data/meteogramas_cosmoant${HH}
dirgif="/home/operador/grads/gif/cosmoant_${HH}"
dirbackup="/home/operador/backup_produtos_modelagem/$ano/$mes/$data/cosmoant_${HH}"
dirgifmeteo="/home/operador/meteogramas/cosmoant${HH}"
dirbackupmeteo="/home/operador/backup_produtos_modelagem/$ano/$mes/$data/meteogramas_cosmoant${HH}"

	cp -p ${dirgif}/espvor_*.gif ${dirbackup}
	cp -p ${dirgif}/precpress_*.gif ${dirbackup}
	cp -p ${dirgif}/precnev_*.gif ${dirbackup}
	cp -p ${dirgif}/vertical_*.gif ${dirbackup}
	cp -p ${dirgif}/ventmax_*.gif ${dirbackup}
	cp -p ${dirgif}/vent250_*.gif ${dirbackup}
	cp -p ${dirgif}/basenuvens_*.gif ${dirbackup}
	cp -p ${dirgif}/visibilidade_*.gif ${dirbackup}
	cp -p ${dirgif}/zoom_*.gif ${dirbackup}
	cp -p ${dirgifmeteo}/*.gif ${dirbackupmeteo}

echo "FAZENDO BACKUP DO WRF METAREA "

mkdir -p /home/operador/backup_produtos_modelagem/$ano/$mes/$data/wrf_metarea5_${HH}
dirgif="/home/operador/grads/gif/wrf_metarea5_${HH}"
dirbackup="/home/operador/backup_produtos_modelagem/$ano/$mes/$data/wrf_metarea5_${HH}"

	cp -p ${dirgif}/*.gif ${dirbackup}

echo "FAZENDO BACKUP DO WW3 METAREA (ICON) "

mkdir -p /home/operador/backup_produtos_modelagem/$ano/$mes/$data/ww3_418/ww3icon/ww3met${HH}
dirgif="/home/operador/grads/gif/ww3_418/ww3icon/ww3met${HH}"
dirbackup="/home/operador/backup_produtos_modelagem/$ano/$mes/$data/ww3_418/ww3icon/ww3met${HH}"

	cp -p ${dirgif}/ondas_???.gif ${dirbackup}
	cp -p ${dirgif}/periopeak_*.gif ${dirbackup}
	cp -p ${dirgif}/periondas_*.gif ${dirbackup}

echo "FAZENDO BACKUP DO WW3 SSE (ICON) "

mkdir -p /home/operador/backup_produtos_modelagem/$ano/$mes/$data/ww3_418/ww3icon/ww3sse${HH}
dirgif="/home/operador/grads/gif/ww3_418/ww3icon/ww3sse${HH}"
dirbackup="/home/operador/backup_produtos_modelagem/$ano/$mes/$data/ww3_418/ww3icon/ww3sse${HH}"

	cp -p ${dirgif}/ondas_???.gif ${dirbackup}
	cp -p ${dirgif}/periopeak_*.gif ${dirbackup}
	cp -p ${dirgif}/periondas_*.gif ${dirbackup}

	echo "FAZENDO BACKUP DO WW3 METAREA (COSMO) "

mkdir -p /home/operador/backup_produtos_modelagem/$ano/$mes/$data/ww3_418/ww3cosmo/ww3met${HH}
mkdir -p /home/operador/backup_produtos_modelagem/$ano/$mes/$data/ww3_418/ww3cosmo/ondogramas${HH}
dirgif="/home/operador/grads/gif/ww3_418/ww3cosmo/ww3met${HH}"
dirbackup="/home/operador/backup_produtos_modelagem/$ano/$mes/$data/ww3_418/ww3cosmo/ww3met${HH}"
dirgif_ondo="/home/operador/ondogramas/ww3_418/ww3cosmo/ww3met${HH}"
dirbackup_ondo="/home/operador/backup_produtos_modelagem/$ano/$mes/$data/ww3_418/ww3cosmo/ondogramas${HH}"

	cp -p ${dirgif}/ondas_???.gif ${dirbackup}
	cp -p ${dirgif}/periopeak_*.gif ${dirbackup}
	cp -p ${dirgif}/periondas_*.gif ${dirbackup}
	cp -p ${dirgif_ondo}/*.gif ${dirbackup_ondo}

	echo "FAZENDO BACKUP DO WW3 SSE (COSMO) "

mkdir -p /home/operador/backup_produtos_modelagem/$ano/$mes/$data/ww3_418/ww3cosmo/ww3sse${HH}
#mkdir -p /home/operador/backup_produtos_modelagem/$ano/$mes/$data/ww3_418/ww3cosmo/ondogramas${HH}
dirgif="/home/operador/grads/gif/ww3_418/ww3cosmo/ww3sse${HH}"
dirbackup="/home/operador/backup_produtos_modelagem/$ano/$mes/$data/ww3_418/ww3cosmo/ww3sse${HH}"
#dirgif_ondo="/home/operador/ondogramas/ww3_418/ww3cosmo/ww3met${HH}"
#dirbackup_ondo="/home/operador/backup_produtos_modelagem/$ano/$mes/$data/ww3_418/ww3cosmo/ondogramas${HH}"

	cp -p ${dirgif}/ondas_???.gif ${dirbackup}
	cp -p ${dirgif}/periopeak_*.gif ${dirbackup}
	cp -p ${dirgif}/periondas_*.gif ${dirbackup}
#cp ${dirgif_ondo}/*.gif ${dirbackup_ondo}

	echo "FAZENDO BACKUP DO WW3 METAREA (GFS) "

mkdir -p /home/operador/backup_produtos_modelagem/$ano/$mes/$data/ww3_418/ww3gfs/ww3met${HH}
dirgif="/home/operador/grads/gif/ww3_418/ww3gfs/ww3met${HH}"
dirbackup="/home/operador/backup_produtos_modelagem/$ano/$mes/$data/ww3_418/ww3gfs/ww3met${HH}"

	cp -p ${dirgif}/ondas_???.gif ${dirbackup}
	cp -p ${dirgif}/periopeak_*.gif ${dirbackup}
	cp -p ${dirgif}/periondas_*.gif ${dirbackup}

	echo "FAZENDO BACKUP DO WW3 SSE (GFS) "

mkdir -p /home/operador/backup_produtos_modelagem/$ano/$mes/$data/ww3_418/ww3gfs/ww3sse${HH}
dirgif="/home/operador/grads/gif/ww3_418/ww3gfs/ww3sse${HH}"
dirbackup="/home/operador/backup_produtos_modelagem/$ano/$mes/$data/ww3_418/ww3gfs/ww3sse${HH}"

	cp -p ${dirgif}/ondas_???.gif ${dirbackup}
	cp -p ${dirgif}/periopeak_*.gif ${dirbackup}
	cp -p ${dirgif}/periondas_*.gif ${dirbackup}

	echo "FAZENDO BACKUP DOS PRODUTOS DE MODELAGEM NA DPNS32"

	rsync  -auzp /home/operador/backup_produtos_modelagem/ admbackup@10.13.100.32:/home/admbackup/backup_supervisor

	echo "O Backup dos Produtos de Modelagem foi realizado com sucesso ${data}${HH}Z feito com sucesso" 
 	
	echo | Mail -s 'O Backup dos Produtos de Modelagem foi realizado com sucesso ${data}${HH}Z' alana@smm.mil.br, priscila.luz@smm.mil.br, supervisor@smm.mil.br
      
	MSG="Backup dos Produtos de Modelagem $data ${HH} feito com sucesso"
	/usr/bin/input_status.php BACKUP_PRODUTOS $HH OPERACIONAL VERDE "$MSG"

echo
echo
