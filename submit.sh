#!/bin/bash

#SBATCH --account=clas12
#SBATCH --partition=production
#SBATCH --job-name=rgh_sidis_NH3
#SBATCH --constraint=general
#SBATCH --mail-user=%u@jlab.org
#SBATCH --output=/farm_out/%u/%x-%j-%N.out
#SBATCH --error=/farm_out/%u/%x-%j-%N.err
#SBATCH --time=24:00:00
#SBATCH --gres=disk:5000
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=2000

/work/clas12/users/$USER/rgh_simulation/job.sh
