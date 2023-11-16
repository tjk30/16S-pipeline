#!/bin/bash
#SBATCH -J dada2
#SBATCH --mem=128000
#SBATCH --output=6_dada2-%J.out
#SBATCH --error=6_dada2-%J.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH -p scavenger 

# USAGE: sbatch --mail-user=youremail@duke.edu 5_dada2.sh /path/to/XXXXXXXX_results /path/to/silva-database-dir /path/to/metabarcoding.sif /path/to/where-scripts-are-stored

singularity exec --bind $1,$PWD,$2,$4 $3 Rscript $4/5_dada2.R $1 $2 
