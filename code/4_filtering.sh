#!/bin/bash
#SBATCH -J 4_filtering
#SBATCH --mem=64000
#SBATCH --output=4_filtering.out
#SBATCH --error=4_filtering.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH -p scavenger 

# USAGE: sbatch --mail-user=youremail@duke.edu 4_filtering.sh /path/to/XXXXXXXX_results /path/to/16s-analysis.sif
# load R via container 
singularity exec --bind $1,$PWD $2 Rscript 4_filtering.R $1

# move .err and .out files
mv $PWD/4_filtering.out $1/Reports
mv $PWD/4_filtering.err $1/Reports
