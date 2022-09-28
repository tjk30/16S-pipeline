#!/bin/bash
#SBATCH -J 5_filtering
#SBATCH --mem=64000
#SBATCH --output=filtering-%J.out
#SBATCH --error=filtering-%J.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH -p scavenger 

# USAGE: sbatch --mail-user=youremail@duke.edu 5_filtering.sh /path/to/seq_data/current_project/dada2/ /path/to/metabarcoding.sif

# load R via container 
singularity exec --bind $1,$PWD $2 Rscript 5_filtering.R $1
