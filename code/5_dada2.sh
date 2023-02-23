#!/bin/bash
#SBATCH -J dada2
#SBATCH --mem=128000
#SBATCH --output=6_dada2-%J.out
#SBATCH --error=6_dada2-%J.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH -p scavenger 

# USAGE: sbatch --mail-user=youremail@duke.edu 5_dada2.sh /path/to/XXXXXXXX_results /path/to/silva-database-dir /path/to/metabarcoding.sif 

singularity exec --bind $1,$PWD,$2 $3 Rscript 5_dada2.R $1 $2 
