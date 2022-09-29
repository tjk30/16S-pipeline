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


### Upload silva database
I uploaded the files to /hpc/group/ldavidlab/modules/silva-database, but in case you can't access them from there for some reason, you can also upload them to the DCC from Box:

```
scp -r /Users/<netID>/Library/CloudStorage/Box-Box/project_davidlab/LAD_LAB_Personnel/Jeff/HARDAC/16S_pipeline_JL21/0_training <netid>@dcc-login.oit.duke.edu:/path/to/DCC/folder
```

### Download 16S container
```
#navigate to whatever directory you want to store the container in
curl -O https://research-singularity-registry.oit.duke.edu/lad-lab/16s-analysis.sif
```

If you wish to also do the dada2 analysis steps on the computing cluster, you will also need to download the metabarcoding container:
```
#navigate to whatever directory you want to store the container in
curl -O https://research-singularity-registry.oit.duke.edu/lad-lab/metabarcoding.sif
```
### Write sbatch scripts

Download the "16S-sbatch-writer.Rmd' R notebook and fill in your run information. Run the code chunks as directed to get the correct submission scripts for each step. NOTE: you must be inside the directory containing all of the .sh scripts before running them. 

For example: 
```
cd /path/to/code
ls
  1_bcl2fastq.sh
  2_remove_primers.sh
  3_sync_barcodes.sh
  4_demultiplex.sh
  5_filtering.sh
  5_filtering.R
  6_dada2.sh
  6_dada2.R
sbatch <your script here>
```
