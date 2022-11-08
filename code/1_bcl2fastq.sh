#!/bin/bash
#SBATCH -J bcl2fastq
#SBATCH --partition scavenger
#SBATCH --mem=64000
#SBATCH --output=1_bcl2fastq.out
#SBATCH --error=1_bcl2fastq.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END

# USAGE: sbatch 1_bcl2fastq.sh /path/to/miniseqDir /path/to/metabarcoding.sif SampleSheet.csv
codedir=$PWD
cd $1
cd ..
parent=$PWD
now=$(date +'%Y%m%d')
outdir=$now'_results'
mkdir $outdir
mkdir $outdir/0_data_raw
mkdir $outdir/Reports

singularity exec --bind $parent $2 bcl2fastq -R $1 -o $outdir/0_data_raw --create-fastq-for-index-reads --sample-sheet $3

# move .err and .out files
mv $codedir/1_bcl2fastq.out $outdir/Reports
mv $codedir/1_bcl2fastq.err $outdir/Reports

