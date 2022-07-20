#!/bin/bash
#SBATCH -J sync_barcodes
#SBATCH --partition scavenger
#SBATCH --mem=16000
#SBATCH --output=sync_barcodes.out
#SBATCH --error=sync_barcodes.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END

# USAGE: sbatch --mail-user=<youremail>@duke.edu 3_sync_barcodes.sh /path/to/XXXXXXXX_results 

PATH1=$1
#Since we just filtered the Forward and Reverse reads, this step 
#ensures the index files also drop any reads removed in the prior step. 

BARCODE1=0_data_raw/Undetermined_S0_L001_I1_001.fastq.gz

cp $PATH1/1_remove_primers/run1/R2.paired.fastq.gz $PATH1/2_sync_barcodes/run1/R2.paired.fastq.gz

$PATH1/sync_paired_end_reads.py $BARCODE1 $BARCODE1 \
$PATH1/1_remove_primers/run1/R1.paired.fastq.gz \
$PATH1/2_sync_barcodes/run1/I1.synced.fastq.gz \
$PATH1/2_sync_barcodes/run1/R1.paired.fastq.gz

# Rename output files to be accepted by qiime2 demultiplex step
mv $PATH1/1_remove_primers/run1/R1.paired.fastq.gz $PATH1/1_remove_primers/run1/forward.fastq.gz
mv $PATH1/1_remove_primers/run1/R2.paired.fastq.gz $PATH1/1_remove_primers/run1/reverse.fastq.gz
mv $PATH1/1_remove_primers/run1/I1.synced.fastq.gz $PATH1/1_remove_primers/run1/barcodes.fastq.gz
