#!/bin/bash -x

# Requisitos:
# arquivo /home/operador/datas/datacorrenteHH
# script /usr/bin/caldate
# geractl.sh
# meteogramas.sh
# corteverical.sh

# Esse script gera os cortes verticais e os meteogramas para o modelo WRF a 
# partir das saidas gribs do WRF. Desta forma e possivel gerar um meteograma
# ou corte vertical para qualquer ponto da grade do modelo com a mesma frequencia
# horaria da saida do modelo. 

# Esses produtos estao na maquina do supervisor junto
# com os demais produtos do WRF em modelos_gif/WRF_AREA. Esteja certo que o meteograma
# que deseja gerar nao é o meteograma da pasta meteogramas_auto da maquina do supervisor.
# Para estes meteogramas o script correto é o gerameteogramas.sh    

# Este script precisa receber a area e o horario de referencia

if [ $# -ne 3 ];then

	echo "Entre com  area (metarea5, sse, ne ou ant), o horario de referencia (00 ou 12) e o prognostico final !!!"
	exit 12

fi

AREA=$1
HH=$2


# Abaixo saofeita a leitura da data corrente atraves do arquivos de datas correntes
# e e utilazo o caldate para tranformar esta data no formato necessario para entrada 
# nos scripts meteogramas.sh e cortevertical.sh

datahoje=`cat /home/operador/datas/datacorrente${HH}`
dataanalise=`/usr/bin/caldate ${datahoje}${HH} + 000h 'hhZddmmmyyyy(sd)'`

# O case sera usado para definir o diretorio onde se encontra o gs_template
# do meteograma e do corte vertical de acordo com a area. 

# O case tambem esta sendo usado para definir uma variavel chamada area3. 
# Essa variavel compoe o nome do gribs do modelo que costuma ser 
# wrf_area3_HH_YYYYMMDDprog chama-se  met5. Chamamos o modelo WRF rodado 
# na ICE pelo "apelido" 10km apenas para 
# diferencia-lo do anterior rodado na DPNS02. Porem, sua area e identica e por isso 
# foi mantinda a mesma nomenclatura para o grib.

# Tambem e definido a extensao da previsao do modelo  e uma variavel chamada DIG 
# que e usada para compor o prognostico. Em geral, se a rodada tem 78h o prognostico 
# tera dois digitos, por isso dig é vazio, se a rodada vai ate 120 horas os prognosticos 
# terao 3 digitos. Alguns modelos contrariam essa regra.

# os nomes dos meteogramas precisaram ser mantidos afim de evitar transtornos
# na atualizacao da internet por isso o prefixo dos meteogramas sse_10km e sse, do 10km
# é met. A variavel AREAN trata disso.

case $AREA in
metarea5)
	gsdir="/home/operador/grads/wrf/wrf_${AREA}/gs"
	dadosdir="/home/operador/grads/wrf/wrf_${AREA}/dados${HH}"
	AREA2="metarea5"
	AREA3=${AREA}
	DIG='0'
	HSTOP=$3
	INT="3"
	AREAN="met"
;;
antartica)
	gsdir="/home/operador/grads/wrf/wrf_${AREA}/gs"
	dadosdir="/home/operador/grads/wrf/wrf${AREA}/dados${HH}"
	AREA2="antartica"
	AREA3=${AREA}
	DIG='0'
	HSTOP=`cat /home/operador/grads/wrf/wrf_${AREA}/ctl/ctl00/progfinal`
	INT="3"
	AREAN="ant"
;;
ssudeste)
	gsdir="/home/operador/grads/wrf/wrf_${AREA}/gs"
	dadosdir="/home/operador/grads/wrf/wrf${AREA}/dados${HH}"
	AREA2="ssudeste"
	AREA3="metarea5"
	DIG='0'
	HSTOP=`cat /home/operador/grads/wrf/wrf_${AREA}/ctl/ctl00/progfinal`
	INT="3"
	AREAN="sse"
;;
caribe)
        gsdir="/home/operador/grads/wrf/wrf_${AREA}/gs"
        dadosdir="/home/operador/grads/wrf/wrf_${AREA}/dados${HH}"
        AREA2="caribe"
        AREA3=${AREA}
        DIG='0'
        HSTOP=$3
	INT="3"
        AREAN="car"
;;
cptec)
        gsdir="/home/operador/grads/wrf/wrf_${AREA}/gs"
        dadosdir="/home/operador/grads/wrf/wrf_${AREA}/grib_${HH}"
        AREA2="cptec"
        AREA3=${AREA}
        DIG='0'
        HSTOP=$3
        INT="1"
        AREAN="cptec"
