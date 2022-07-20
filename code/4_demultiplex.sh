#!/bin/bash
#SBATCH -J demultiplex
#SBATCH --mem=64000
#SBATCH --partition scavenger
#SBATCH --output=demultiplex.out
#SBATCH --error=demultiplex.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END

# USAGE: sbatch --mail-user=youremail@duke.edu 4_demultiplex.sh /path/to/seqdata /path/to/qiime2-env
cd $1

INPUT=2_sync_barcodes/run1
OUTPUT=3_demultiplex
OUTPUT2=3_demultiplex/demuxd_reads
MAP1=0_mapping/barcodes.tsv

# Qiime module failing due to missing R/3.1.0-fasrc01 dependency. Adjusting with qiime2
# Following https://docs.qiime2.org/2021.8/tutorials/atacama-soils/#atacama-demux

# Load qiime2
module load Anaconda3/5.1.0
conda activate $2

# Convert our three files (index, read1, read2) into an EMPPairedEndSequences object
qiime tools import \
   --type EMPPairedEndSequences \
   --input-path $INPUT \
   --output-path $OUTPUT/emp-paired-end-sequences.qza

# Demultiplex sequence reads
qiime demux emp-paired \
  --m-barcodes-file $MAP1 \
  --m-barcodes-column barcode-sequence \
  --p-rev-comp-mapping-barcodes \
  --i-seqs $OUTPUT/emp-paired-end-sequences.qza \
  --o-per-sample-sequences $OUTPUT/demux-full.qza \
  --o-error-correction-details $OUTPUT/demux-details.qza

# Convert .qza to .fastq
qiime tools export \
  --input-path $OUTPUT/demux-full.qza \
  --output-path $OUTPUT2
