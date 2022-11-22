#!/bin/bash
#SBATCH -J 3_remove_primers
#SBATCH --partition scavenger
#SBATCH --mem=16000
#SBATCH --output=3_remove_primers.out
#SBATCH --error=3_remove_primers.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END

# Removing primers see evernote note "Removing Primers from Illumina Data (Paired-End Fastq)
# Using trimmomatic 
# This step is recommended by dada2 in their FAQ on chimera checking
# -trimlog trimLog.log 

# USAGE: sbatch --mail-user=youremail@duke.edu 2_remove_primers.sh /path/to/XXXXXXXX_results /path/to/techseqs.fa /path/to/16s-analysis.sif 
codedir=$PWD
PATH1=$1
cd $PATH1
mkdir 2_remove_primers

# loop through fastq files
for file in $PATH1/1_demultiplex/demuxd_reads/*_L001_R1_001.fastq.gz
do
f2=${file%_L001_R1_001.fastq.gz}"_L001_R2_001.fastq.gz"  
y=${file%_L001_R1_001.fastq.gz}
sampleName=${y##*/}
singularity exec --bind $PATH1,$2 $3 trimmomatic PE -phred64  \
$file \
$f2 \
./2_remove_primers/${sampleName}".R1.paired.fastq.gz" \
./2_remove_primers/${sampleName}".R1.unpaired.fastq.gz" \
./2_remove_primers/${sampleName}".R2.paired.fastq.gz" \
./2_remove_primers/${sampleName}".R2.unpaired.fastq.gz" \
ILLUMINACLIP:$2:2:30:10 
done
# move .err and .out files
mv $codedir/3_remove_primers.out ./Reports
mv $codedir/3_remove_primers.err ./Reports