esac

# Aqui sao definidos o diretorio onde as figuras serao guardadas

gifdir="/home/operador/grads/gif/wrf_${AREA}_${HH}"

# Este loop gera um string com os prognosticos na ordem descrescente de 3 em 3h
# este string sera srt="120, 117,115 ... 000" para o 10km por exemplo

for HREF in `seq $HSTOP -${INT} 0`;do

	if [ $HREF -lt 10 ];then

		HORA=0$DIG$HREF

	elif [ $HREF -lt 100 ];then

		HORA=$DIG$HREF

	else

		HORA=$HREF

	fi

str="${str} ${HORA}"

done

# O arquivo progfinal eh utilizado pelo geractl para saber qual e o ultimo prognostico 
# do modelo. Em geral o ultimo prognostico e o HSTOP, mas em casos onde as rodadas nao 
# tenham sido conluidas sera possivel gerar os meteogramas e  cortes verticais com 
# extensao temporal ate o ultimo prognostico prontificado.

#rm /home/operador/grads/wrf/wrf_${AREA}/ctl/ctl${HH}/progfinal


# O loop abaixo verifica qual e o ultimo prognostico disponivel, em situacoes normais 
# sera o prog HSTOP ele guarda no arquivo progfinal o tempo grads equivalente ao ultimo 
# prognostico.

for prog in `echo ${str}`;do

RFILE=wrf_${AREA3}_${HH}_${datahoje}${prog}
flag=1 
	while ! [ -e /home/operador/grads/wrf/wrf_${AREA2}/ctl/ctl${HH}/progfinal ] && [ $flag -eq 1 ] ;
	do

		if  [ -e ${dadosdir}/${RFILE} ] ; then

		echo "Prontificado o prognostico de ${prog}h do WRF ${AREA}"
		HFINAL=`echo "$prog / ${INT} + 1" | bc`
		echo $HFINAL > /home/operador/grads/wrf/wrf_${AREA2}/ctl/ctl${HH}/progfinal

		else

		flag=3

		fi
	done
done

# O bloco abaixo contempla apenas procedimentos
# para traduzir a dataanalise para portugues

##########################################################

meses="JAN;FEV;MAR;ABR;MAI;JUN;JUL;AGO;SET;OUT;NOV;DEZ"

months="Jan;Feb;Mar;Apr;May;Jun;Jul;Ago;Sep;Oct;Nov;Dec"

dias="Dom;Seg;Ter;Qua;Qui;Sex;Sab"

diasp="Domingo;Segunda-feira;Terca-feira;Quarta-feira;Quinta-feira;Sexta-feira;Sabado"

for j in `seq 1 7`;do

dia=`echo $dias | cut -f$j -d";"`
day=`echo $diasp | cut -f$j -d";"`
dataraw=`echo $dataanalise | sed -e 's/'$day'/'$dia'/'`
dataanalise=$dataraw

done

for j in `seq 1 12`;do

mes=`echo $meses | cut -f$j -d";"`
month=`echo $months | cut -f$j -d";"`
dataraw=`echo $dataanalise | sed -e 's/'$month'/'$mes'/'`
dataanalise=$dataraw

done

#########################################################

cd /home/operador/grads/wrf/wrf_${AREA}/ctl

# Aqui é gerado o ctl do  modelo AREA em questao, exceto o WRF-SSE_10km que por ser um 
# zoom do 10km nao tem um ctl gerado. Neste caso é gerado o ctl para o WRF-10km e 
# linkados os ctls do WRF-10km para o WRF-SSE_10km

/home/operador/grads/wrf/scripts/geractl_v2.sh ${AREA} ${HH} 

# Sao chamados os scripts de execucao dos cortes verticais e dos meteogramas 
# propriamente ditos

echo
echo " Aqui comeca a confeccao dos meteogramas para ${AREA}."

/home/operador/grads/wrf/scripts/meteogramas.sh $AREA $HH $dataanalise

echo
echo " Aqui comeca a confeccao dos cortes verticais para ${AREA}."

if ! [ ${AREA} = "cptec" ];then

        /home/operador/grads/wrf/scripts/cortevertical.sh $AREA $HH $dataanalise

else

        echo " ${AREA}=CPTEC e devido a demora de 20 min por CVERT nao ira fazer"

fi

