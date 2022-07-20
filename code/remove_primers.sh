#!/bin/bash
#SBATCH -J remove_primers
#SBATCH --mem=16000
#SBATCH --output=remove_primers.out
#SBATCH --error=remove_primers.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END

# USAGE: sbatch --mail-user=youremail@duke.edu remove_primers.sh /path/to/0_data_raw /path/to/metabarcoding.sif
PATH1=$1

# Removing primers see evernote note "Removing Primers from Illumina Data (Paired-End Fastq)
# Using trimmomatic 
# This step is recommended by dada2 in their FAQ on chimera checking
# -trimlog trimLog.log 

# For Sequencing Run 1
singularity exec --bind $1 $2 java -jar trimmomatic-0.36.jar PE \
$PATH1/Undetermined_S0_L001_R1_001.fastq.gz \
$PATH1/Undetermined_S0_L001_R2_001.fastq.gz \
./1_remove_primers/run1/R1.paired.fastq.gz \
./1_remove_primers/run1/R1.unpaired.fastq.gz \
./1_remove_primers/run1/R2.paired.fastq.gz \
./1_remove_primers/run1/R2.unpaired.fastq.gz \
ILLUMINACLIP:techseqs.fa:2:30:10 
