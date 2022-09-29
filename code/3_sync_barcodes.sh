#!/bin/bash
#SBATCH -J 3_sync_barcodes
#SBATCH --partition scavenger
#SBATCH --mem=16000
#SBATCH --output=3_sync_barcodes-%J.out
#SBATCH --error=3_sync_barcodes-%J.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH -p scavenger 

# USAGE: sbatch --mail-user=<youremail>@duke.edu 3_sync_barcodes.sh /path/to/XXXXXXXX_results /path/to/16s-analysis.sif

PATH1=$1
cd $PATH1
mkdir 2_sync_barcodes
mkdir 2_sync_barcodes/for-qiime2

BARCODE1=$PATH1/0_data_raw/Undetermined_S0_L001_I1_001.fastq.gz

singularity exec --bind $1 $2 repair.sh in1=$BARCODE1 \
in2=$PATH1/1_remove_primers/R1.paired.fastq.gz \
out1=$PATH1/2_sync_barcodes/I1.synced.fastq.gz \
out2=$PATH1/2_sync_barcodes/R1.paired.fastq.gz \
outs=$PATH1/2_sync_barcodes/singletons.fq repair

singularity exec --bind $1 $2 repair.sh in1=$BARCODE1 \
in2=$PATH1/1_remove_primers/R2.paired.fastq.gz \
out1=$PATH1/2_sync_barcodes/I1.synced.R2.fastq.gz \
out2=$PATH1/2_sync_barcodes/R2.paired.fastq.gz \
outs=$PATH1/2_sync_barcodes/singletons.R2.fq repair

# Rename output files to be accepted by qiime2 demultiplex step
mv $PATH1/2_repair/R1.paired.fastq.gz $PATH1/2_sync_barcodes/for-qiime2/forward.fastq.gz
mv $PATH1/2_repair/R2.paired.fastq.gz $PATH1/2_sync_barcodes/for-qiime2/reverse.fastq.gz
mv $PATH1/2_repair/I1.synced.fastq.gz $PATH1/2_sync_barcodes/for-qiime2/barcodes.fastq.gz
