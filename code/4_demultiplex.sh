#!/bin/bash
#SBATCH -J demultiplex
#SBATCH --mem=64000
#SBATCH --partition scavenger
#SBATCH --output=demultiplex.out
#SBATCH --error=demultiplex.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END

# USAGE: sbatch --mail-user=youremail@duke.edu 4_demultiplex.sh /path/to/XXXXXXXX_results /path/to/16S-analysis.sif
cd $1
mkdir 3_demultiplex
mkdir 3_demultiplex/demuxd_reads

INPUT=2_sync_barcodes/run1
OUTPUT=3_demultiplex
OUTPUT2=3_demultiplex/demuxd_reads
MAP1=0_mapping/barcodes.tsv

# Qiime module failing due to missing R/3.1.0-fasrc01 dependency. Adjusting with qiime2
# Pulling from qiime2/core docker image

# Load qiime2

# Convert our three files (index, read1, read2) into an EMPPairedEndSequences object
singularity exec --bind $1 $3 qiime tools import \
   --type EMPPairedEndSequences \
   --input-path $INPUT \
   --output-path $OUTPUT/emp-paired-end-sequences.qza

# Demultiplex sequence reads
singularity exec --bind $1 $3 qiime demux emp-paired \
  --m-barcodes-file $MAP1 \
  --m-barcodes-column barcode-sequence \
  --p-rev-comp-mapping-barcodes \
  --i-seqs $OUTPUT/emp-paired-end-sequences.qza \
  --o-per-sample-sequences $OUTPUT/demux-full.qza \
  --o-error-correction-details $OUTPUT/demux-details.qza

# Convert .qza to .fastq
singularity exec --bind $1 $3 qiime tools export \
  --input-path $OUTPUT/demux-full.qza \
  --output-path $OUTPUT2
