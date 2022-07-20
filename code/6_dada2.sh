#!/bin/bash
#SBATCH -J dada2
#SBATCH --mem=128000
#SBATCH --output=5_dada2.out
#SBATCH --error=5_dada2.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END

# USAGE: sbatch --mail-user=youremail@duke.edu dada2.sh /path/to/XXXXXXXX_results /path/to/metabarcoding.sif /path/to/silva-database
# silva-database is the same as this folder on Box: /project_davidlab/LAD_LAB_Personnel/Jeff/HARDAC/16S_pipeline_JL21/0_training

now=$(date +'%Y%m%d')
singularity exec --bind $1,$PWD $2 Rscript dada2.R dada2.Rout $1 $3 $now 

