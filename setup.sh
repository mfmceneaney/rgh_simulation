#!/bin/bash
cd $RGH_SIM_WORK_DIR

# Replace local paths in gcard using pwd
sed -i.bak "s;/work/clas12/mccontalb/GEMC/gcard;$RGH_SIM_WORK_DIR/mccontalb_GEMC_gcard;g" *.gcard
