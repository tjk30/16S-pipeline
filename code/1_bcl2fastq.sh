#!/bin/bash
#SBATCH -J bcl2fastq
#SBATCH --partition scavenger
#SBATCH --mem=64000
#SBATCH --output=bcl2fastq-%J.out
#SBATCH --error=bcl2fastq-%J.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END

# USAGE: sbatch 1_bcl2fastq.sh /path/to/miniseqDir /path/to/metabarcoding.sif SampleSheet.csv
cd $1
cd ..
parent=$PWD
now=$(date +'%Y%m%d')
outdir=$now'_results'
mkdir $outdir
mkdir $outdir/0_data_raw

singularity exec --bind $parent $2 bcl2fastq -R $1 -o ./0_data_raw --create-fastq-for-index-reads --sample-sheet $3

