!#/bin/bash
set -x
AREA=$1
HH=$2

if [ $# -ne 2 ]
then
echo " Entre com a area modelada met, sse ou pry e o horario 00 ou 12 "
exit 12
fi


nlinhas=`cat /home/operador/grads/cosmo/cosmo${AREA}/invariantes/lista_supervisor | wc -l`
AREATITULO=`echo $AREA | tr '[a-z]' '[A-Z]'`

rm /home/operador/grads/cosmo/cosmo${AREA}/listatransf
for n in `seq 1 $nlinhas`
do

linha=`head -$n /home/operador/grads/cosmo/cosmo${AREA}/invariantes/lista_supervisor | tail -1`
coment=`echo $linha | cut -c1`
     if [ $coment != "#" ]
     then

        arq=`echo $linha | awk ' { print $1 }'`
        progs=`echo $linha | awk ' { print $2 } '`
        cat /home/operador/grads/cosmo/cosmo${AREA}/invariantes/listagifs | awk ' $1 == "'$arq'" { print $2 } ' > arqs.raw
        echo $arq >> /home/operador/grads/cosmo/cosmo${AREA}/listatransf

        listags=`cat arqs.raw | tr '\012' ' '`

        echo $progs | tr ';' '\012' > listatempo

        nlinhastempo=`cat listatempo | wc -l`
        nlinhastempo=$((nlinhastempo-1))
        str=""
        for j in `seq 1 $nlinhastempo`
        do
            head -$j listatempo | tail -1 > linhatempo
            nl=`grep -o "-" linhatempo | wc -l`

            case $nl in
            0)
            progi=`cat linhatempo | cut -f1 -d"-"`
            progf=$progi
            inter=3
            ;;
            1)
            progi=`cat linhatempo | cut -f1 -d"-"`
            progf=`cat linhatempo | cut -f2 -d"-"`
            inter=3
            ;;
            2)
            progi=`cat linhatempo | cut -f1 -d"-"`
            progf=`cat linhatempo | cut -f3 -d"-"`
            inter=`cat linhatempo | cut -f2 -d"-"`
            ;;
            esac

            DIG='0'
            
           for HREF in `seq $progi $inter $progf`;do

                if [ $HREF -lt 10 ]
                then
                     HORA=0$DIG$HREF
                elif [ $HREF -lt 100 ];then
                     HORA=$DIG$HREF
                else
                     HORA=$HREF
                fi

                str="${str} ${HORA}"
             done

        done

      
        for arq in `echo $listags`
        do
            rm -f raw.gs

            echo "'reinit'" > raw.gs

            echo str=\"$str\" >> raw.gs

            nprogs=`echo $str | wc -w`

            echo nprogs=$nprogs >> raw.gs
            
            cat /home/operador/grads/cosmo/cosmo${AREA}/gs_supervisor/$arq > temp1

            if [ -s /home/operador/grads/cosmo/cosmo${AREA}/invariantes/grad$AREA ]
            then

                cat /home/operador/grads/cosmo/cosmo${AREA}/invariantes/grad$AREA >> temp1

            fi

            cat temp1 | sed -e 's|ARQUIVOCTL|/home/operador/grads/cosmo/cosmo'$AREA'/ctl/ctl'$HH'/cosmo'_${AREA}_${HH}'|g' > temp2

            mv temp2 temp1

            cat temp1 | sed -e 's|DIRARQUIVOGIF|/home/operador/grads/gif/cosmo'$AREA'_'$HH'|g' > temp2

            cat temp2 | sed -e 's|MODELO|Modelo COSMO '$AREATITULO'/CHM|g' > temp1

            cat temp1 | sed -e 's|brmap_hires.dat|hires|g'> temp2

            cat temp2 | sed -e 's|hires|brmap_hires.dat|g' > temp1

            cat temp1 | sed -e 's|mres|brmap_hires.dat|g' > temp2

            cat temp2 | sed -e 's|HH|'$HH'|g' > temp1

            cat temp1 | sed -e 's|AREA|'${AREA}'|g' > temp2

            cat temp2 | sed -e 's|DIRCOMISSAOGIF|/home/operador/ftp_comissoes/gif/cosmo'$AREA'_'$HH'|g' > temp1

            cat temp1 >> raw.gs

           cat /home/operador/grads/cosmo/scripts/label >> raw.gs
          
           cat /home/operador/grads/cosmo/scripts/gettime >> raw.gs 

           /opt/opengrads/opengrads -bpc "run raw.gs"

           echo $arq
           rm arqs.raw temp2 temp1 listatempo linhatempo
#           rm raw.gs
        done

     fi

done

