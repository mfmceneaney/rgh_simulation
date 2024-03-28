#!/bin/bash

# IMPORTANT! Load local CCDB copy
module load sqlite/dev
module load xrootd

# Set job info
export MCINDEX=0 #NOTE: NEED TO CHANGE FROM SETUP.SH
export BASENAME="out_rgh_NH3_${MCINDEX}"
export BASEDIR="/work/clas12/users/$USER/rgh_simulation"
export SEED=$MCINDEX #NOTE: Just use the file index number as the seed for now.
export BEAM_ENERGY=10.6
export TARGET_TYPE="proton"
export NEVENTS=100 #NOTE: NEED TO CHANGE FROM SETUP.SH? -> Definitely increase for actual jobs but keep this for testing...
export EVPFILE=$NEVENTS
export GCARD="$BASEDIR/rgh_physics.gcard"
export YAML="$BASEDIR/rgh_physics.yaml"
export OUTDIR="/volatile/clas12/users/$USER/rgh_simulation"
mkdir -p $OUTDIR

function check_task_status() {

    # Set arguments
    export TASK_NAME=$1
    export TASK_OUTPUT=$2
    export TASK_STATUS=$3
    export TASK_EXIT_CODE=$4

    # Print info
    echo "Task name:   $TASK_NAME"
    echo "Task output: $TASK_OUTPUT"
    echo "Task status: $TASK_STATUS"

    # Exit if status is nonzero
    if ($TASK_STATUS !=0)
        echo "Task failed. Exit code $TASK_EXIT_CODE."
        exit $TASK_EXIT_CODE
    endif
    
}

# Run MC event Simulations (nh3 target 10.6 GeV)
export OUTDIR_LUND="${OUTDIR}/lund"
mkdir -p $OUTDIR_LUND
export LUNDFILE=$OUTDIR_LUND/$BASENAME
clasdis --seed $SEED --beam $BEAM_ENERGY --targ $TARGET_TYPE --trig $NEVENTS --nmax $EVPFILE --path $LUNDFILE
export LUND_TASK_STATUS=$?
export LUNDFILE=$OUTDIR_LUND/${BASENAME}clasdis*.dat
check_task_status "clasdis" $LUNDFILE $LUND_TASK_STATUS 1

# Run GEMC detector simulation
export OUTDIR_GEMC="${OUTDIR}/gemc"
mkdir -p $OUTDIR_GEMC
export GEMCFILE=$OUTDIR_GEMC/$BASENAME.hipo
gemc $GCARD -USE_GUI=0 -RUNNO=11 -INPUT_GEN_FILE="LUND, $LUNDFILE" -OUTPUT="hipo, $GEMCFILE" -N=$NEVENTS
export GEMC_TASK_STATUS=$?
check_task_status "gemc" $GEMCFILE $GEMC_TASK_STATUS 2

# Run CLAS12 reconstruction
export OUTDIR_REC="${OUTDIR}/cooked"
mkdir -p $OUTDIR_REC
export RECFILE=$OUTDIR_REC/$BASENAME.hipo
recon-util -i $GEMCFILE -o $RECFILE -n $NEVENTS -y $YAML
export REC_TASK_STATUS=$?
check_task_status "recon-util" $RECFILE $REC_TASK_STATUS 3

# Create DST
export OUTDIR_DST="${OUTDIR}/dst"
mkdir -p $OUTDIR_DST
export DSTFILE=$OUTDIR_DST/$BASENAME.hipo
export FILTER_BANKS='RUN::*,RAW::epics,RAW::scaler,HEL::flip,HEL::online,REC::*,RECFT::*,MC::RecMatch,MC::GenMatch,MC::Particle,MC::User,MC::Header,MC::Lund,MC::Event'
hipo-utils -filter -b $FILTER_BANKS -merge -o $DSTFILE $RECFILE
export DST_TASK_STATUS=$?
check_task_status "hipo-utils -filter" $DSTFILE $DST_TASK_STATUS 4

# Clean up intermediate files
rm $LUNDFILE
rm $GEMCFILE
rm $RECFILE
