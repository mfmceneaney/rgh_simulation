#!/bin/bash
cd $RGH_SIM_HOME

# Replace local paths in gcard using pwd
sed -i.bak "s;/work/clas12/mccontalb/GEMC/gcard;$RGH_SIM_HOME/mccontalb_GEMC_gcard;g" *.gcard
