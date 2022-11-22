#!/bin/bash
#SBATCH -J 2_demultiplex
#SBATCH --mem=64000
#SBATCH --output=2_demultiplex.out
#SBATCH --error=2_demultiplex.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH -p scavenger 

# USAGE: sbatch --mail-user=youremail@duke.edu 4_demultiplex.sh /path/to/XXXXXXXX_results /path/to/barcodes.tsv /path/to/16s-analysis.sif
codedir=$PWD
cd $1
mkdir $1/1_raw_for_qiime
cp $1/0_data_raw/*fastq.gz $1/1_raw_for_qiime #copy over raw fastq files for renaming

mv $1/1_raw_for_qiime/Undetermined_S0_L001_R1_001.fastq.gz $1/1_raw_for_qiime/forward.fastq.gz
mv $1/1_raw_for_qiime/Undetermined_S0_L001_R2_001.fastq.gz $1/1_raw_for_qiime/reverse.fastq.gz
mv $1/1_raw_for_qiime/Undetermined_S0_L001_I1_001.fastq.gz $1/1_raw_for_qiime/barcodes.fastq.gz

INPUT=$1/1_raw_for_qiime
mkdir $1/1_demultiplex
OUTPUT=$1/1_demultiplex
mkdir $1/1_demultiplex/demuxd_reads
OUTPUT2=$1/1_demultiplex/demuxd_reads
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
  
# move output files
rm -r $1/1_raw_for_qiime
mv $codedir/2_demultiplex.out $1/Reports
mv $codedir/2_demultiplex.err $1/Reports
