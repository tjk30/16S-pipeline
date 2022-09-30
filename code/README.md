
# Setup

## Upload sample sheet
See files for example. Used by bcl2fastq script. 
```
scp /path/to/SampleSheet.csv netid@dcc-login.oit.duke.edu:/path/to/dest
```
## Create mapping file
If you haven’t made one already - can grab golay barcode, linker and primer name from: Primer Plate Tracking Sheets UPDATED (hkd2@duke.edu) on box
Under the ‘Reverse Primer Constructs’ tab; Use the filter to select the plate and column of interest
Mapping file :: Primer Plate Tracking Sheet
Barcode Seqeunce :: Golay Barcode
LinkerPrimerSequence :: RC of Illumina 3’ Adapter
Primer ID :: Name
Save as a tab delimited text file and upload to server (see fileTemplates folder here on Github for examples)

## File structure
```
/path/to/seqdata
  180425_MN00462_0058_A000H2GY73_MV
  SampleSheet.csv
```
## Step 1: bcl2fastq
```{bash}
sbatch --mail-user=<youremail>@duke.edu 1_bcl2fastq.sh /path/to/miniseqDir /path/to/metabarcoding.sif SampleSheet.csv
```
for example
```
sbatch --mail-user tjk30@duke.edu 1_bcl2fastq.sh /hpc/group/ldavidlab/users/tjk30/2022-08-30_16S-SAGE/220830_MN00462_0233_A000H52VNN /hpc/group/ldavidlab/users/tjk30/mb-pipeline/metabarcoding.sif SampleSheet.csv
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

Before proceeding, make sure to upload your mapping.txt and barcodes.tsv files:
```
scp /path/to/barcodes.tsv netid@dcc-login.oit.duke.edu:/path/to/dest
scp /path/to/mapping.txt netid@dcc-login.oit.duke.edu:/path/to/dest
```
### Step 2: Remove primers
```{bash}
sbatch --mail-user=youremail@duke.edu 2_remove_primers.sh /path/to/0_data_raw /path/to/16s-analysis.sif /path/to/techseqs.fa
```

### Step 3: Sync barcodes

```
sbatch --mail-user=your-email@duke.edu 3_sync_barcodes.sh /path/to/runfolder/XXXXXXXX_results /path/to/16s-analysis.sif
```

### Step 4: Demultiplex
Note: make sure you've uploaded the correct barcodes to the barcodes.tsv file. 
Time estimate: ~40min for a mid kit
```
sbatch --mail-user=your-email@duke.edu 4_demultiplex.sh /path/to/runfolder/XXXXXXXX_results /path/to/barcodes.tsv /path/to/16s-analysis.sif
```

### Step 5: Filter
Time estimate: ~35 min for a high kit.
```
sbatch --mail-user=your-email@duke.edu 5_filtering.sh /path/to/runfolder/XXXXXXXX_results /path/to/16s-analysis.sif
```

### Step 6: Run dada2
This step merges paired reads, constructs a sequence table, and assigns taxonomy using the silva database, which lives in 0_training. The output is a phyloseq object, as well as the sequence table and taxonomy table. Time estimate: ~1 hr for a high kit. NOTE that this uses the metabarcoding container, as this step requires phyloseq, which cannot be installed in the 16s-analysis container (incompatible).

```
sbatch --mail-user=your-email@duke.edu 6_dada2.sh /path/to/runfolder/XXXXXXXX_results /path/to/mapping.txt /path/to/silva-database-dir /path/to/metabarcoding.sif
```


