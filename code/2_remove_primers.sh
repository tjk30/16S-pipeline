#!/bin/bash
#SBATCH -J 2_remove_primers
#SBATCH --partition scavenger
#SBATCH --mem=16000
#SBATCH --output=2_remove_primers-%J.out
#SBATCH --error=2_remove_primers-%J.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END

# Removing primers see evernote note "Removing Primers from Illumina Data (Paired-End Fastq)
# Using trimmomatic 
# This step is recommended by dada2 in their FAQ on chimera checking
# -trimlog trimLog.log 

# USAGE: sbatch --mail-user=youremail@duke.edu 2_remove_primers.sh /path/to/0_data_raw /path/to/16s-analysis.sif /path/to/techseqs.fa
PATH1=$1
cd $1
cd ..
mkdir 1_remove_primers
mkdir 1_remove_primers/run1

# For Sequencing Run 1
singularity exec --bind $PWD,$3 $2 trimmomatic PE -phred64  \
$PATH1/Undetermined_S0_L001_R1_001.fastq.gz \
$PATH1/Undetermined_S0_L001_R2_001.fastq.gz \
./1_remove_primers/run1/R1.paired.fastq.gz \
./1_remove_primers/run1/R1.unpaired.fastq.gz \
./1_remove_primers/run1/R2.paired.fastq.gz \
./1_remove_primers/run1/R2.unpaired.fastq.gz \
ILLUMINACLIP:$3:2:30:10 
