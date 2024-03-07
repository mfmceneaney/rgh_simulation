#!/bin/bash
cd /work/clas12/users/$USER/rgh_simulation
i=1

export NITERATIONS=1000
export NEVENTS=10000

while [ $i -le $NITERATIONS ]
do
echo "$i > $PWD/submit$i.sh"
echo
cp job.sh job$i.sh
cp submit.sh submit$i.sh
sed -i "s;MCINDEX=0;MCINDEX=$i;g" job$i.sh
sed -i "s;NEVENTS=100;NEVENTS=$NEVENTS;g" job$i.sh
sed -i "s;job.sh;job$i.sh;g" submit$i.sh
sbatch submit$i.sh
((i++))
done
