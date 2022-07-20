
# Setup
## Install qiime2 in your DCC folder
qiime2 overwrites R within the container, making it impossible to access R packages such as dada2, so it has to be installed separately: https://docs.qiime2.org/2022.2/install/native/
```{bash}
cd /hpc/group/ldavidlab/users/<your-netID>
mkdir modules
srun -p scavenger --pty /bin/bash
module load Anaconda3/5.1.0 #or use whatever the latest version of Anaconda is
wget https://data.qiime2.org/distro/core/qiime2-2022.2-py38-linux-conda.yml
conda env create -p /hpc/group/ldavidlab/users/<your-netID>/modules/qiime2-env --file qiime2-2022.2-py38-linux-conda.yml
# OPTIONAL CLEANUP
rm qiime2-2022.2-py38-linux-conda.yml
```

the -p flag needs to be used instead of the -n flag so that it is installed in your directory in the DCC, and not in your /home directory.
```{bash}
conda activate /hpc/group/ldavidlab/users/<your-netID>/modules/qiime2-env
```

## Upload sample sheet

## Create and upload mapping file
If you haven’t made one already - can grab golay barcode, linker and primer name from:
Primer Plate Tracking Sheets UPDATED (hkd2@duke.edu) on box
Under the ‘Reverse Primer Constructs’ tab; Use the filter to select the plate and column of
interest
Mapping file :: Primer Plate Tracking Sheet
Barcode Seqeunce :: Golay Barcode
LinkerPrimerSequence :: RC of Illumina 3’ Adapter
Primer ID :: Name
Save as a tab delimited text file and upload to server

## File structure
```
/path/to/seqdata
  180425_MN00462_0058_A000H2GY73_MV
  SampleSheet.csv
  XXXXXXXX_results
    0_mapping
      MappingFile.txt
```

After running pipeline, file structure should look like this:

```
/path/to/seqdata
  180425_MN00462_0058_A000H2GY73_MV
  SampleSheet.csv
  XXXXXXXX_results
    0_mapping
      MappingFile.txt
      barcodes.tsv
    0_raw_all
      Undetermined_R1.fastq
      Undetermined_R2.fastq
      Undetermined_I1.fastq
    1_remove_primers
      run1
    2_sync_barcodes
      run1
    3_demultiplex
      demuxd_reads
    4_filter
    
```
