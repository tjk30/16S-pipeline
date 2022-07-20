#!/bin/bash
#SBATCH -J dada2
#SBATCH --mem=128000
#SBATCH --output=dada2.out
#SBATCH --error=dada2.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END

# USAGE: sbatch --mail-user=youremail@duke.edu dada2.sh /path/to/dada2 /path/to/metabarcoding.sif

now=$(date +'%Y%m%d')
singularity exec --bind $1,$PWD $2 Rscript dada2.R dada2.Rout $1 $now

