#!/bin/bash
#SBATCH -J bcl2fastq
#SBATCH --partition scavenger
#SBATCH --mem=64000
#SBATCH --output=bcl2fastq.out
#SBATCH --error=bcl2fastq.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END

# USAGE: sbatch bcl2fastq.sh --mail-user=<youremail>@duke.edu /path/to/miniseqDir /path/to/metabarcoding.sif SampleSheet.csv
cd $1
mkdir 0_data_raw

singularity exec --bind $1 $2 bcl2fastq -R . -o ./0_data_raw --create-fastq-for-index-reads --sample-sheet $3
