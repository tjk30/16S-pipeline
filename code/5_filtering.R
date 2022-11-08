# Applying dada2 pipeline to bioreactor time-series
## Following tutorial http://benjjneb.github.io/dada2_pipeline_MV/tutorial.html
## and here http://benjjneb.github.io/dada2_pipeline_MV/bigdata.html
args <- commandArgs(trailingOnly=TRUE)
print(paste("Arguments:",args))
dir <- args[1]
setwd(dir)

library(dada2); packageVersion("dada2")
library(ShortRead); packageVersion("ShortRead")
library(ggplot2); packageVersion("ggplot2")

path <- dir

# Filtering and Trimming --------------------------------------------------
#note s1 - is run number
#note r1 - is forward, r2 - is reverse
# Forward and Reverse Filenames
setwd(file.path(path,"3_demultiplex","demuxd_reads"))
files <- list.files()
fnFs.s1 <- files[grepl("_R1_", files)]
fnRs.s1 <- files[grepl("_R2_", files)]

# Sort to ensure filenames are in the same order
fnFs.s1 <- sort(fnFs.s1)
fnRs.s1 <- sort(fnRs.s1)

sample.names.1 <- sapply(strsplit(fnFs.s1,".fastq", fixed=TRUE), `[`, 1)

# Fully Specify the path for the fnFs and fnRs
fnFs.s1 <- file.path(path, '3_demultiplex/demuxd_reads/', fnFs.s1)
fnRs.s1 <- file.path(path, '3_demultiplex/demuxd_reads/', fnRs.s1)

# Examine qulaity profiles of the forward and reverse reads
p <- plotQualityProfile(fnFs.s1[[1]]) 
ggsave('Forward_quality_profile_s1.png', plot=p)
p <- plotQualityProfile(fnRs.s1[[1]]) 
ggsave('Reverse_quality_profile_s1.png', plot=p)

# Perform filtering and trimming
filtpath <- file.path(path, "4_filter")
dir.create(filtpath)

#update trimLeft based on plot output
# For the first sequencing run
filtFs.s1 <- file.path(filtpath, paste0(sample.names.1,"_F_filt.fastq.gz"))
filtRs.s1 <- file.path(filtpath, paste0(sample.names.1,"_R_filt.fastq.gz"))
for (i in seq_along(fnFs.s1)){
    fastqPairedFilter(c(fnFs.s1[i], fnRs.s1[i]), c(filtFs.s1[i], filtRs.s1[i]),
              #        trimLeft=c(10,0), truncLen=c(150, 150), # Reads look really good quality don't filter here
                      maxN=0, maxEE=2, truncQ=2,
                      compress=TRUE, verbose=TRUE,
                      rm.phix=TRUE)
}
