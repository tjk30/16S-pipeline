# 16S-pipeline
LAD lab container based 16S analysis pipeline

## Setup

### clone this repo

```
ssh <netid>@dcc-login.oit.duke.edu
<enter password>
cd /where/you/want/files
git clone git@github.com:tjk30/16S-pipeline.git
```

### Upload sequence data to DCC
```
#"IlluminaRunFolder will look something like "211019_MN00462_0194_A000H3L2M7"
scp -r /path/to/your/<IlluminaRunFolder> <your-netid>@dcc-login.oit.duke.edu:/path/to/DCC/folder
```
### Upload barcode file
See /code folder for template file. This file supplies the barcodes for demultiplexing (barcodes.tsv).
```
scp /path/to/barcodes.tsv <netid>@dcc-login.oit.duke.edu:/path/to/DCC/folder
```

### Upload silva database

DADA2 performs taxonomic assignment by using a fasta file. SILVA (https://www.arb-silva.de/) maintains one popular 16S database. The dada2 formatted version can be found here: https://zenodo.org/record/4587955#.Y30XnezMK3I

You are welcome to use the v138.1 database I have already downloaded and stored in /hpc/group/ldavidlab/users/tjk30/16S-pipeline/silva-database.

Otherwise, you can download the files locally, then upload to DCC:
```
scp /path/to/silva_nr99_v138.1_train_set.fa.gz <netid>@dcc-login.oit.duke.edu:/hpc/group/ldavidlab/users/<netid>/
scp /path/to/silva_nr99_v138.1_wSpecies_train_set.fa.gz <netid>@dcc-login.oit.duke.edu:/hpc/group/ldavidlab/users/<netid>/
scp /path/to/silva_species_assignment_v138.1.fa.gz <netid>@dcc-login.oit.duke.edu:/hpc/group/ldavidlab/users/<netid>/
```

### upload techseqs.fa file
Trimmomatic distributes a fasta file with all of the Illumina adapters (techseqs.fa). I have this stored on the DCC in /hpc/group/ldavidlab/users/tjk30/16S-pipeline/. You can also download it from Box: 
```
scp /path/to/project_davidlab/LAD_LAB_Personnel/Zack_H/DavidLab/HARDAC_code_archive/DADA2_pipeline/techseqs.fa <netid>@dcc-login.oit.duke.edu:/path/to/DCC/folder
```
### Download 16S container
```
#navigate to whatever directory you want to store the container in
curl -O https://research-singularity-registry.oit.duke.edu/lad-lab/16s-analysis.sif
```
Step 5 (5_dada2) requires the metabarcoding container:
```
#navigate to whatever directory you want to store the container in
curl -O https://research-singularity-registry.oit.duke.edu/lad-lab/metabarcoding.sif
```
### Write sbatch scripts

Download the "16S-sbatch-writer.Rmd' R notebook and fill in your run information. Run the code chunks as directed to get the correct submission scripts for each step. You can then copy/paste the submission script into the terminal. NOTE: you must be inside the DCC directory containing all of the .sh scripts before submitting them. 

For example: 
```
cd /path/to/code
ls
  1_bcl2fastq.sh
  2_demultiplex.sh
  3_remove_primers.sh
  4_filtering.sh
  4_filtering.R
  5_dada2.sh
  5_dada2.R
sbatch <your script here>
```
