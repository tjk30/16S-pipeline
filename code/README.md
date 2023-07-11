
# Setup

## Create barcodes file
LAD lab members: If you haven’t made one already - can grab golay barcode from: Primer Plate Tracking Sheets UPDATED (hkd2@duke.edu) on box
Under the ‘Reverse Primer Constructs’ tab; Use the filter to select the plate and column of interest
Mapping file :: Primer Plate Tracking Sheet
Barcode Seqeunce :: Golay Barcode
Save as a tab delimited text file and upload to server (see fileTemplates folder here on Github for how to format for qiime2)

## File structure
```
/path/to/seqdata
  180425_MN00462_0058_A000H2GY73_MV
```
## Step 1: bcl2fastq
Runtime: ~5min
```{bash}
sbatch --mail-user=<youremail>@duke.edu 1_bcl2fastq.sh /path/to/miniseqDir /path/to/16s-analysis.sif 
```
for example
```
sbatch --mail-user tjk30@duke.edu 1_bcl2fastq.sh /hpc/group/ldavidlab/users/tjk30/2022-08-30_16S-SAGE/220830_MN00462_0233_A000H52VNN /hpc/group/ldavidlab/users/tjk30/16S-pipeline/16s-analysis.sif 
```
After running this, your file structure should look like this:
```
/path/to/seqdata
  180425_MN00462_0058_A000H2GY73_MV
  XXXXXXXX_results
    0_data_raw
      Undetermined...R1.fastq
      Undetermined...R2.fastq
      Undetermined...I1.fastq
```

Before proceeding, make sure to upload your barcodes.tsv file:
```
scp /path/to/barcodes.tsv netid@dcc-login.oit.duke.edu:/path/to/dest
```

### Step 2: Demultiplex
Note: make sure you've uploaded the correct barcodes to the barcodes.tsv file. 
Run time: ~40min for a mid kit
```
sbatch --mail-user=your-email@duke.edu 2_demultiplex.sh /path/to/runfolder/XXXXXXXX_results /path/to/barcodes.tsv /path/to/16s-analysis.sif
```

### Step 3: Trim primers

```
sbatch --mail-user=your-email@duke.edu 3_remove_primers.sh /path/to/runfolder/XXXXXXXX_results /path/to/techseqs.fa /path/to/16s-analysis.sif 
```
### Step 4: Filter
Run time: ~35 min for a high kit.
```
sbatch --mail-user=youremail@duke.edu 4_filtering.sh /path/to/XXXXXXXX_results /path/to/16s-analysis.sif
```

### Step 5: Run dada2
This step merges paired reads, constructs a sequence table, and assigns taxonomy using the silva database (currently hard-coded in the script as v138.1, if you use a different version you will need to edit the code). The output is a phyloseq object, as well as the sequence table and taxonomy table. Time estimate: ~1 hr for a high kit. NOTE that this uses the metabarcoding container, as this step requires phyloseq, which cannot be installed in the 16s-analysis container (incompatible).

```
sbatch --mail-user=youremail@duke.edu 5_dada2.sh /path/to/XXXXXXXX_results /path/to/silva-database-dir /path/to/metabarcoding.sif 
```

This will write a year-mm-dd_phyloseq.rds file, which is a phyloseq object with your count data and taxonomic assignment. You can then download this file and add your sample data locally. 
