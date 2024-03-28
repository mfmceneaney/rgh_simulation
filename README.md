# CLAS12 RGH SIDIS Simulation Studies
Basic repository for RGH simulation work.

# Prerequisites
* All CLAS12 simulation software.

This should already be installed on ifarm.  For a full list see the [CLAS12 Software Wiki](https://clasweb.jlab.org/wiki/index.php/How_to_run_the_full_simulation_train_single-threaded).

# Installation

Clone the directory
```bash
git clone https://github.com/mfmceneaney/rgh_simulation.git
```
and add the following to your startup script on ifarm
```bash
module load sqlite/dev # Copies a local snapshot of the CCDB so you don't overload the servers!
module load xrootd
```

#

Contact: matthew.mceneaney@duke.edu
