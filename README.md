# 16S-pipeline
LAD lab container based 16S analysis pipeline

## Setup

### Upload sequence data to DCC
```
#"IlluminaRunFolder will look something like "211019_MN00462_0194_A000H3L2M7"
scp -r /path/to/your/<IlluminaRunFolder> <your-netid>@dcc-login.oit.duke.edu:/path/to/DCC/folder
```

### Download metabarcoding container
```
#navigate to whatever directory you want to store the container in
curl -O https://research-singularity-registry.oit.duke.edu/lad-lab/metabarcoding.sif
```
