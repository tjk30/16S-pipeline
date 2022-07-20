#!/bin/bash
#SBATCH -J 5_filtering
#SBATCH --mem=64000
#SBATCH --partition scavenger
#SBATCH --output=filtering.out
#SBATCH --error=filtering.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END

# USAGE: sbatch --mail-user=youremail@duke.edu 5_filtering.sh /path/to/seq_data/current_project/dada2/ /path/to/metabarcoding.sif

# load R via container 
singularity exec --bind $1,$PWD $2 Rscript filtering.R filtering.Rout $1