# Os meteogramas e cortes verticais a serem gerados estao definidos em um arquivo 
# chamado listameteo e listacvert. O procedimento abaixo e para retirar desta lista 
# o nome dos meteogramas e cortes verticais.
# Estes nomes estao um cada linha e deseja-se que estejam separados por espaco, 
# da forma: meteos="meteo1 meteo2 meteo3"
# Para isto utiliza-se o comando tr e awk em conjunto

meteos=`cat /home/operador/grads/wrf/wrf_${AREA}/invariantes/listameteo | awk '{ print "*"$1"*.gif" }' | tr '\012' ' '`
cverts=`cat /home/operador/grads/wrf/wrf_${AREA}/invariantes/listacvert | awk '{ print "*"$1"*.gif" }' | tr '\012' ' '`


# convertendo de gif para png os arquivos
cd ${gifdir}

for arq in `ls cvert+neb*.gif ${AREAN}_*.gif`
do  
nomeprog=`echo $arq | cut -f1 -d.`
/usr/bin/convert $arq $nomeprog.png 
done

# ACOCHAMBRAMENTO para converter a lista de METEOGRAMAS
# que vao para a INTERNET na METAREA5.

if [ ${AREA} == "metarea5" ];then

	####Cidade-UF Separadas por um _ ####### 
	lista1="abrolhos_ba angra_rj aracaju_se balrincao_sc bcampos_rj baiagb bacupari_rs belem_pa riogrande cabofrio_rj cananeia_sp cabedelo_pb cnchar_rj chui_rs ibela_sp fnoronha floripa_sc fortal_ce garopabasc guaratuba_pr guaraparinga_sp ilhagrande imel_sp ilharasa ilheus_ba itajai_sc itaoca_es macae_rj maceio_al mage_rj marambaia_rj marataizes_es moela_sp mostarda_rs natal_rn oiapoque_ap lagoaparanoa_df paranag_pr peruibe_sp pelotas_rs poa_rs ptoseguro_ba pecem_ce recife_pe repguarapira_sp santos_sp saoluis_ma salinop_ap salvador_ba schico_sc sseb_sp spaldeia_rs spsp stamarta_rs saotome_rj tramandai_rs trindade torres_rs touros_rn vitoria_es"
	lista2="Abrolho Angra_R Aracaju BalRinc BaciaCa BaiaGua Bacupar Belem_P RioGran CaboFri Cananei Cabedel ClubeNa Chui_RS IlhaBel Fernand Florian Fortale Garopab Guaratu Guarapari IlhaGra IlhaMel IlhaRas Ilheus_ Itajai_ Itaoca_ Macae_R Maceio_ Mage_RJ Maramba Maratai IlhaMoe Mostard Natal_R Oiapoqu Paranoa Paranag Peruibe Pelotas PortoAl PortoSe Pecem_C Recife_ Guarapi Santos_ SaoLuiz Salinop Salvado SaoFran SaoSeba SPAldei SPedroS StaMart SaoTome Tramand IlhaTri Torres_ Touros_ Vitoria"
nestac=`echo $lista1 | wc -w`

        for estac in `seq 1 ${nestac}`
        do
                estacA=`echo ${lista1} | cut -d" " -f${estac}`
                estacB=`echo ${lista2} | cut -d" " -f${estac}`

                /usr/bin/convert ${gifdir}/met_${estacA}_1.gif ${gifdir}/internet/${estacB}1.jpg
		/usr/bin/convert ${gifdir}/met_${estacA}_2.gif ${gifdir}/internet/${estacB}2.jpg
        done
fi

# ACOCHAMBRAMENTO para converter a lista de METEOGRAMAS
# que vao para a INTERNET na ANTARTICA.

if [ ${AREA} == "antartica" ];then

	lista1="adelaide bellingh bransfie drake_n drake_c drake_s eacf elefante frei malvinas ptarenas ushuaia"
	lista2="Adelaid Belling Bransfi Drake_N Drake_C Drake_S EACF. Elefant Frei. Malvina PtArena Ushuaia"
	nestac=`echo $lista1 | wc -w`

        for estac in `seq 1 ${nestac}`;do

                estacA=`echo ${lista1} | cut -d" " -f${estac}`
                estacB=`echo ${lista2} | cut -d" " -f${estac}`

                /usr/bin/convert ${gifdir}/met_${estacA}_1.gif ${gifdir}/internet/${estacB}1.jpg
                /usr/bin/convert ${gifdir}/met_${estacA}_2.gif ${gifdir}/internet/${estacB}2.jpg
	done
fi
