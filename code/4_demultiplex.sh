#!/bin/bash
#SBATCH -J 4_demultiplex
#SBATCH --mem=64000
#SBATCH --output=4_demultiplex-%J.out
#SBATCH --error=4_demultiplex-%J.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH -p scavenger 

# USAGE: sbatch --mail-user=youremail@duke.edu 4_demultiplex.sh /path/to/XXXXXXXX_results /path/to/barcodes.tsv /path/to/16s-analysis.sif

cd $1

INPUT=$1/2_sync_barcodes/for-qiime2
mkdir $1/3_demultiplex
OUTPUT=$1/3_demultiplex
mkdir $1/3_demultiplex/demuxd_reads
OUTPUT2=$1/3_demultiplex/demuxd_reads
MAP1=$2

# Following https://docs.qiime2.org/2021.8/tutorials/atacama-soils/#atacama-demux

# Load qiime2


# Convert our three files (index, read1, read2) into an EMPPairedEndSequences object
singularity exec --bind $1,$2 $3 qiime tools import \
   --type EMPPairedEndSequences \
   --input-path $INPUT \
   --output-path $OUTPUT/emp-paired-end-sequences.qza

# Demultiplex sequence reads
singularity exec --bind $1,$2 $3 qiime demux emp-paired \
  --m-barcodes-file $MAP1 \
  --m-barcodes-column barcode-sequence \
  --p-rev-comp-mapping-barcodes \
  --i-seqs $OUTPUT/emp-paired-end-sequences.qza \
  --o-per-sample-sequences $OUTPUT/demux-full.qza \
  --o-error-correction-details $OUTPUT/demux-details.qza \
  --p-no-golay-error-correction
# Convert .qza to .fastq
singularity exec --bind $1,$2 $3 qiime tools export \
  --input-path $OUTPUT/demux-full.qza \
  --output-path $OUTPUT2
