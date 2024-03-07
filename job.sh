#!/bin/bash

# IMPORTANT! Load local CCDB copy
module load sqlite/dev
module load xrootd

# Set job info
export MCINDEX=0 #NOTE: NEED TO CHANGE FROM SETUP.SH
export BASENAME="out_rgh_NH3_${MCINDEX}"
export BASEDIR="/work/clas12/users/$USER/rgh_simulation"
export BEAM_ENERGY=10.6
export TARGET_TYPE="proton"
export NEVENTS=100 #NOTE: NEED TO CHANGE FROM SETUP.SH? -> Definitely increase for actual jobs but keep this for testing...
export EVPFILE=$NEVENTS
export GCARD="$BASEDIR/rgh_physics.gcard"
export YAML="$BASEDIR/rgh_physics.yaml"
export OUTDIR="/volatile/clas12/users/$USER/rgh_simulation"
mkdir -p $OUTDIR

# Run MC event Simulations (nh3 target 10.6 GeV)
export OUTDIR_LUND="${OUTDIR}/lund"
mkdir -p $OUTDIR_LUND
export LUNDFILE=$OUTDIR_LUND/$BASENAME
export LUNDFILE=`clasdis --beam $BEAM_ENERGY --targ $TARGET_TYPE --trig $NEVENTS --nmax $EVPFILE --path $LUNDFILE  | grep '^Data file Name .*' | grep -Eo $BASENAME.*`
export LUNDFILE=$OUTDIR_LUND/$LUNDFILE

# Run GEMC detector simulation
export OUTDIR_GEMC="${OUTDIR}/gemc"
mkdir -p $OUTDIR_GEMC
export GEMCFILE=$OUTDIR_GEMC/$BASENAME.hipo
gemc $GCARD -USE_GUI=0 -RUNNO=11 -INPUT_GEN_FILE="LUND, $LUNDFILE" -OUTPUT="hipo, $GEMCFILE" -N=$NEVENTS

# Run CLAS12 reconstruction
export OUTDIR_REC="${OUTDIR}/cooked"
mkdir -p $OUTDIR_REC
export RECFILE=$OUTDIR_REC/$BASENAME.hipo
recon-util -i $GEMCFILE -o $RECFILE -n $NEVENTS -y $YAML
