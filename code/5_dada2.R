# Applying dada2 pipeline to bioreactor time-series
## Following tutorial http://benjjneb.github.io/dada2_pipeline_MV/tutorial.html
## and here http://benjjneb.github.io/dada2_pipeline_MV/tutorial.html
args <- commandArgs(trailingOnly=TRUE)
parent<-args[1]
print(paste("parent directory set to",parent))
setwd(parent)
outputDir<-"4_dada2"
dir.create(file.path(parent,outputDir)) #make folder for dada2 output files

library(dada2); packageVersion("dada2")
library(ggplot2); packageVersion("ggplot2")
library(phyloseq); packageVersion("phyloseq")
library(ShortRead); packageVersion("ShortRead")
set.seed(4)

filtpath <- file.path(parent, "3_filter")

# Find filenames ----------------------------------------------------------

# Forward and reverse filenames
filts.s1 <- list.files(file.path(filtpath), full.names=TRUE)
paste("found", length(filts.s1), "files:", head(filts.s1))
# Sort to ensure fileneames are in the same order
filts.s1 <- sort(filts.s1)
print(paste("Found", length(filts.s1), "files"))
sample.names.1 <- sapply(strsplit(basename(filts.s1),"\\."), `[`, 1)
names(filts.s1) <- sample.names.1
print(paste("sample names set to:", head(sample.names.1)))

# Separate forward and reverse samples
filtFs.s1 <- filts.s1[grepl("_F_filt",filts.s1)]
filtRs.s1 <- filts.s1[grepl("_R_filt",filts.s1)]
print(paste("Found", length(filtFs.s1), "forward read files"))
print(paste("Found", length(filtRs.s1), "reverse read files"))
sample.names.1 <- sapply(strsplit(basename(filtFs.s1), "\\."), `[`, 1)
print(paste("sample names set to:", head(sample.names.1)))
# Dereplication -----------------------------------------------------------

# Learn Error Rates
## aim to learn from about 1M total reads - so just need subset of samples 
## source: http://benjjneb.github.io/dada2_pipeline_MV/bigdata.html
### calculate how many files needed to get to ~1 million reads
fq<-countFastq(file.path(filtpath),pattern="F") # calculate reads/sample
avgReads=mean(fq$records)
n=1000000/avgReads # number of samples needed to get to 1 million reads
if (n > length(sample.names.1)) {
    print('not enough reads to learn error rates. Target: 1 million total reads.')
    print(paste('Using all reads available:',sum(fq$records)))
    n=length(sample.names.1) # use all samples
}
filts.learn.s1 <- sample(sample.names.1, ceiling(n)) # round up to nearest whole number of samples

derepFs.s1.learn <- derepFastq(filtFs.s1[filts.learn.s1], verbose=TRUE)
derepRs.s1.learn <- derepFastq(filtRs.s1[filts.learn.s1], verbose=TRUE)

# Sample Inference --------------------------------------------------------

dadaFs.s1.learn <- dada(derepFs.s1.learn, err=NULL, selfConsist=TRUE, multithread=8)
dadaRs.s1.learn <- dada(derepRs.s1.learn, err=NULL, selfConsist=TRUE, multithread=8)
rm(derepFs.s1.learn, derepRs.s1.learn)

# Just keep the error profiles
errFs.s1 <- dadaFs.s1.learn[[1]]$err_out
errRs.s1 <- dadaRs.s1.learn[[1]]$err_out
rm(dadaFs.s1.learn, dadaRs.s1.learn)

# Now sample inference for entire dataset
# Run 1
derepFs.s1 <- vector("list", length(sample.names.1))
derepRs.s1 <- vector("list", length(sample.names.1))
dadaFs.s1 <- vector("list", length(sample.names.1))
dadaRs.s1 <- vector("list", length(sample.names.1))
names(dadaFs.s1) <- sample.names.1
names(dadaRs.s1) <- sample.names.1
names(derepFs.s1) <- sample.names.1
names(derepRs.s1) <- sample.names.1
for (sam in sample.names.1){
    cat("Processing:", sam, "\n")
    derepFs.s1[[sam]] <- derepFastq(filtFs.s1[[sam]])
    derepRs.s1[[sam]] <- derepFastq(filtRs.s1[[sam]])
    dadaFs.s1[[sam]] <- dada(derepFs.s1[[sam]], err=errFs.s1, multithread=8)
    dadaRs.s1[[sam]] <- dada(derepRs.s1[[sam]], err=errRs.s1, multithread=8)
}

# Run 1: Merge Paired Reads
mergers.s1 <- mergePairs(dadaFs.s1, derepFs.s1, dadaRs.s1, derepRs.s1, verbose=TRUE)
head(mergers.s1)
# Run 1: Clear up space
rm(derepFs.s1, derepRs.s1, dadaFs.s1, dadaRs.s1)


# Construct Sequence Table ------------------------------------------------

#To use only the forward reads
#follow https://github.com/benjjneb/dada2/issues/134

seqtab.s1 <- makeSequenceTable(mergers.s1)
saveRDS(seqtab.s1, file.path(parent,
                 outputDir,
                 "seqtab.s1.rds"))
dim(seqtab.s1)
# Inspect the distributioh of sequence lengths
table(nchar(colnames(seqtab.s1)))
#Trim sequences of interest
seqtab.s1 <- seqtab.s1[,nchar(colnames(seqtab.s1)) %in% seq(250,256)]
# Inspect the distributioh of sequence lengths
table(nchar(colnames(seqtab.s1)))

# Remove Chimeras ---------------------------------------------------------

seqtab.s1.nochim <- removeBimeraDenovo(seqtab.s1, method='consensus', multithread=TRUE, verbose=TRUE)
dim(seqtab.s1.nochim)
sum(seqtab.s1.nochim)/sum(seqtab.s1)
saveRDS(seqtab.s1, file.path(parent,
                 outputDir,
                 "seqtab.s1.nochim.rds"))


# Merge Sequence Tables Together ------------------------------------------

seqtab.nochim <- seqtab.s1.nochim
saveRDS(seqtab.nochim, file.path(parent,
                 outputDir,
                 "seqtab.nochim.rds"))


# Simplify naming ---------------------------------------------------------

seqtab <- seqtab.nochim

# Assign Taxonomy ---------------------------------------------------------
# Following: http://benjjneb.github.io/dada2_pipeline_MV/species.html
silva<-args[2]
# Assign using Naive Bayes RDP
taxtab <- assignTaxonomy(colnames(seqtab), file.path(silva,'silva_nr99_v138.1_train_set.fa.gz'), multithread=TRUE)

# improve with exact genus-species matches 
# this step is pretty slow, should improve in later releases
# - note: Not allowing multiple species matches in default setting
taxtab <- addSpecies(taxtab, file.path(silva,'silva_species_assignment_v138.1.fa.gz'), verbose=TRUE)

# How many sequences are classified at different levels? (percent)
colSums(!is.na(taxtab))/nrow(taxtab)


# Make phyloseq object ----------------------------------------------------

# Write the taxtable, seqtable, to ascii ------------------------
setwd(file.path(parent,outputDir))
write.table(seqtab, file='seqtab.nochim.tsv', quote=FALSE, sep='\t')
write.table(taxtab, file='taxtab.nochim.tsv', quote=FALSE, sep='\t')

# Combine into phyloseq object
ps <- phyloseq(otu_table(seqtab, taxa_are_rows = FALSE),
               tax_table(taxtab))
setwd(file.path(parent,outputDir))
saveRDS(ps, paste0(Sys.Date(),'_phyloseq.rds')) # will save phyloseq object with name YYYYMMDD_phyloseq.rds
