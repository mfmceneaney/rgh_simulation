#!/bin/bash

#SBATCH --job-name=clas12Lambdas
#SBATCH --output=/farm_out/%u/%x-%j-%N.out
#SBATCH --error=/farm_out/%u/%x-%j-%N.err
#SBATCH --partition=production
#SBATCH --account=clas12
#SBATCH --mem-per-cpu=4000
#SBATCH --gres=disk:1000
#SBATCH --time=24:00:00
#SBATCH --mail-user=matthew.mceneaney@duke.edu

export OUTDIR=/volatile/clas12/users/mfmce/rgh_simulation_acceptance_ratios_10_9_24/lund
export PREFIX=out_rgh_NH3_

mkdir -p $OUTDIR
cd $OUTDIR
nohup clasdis --zpos -4.5 --zwidth 5.0 --targ proton --nont --nmax 10000 --parj21 0.6 --beam 10.6 --raster 1.8 --trig 10000000 --pol 1 --path ${PREFIX}

# Move files to numbered prefix names for ease of use
i=1
for file in *.dat
do
    echo $file
    export NEWFILENAME=`echo $file | sed "s;${PREFIX}clasdis;${PREFIX}${i}clasdis;g"`
    echo NEWFILENAME $NEWFILENAME
    mv $file $NEWFILENAME
    ((i++))
done