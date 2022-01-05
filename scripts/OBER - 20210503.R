#loading packages
library(phyloseq)
library(microbiome)
library(tidyverse)
install.packages("devtools")
library(devtools)
library(qiime2R)
BiocManager::install("here") #already installed, no longer needed
library(here)
devtools::install_github("adw96/breakaway") #only for species richness
library(breakaway)
devtools::install_github("adw96/DivNet") #for other alpha diversity matrices, e.g. Shannon, Simpson, Bray Curtis etc.
library(DivNet)
library(magrittr)
install.packages("openxlsx")
library(openxlsx)

#using phyloseq and qiime2R library
#import qiime2 data
#importing feature table to phyloseq, important to have a separate otu_data for breakaway
feature_table<-read_qza("OBER_Q12946_16S_515F926R_20201113_table.qza")
names(feature_table)
feature_table$data
feature_table$data[1:3, 1:37]
ncol(feature_table$data)
colnames(feature_table$data)

#importing observed_otu data
#idk if this is necessary in my case
otu_data<-read_qza("observed_otus_vector.qza")
names(otu_data)
otu_data$data
ncol(otu_data$data)
colnames(otu_data$data)
#the problem with this is that I don't have the no.of reads for individual otus
#I only have the sum of reads for all otus in each sample

#reading metadata, important to have a separate metadata for breakaway
metadata<-read.table("OBER_Q12946_16S_515F926R_20201113@metadata_complete.txt", header = TRUE, sep = "", row.names = 1) #header = TRUE --> the header is not data but the name of the column
names(metadata)
head(metadata)
rownames(metadata)

#reading taxonomy
taxonomy<-read_qza("OBER_Q12946_16S_515F926R_20201113_taxonomy_NB_classifier_SILVA_132_99_16S_515F-926R_QIIME2-2019.10.qza")
head(taxonomy$data)

#checking that column names otu_data = rownames of covariate infos
head(colnames(feature_table$data) == rownames(metadata$V1)) #this is not working as expected
#rownames of the metadata$v1 is NULL idk why -_-
# but when I check the metadata table, the V1 contain OBER.01 until OBER.23
# so I decided to just continue working with the data following the vignettes for breakway
# after this, go directly to the part using breakaway

#creating phyloseq objects with pieter
bac.obj <- qza_to_phyloseq(features = "OBER_Q12946_16S_515F926R_20201113_table.qza",
                           tree = "OBER_Q12946_16S_515F926R_20201113_rooted-tree.qza",
                           metadata = "OBER_Q12946_16S_515F926R_20201113@metadata_complete.txt")

#creating phyloseq objects myself
#I included the taxonomy in the phyloseq object
physeq<-qza_to_phyloseq(features = "OBER_Q12946_16S_515F926R_20201113_table.qza",
                        tree = "OBER_Q12946_16S_515F926R_20201113_rooted-tree.qza",
                        taxonomy = "OBER_Q12946_16S_515F926R_20201113_taxonomy_NB_classifier_SILVA_132_99_16S_515F-926R_QIIME2-2019.10.qza",
                        metadata = "OBER_Q12946_16S_515F926R_20201113@metadata_complete.txt")
physeq
physeq@otu_table
colnames(physeq@otu_table)
head(colnames(physeq@otu_table) == rownames(metadata))
ncol(physeq@tax_table)
physeq@tax_table[1:3,1:7]

#correcting the taxonomy name
tax <- read_tsv("OBER_Q12946_16S_515F926R_20201113_taxonomy_corrected.txt") #read_tsv will recognize .txt file
head(tax)
taxtab <- tax_table(as.matrix(tax[,2:ncol(tax)]))
taxtab
nrow(tax) #checking the number of columns in the tax file
ntaxa(taxtab)
length(tax$'Feature ID') #number of rows in tax, ntaxa, and length of Feature ID should be the same, otherwise there are some lost data
taxa_names(taxtab) <- tax$'Feature ID'


#merging the phyloseq data made with pieter with the correct taxonomy
bac.obj2 <- merge_phyloseq(bac.obj, taxtab) #make bac.obj2,3,4, etc so we don't overwrite the previous bac.obj files
bac.obj2
head(bac.obj2@tax_table)

#merging the phyloseq I made myself with the correct taxonomy
physeq2<- merge_phyloseq(physeq, taxtab) #make new physeq2 so the physeq file is not overwritten
physeq2
head(physeq2@tax_table) #lol, no, the header is still incorrect and Idk why it is incorrect
physeq2@otu_table


#using breakaway
#need to load otu table and metadata
#otu table is in bac.obj2 or in physeq2
#I'll use the one bac.obj2 this time since the physeq2 is a mess LOL
#turns out the physeq already has the taxonomic almost correctly, so it is unnecessary to make physeq2 LOL
#I only need to correct the kingdom to domain :D
#anyway, I will still use the bac.obj2

