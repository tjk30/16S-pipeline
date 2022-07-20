
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
```
## Step 1: bcl2fastq
```{bash}
sbatch bcl2fastq.sh --mail-user=<youremail>@duke.edu /path/to/miniseqDir /path/to/metabarcoding.sif SampleSheet.csv
```
After running this, your file structure should look like this:
```
/path/to/seqdata
  180425_MN00462_0058_A000H2GY73_MV
  SampleSheet.csv
  XXXXXXXX_results
    0_data_raw
      Undetermined...R1.fastq
      Undetermined...R2.fastq
      Undetermined...I1.fastq
```

Before proceeding, make sure to make a directory called 0_mapping and upload your mapping.txt and barcodes.tsv file to it:
```
cd /path/to/seqdata/XXXXXXXX_results
mkdir 0_mapping
cp /path/to/mapping.txt 0_mapping
cp path/to/barcodes.tsv 0_mapping
```

Now your file structure should look like this:
```
/path/to/seqdata
  180425_MN00462_0058_A000H2GY73_MV
  SampleSheet.csv
  XXXXXXXX_results
    0_data_raw
      Undetermined...R1.fastq
      Undetermined...R2.fastq
      Undetermined...I1.fastq
    0_mapping
      mapping.txt
      barcodes.tsv
```

### Step 2: Remove primers
```{bash}
sbatch --mail-user=youremail@duke.edu remove_primers.sh /path/to/0_data_raw /path/to/metabarcoding.sif
```

### Step 3: Sync barcodes

```
sbatch --mail-user=<youremail>@duke.edu 3_sync_barcodes.sh /path/to/XXXXXXXX_results 
```

### Step 4: Demultiplex

Note: this requires that you already have qiime2 installed (see: "Setup")
```
sbatch --mail-user=youremail@duke.edu 4_demultiplex.sh /path/to/XXXXXXXX_results /path/to/qiime2-env
```

### Step 5: Filter
Time estimate: ~35 min for a high kit.
```
sbatch --mail-user=youremail@duke.edu 5_filtering.sh /path/to/seqdata/XXXXXXXX_results /path/to/metabarcoding.sif
```

### Step 6: Run dada2
This step merges paired reads, constructs a sequence table, and assigns taxonomy using the silva database, which lives in 0_training. The output is a phyloseq object, as well as the sequence table and taxonomy table. Time estimate: ~1 hr for a high kit.

```
sbatch --mail-user=youremail@duke.edu dada2.sh /path/to/XXXXXXXX_results /path/to/metabarcoding.sif
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
