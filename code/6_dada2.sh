#!/bin/bash
#SBATCH -J 6_dada2
#SBATCH --mem=128000
#SBATCH --output=6_dada2.out
#SBATCH --error=6_dada2.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH -p scavenger 

# USAGE: sbatch --mail-user=youremail@duke.edu 6_dada2.sh /path/to/XXXXXXXX_results /path/to/mapping.txt /path/to/silva-database-dir /path/to/16s-analysis.sif 
mkdir $1/5_dada2
singularity exec --bind $1,$wd,$2,$3 $4 Rscript 6_dada2.R $1 $2 $3

# move .err and .out files
mv $PWD/6_dada2.out $1/Reports
mv $PWD/6_dada2.err $1/Reports