data(bac.obj2@otu_table)
data(metadata)

#DivNet test
#I will get the diversity info for the sample
divnet_Class <-  divnet(tax_glom(physeq, taxrank="Class"),  #agglomerate the same taxonomic rank, in this case is class level
                        X = "Protocol",
                        ncores = 2) #the number of cores used to run 
divnet_Class
divnet_Class$shannon
divnet_stats <- testDiversity(divnet_Class)
plot(divnet_Class)

sample_data(physeq)$dummy <- factor(paste0(sample_data(physeq)$Protocol, "_", sample_data(physeq)$Filter_type))
divnet_Class2 <-  divnet(tax_glom(physeq, taxrank="Class"),  #agglomerate the same taxonomic rank, in this case is class level
                        X = "dummy",
                        ncores = 2) #the number of cores used to run 
divnet_Class2
divnet_Class2$shannon
divnet_stats <- testDiversity(divnet_Class)
plot(divnet_Class2)
estimates <- divnet_Class2$shannon %>% summary %$% estimate
ses<- sqrt(divnet_Class2$`shannon-variance`)
X<-breakaway::make_design_matrix(physeq, "dummy")
betta(estimates, ses, X)$table

#continuation alpha-diversity
otu_table <- physeq@otu_table
meta_data <- metadata
freqtablist <- build_frequency_count_tables(otu_table)
freqtablist
br.1 = breakaway(freqtablist[[1]]) #I don't have a cutoff here, why?
br.2 = breakaway(freqtablist[[2]])
br.3 = breakaway(freqtablist[[3]])
br.11 = breakaway(freqtablist[[11]]) # I only got a cutoff of 82 here, why?
br.21 = breakaway(freqtablist[[21]])
br.31 = breakaway(freqtablist[[31]])

#how to interpret the numbers?
#what does confidence interval mean? 
#do I need to check for all 34 samples

br.1
br.1$model
br.1a = breakaway(freqtablist[[1]], cutoff = 40)
br.1a #this one gives more standard error, why?
br.1a$model
plot(br.1a)
#plotting breakaway
plot(br.1) #Kemp models, the closer the observed values to the fitted 
plot(br.11) #only use X0 to X82 to fit the model. everything above that cutoff is way off

#hypothesis testing with breakaway
physeq
view(meta_data)
physeq  %>% sample_data %>% head(18)
colnames(meta_data)

#so from here, I can take a subset of the samples and compare them based on what I want to test
# only CTAB method
subset_physeq1 <- physeq %>%
  subset_samples(Protocol == "CTAB_method") # only Protocol

richness_physeq1 <- subset_physeq1 %>% breakaway
richness_physeq1
plot(richness_physeq1, physeq= subset_physeq1, color="Filter_type", shape = "Sample_type")

#only Fast_DNA
subset_physeq2 <- physeq %>%
  subset_samples(Protocol == "Fast_DNA")

richness_physeq2 <- subset_physeq2 %>% breakaway
richness_physeq2
plot(richness_physeq2, physeq= subset_physeq2, color="Filter_type", shape = "Sample_type")

#only water sample
subset_physeq3 <- physeq %>%
  subset_samples(Sample_type == "Water") # only water
  
richness_physeq3 <- subset_physeq3 %>% breakaway
richness_physeq3
plot(richness_physeq3, physeq= subset_physeq3, color="Filter_type", shape = "Protocol")
#why the blank is included here

# only granule sample
subset_physeq4 <- physeq %>%
  subset_samples(Sample_type == "Granules") # only granule sample

richness_physeq4 <- subset_physeq4 %>% breakaway
richness_physeq4
plot(richness_physeq4, physeq= subset_physeq4, color="Filter_type", shape = "Protocol")
#the blank is not included in this plot

# only BAC1
subset_physeq5 <- physeq %>%
  subset_samples(Filter_type == "BAC1")%% # only BAC 1

richness_physeq5 <- subset_physeq5 %>% breakaway
richness_physeq5
plot(richness_physeq5, physeq= subset_physeq5, color="Sample_type", shape = "Protocol")

# only BAC2
subset_physeq6 <- physeq %>%
  subset_samples(Filter_type == "BAC2") # only BAC 2

richness_physeq6 <- subset_physeq6 %>% breakaway
richness_physeq6
plot(richness_physeq6, physeq= subset_physeq6, color="Sample_type", shape = "Protocol")

#summary table
summary(richness_physeq1) %>% as_tibble
summary(richness_physeq2) %>% as_tibble
summary(richness_physeq3) %>% as_tibble
summary(richness_physeq4) %>% as_tibble
summary(richness_physeq5) %>% as_tibble
summary(richness_physeq6) %>% as_tibble