#!/bin/bash

/opt/opengrads/opengrads -bpc "run /home/operador/grads/cosmo/cosmoant/gs/zygrib.gs"
/opt/opengrads/opengrads -bpc "run /opt/opengrads/Resources/Scripts/lats4d.gs -i /home/operador/grads/cosmo/cosmoant/ctl/cosmo_zygrib.ctl -format grib -center chm -table zygribtable -o /home/operador/grads/cosmo/cosmoant/zygribHH/cosmo_zygrib_total"
cd /home/operador/grads/cosmo/cosmoant/zygribHH
grib_set -s generatingProcessIdentifier=31 cosmo_zygrib_total.grb cosmo_zygrib2_total.grb
mv cosmo_zygrib2_total.grb cosmo_zygrib_total.grb
