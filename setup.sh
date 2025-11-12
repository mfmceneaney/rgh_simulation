#!/bin/bash
cd $RGH_SIM_HOME

# Replace local paths in gcard using pwd
sed -i.bak "s;/work/clas12/mcontalb/GEMC/GCARD;$RGH_SIM_HOME/mcontalb_GEMC_GCARD;g" *.gcard
