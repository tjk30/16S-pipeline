#!/bin/bash
#SBATCH -J bcl2fastq
#SBATCH --partition scavenger
#SBATCH --mem=64000
#SBATCH --output=bcl2fastq-%j.out
#SBATCH --error=bcl2fastq-%j.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END

# USAGE: sbatch --mail-user=<youremail>@duke.edu 1_bcl2fastq.sh /path/to/miniseqDir /path/to/metabarcoding.sif SampleSheet.csv
cd $1
cd ..
now=$(date +'%Y%m%d')
outdir=$now'_results'
mkdir $outdir
mkdir $outdir/0_data_raw

singularity exec --bind $PWD $2 bcl2fastq -R $1 -o ./0_data_raw --create-fastq-for-index-reads --sample-sheet $3
