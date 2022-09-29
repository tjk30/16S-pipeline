#!/bin/bash
#SBATCH -J 5_filtering
#SBATCH --mem=64000
#SBATCH --output=5_filtering-%J.out
#SBATCH --error=5_filtering-%J.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH -p scavenger 

# USAGE: sbatch --mail-user=youremail@duke.edu 5_filtering.sh /path/to/XXXXXXXX_results /path/to/16s-analysis.sif

# load R via container 
singularity exec --bind $1,$PWD $2 Rscript 5_filtering.R $1
