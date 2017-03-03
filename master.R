# Master Code - run this to import citation data from .bib files and fill in missing metadata using CrossRef/PubMed

library(data.table)
library(RefManageR)

#Clear workspace

rm(list=ls())

#Source Functions

functions <- list.files(path="Functions/",pattern="*.R", full.names=T, recursive=FALSE)
lapply(functions,source)

#IMPORT

path = "Papers/" #Path should be a directory containing .bibs of cited-by records for seed papers. Sub-directory called "Key" should contain the records for the seed papers themselves

data = importData(path) #Parse .bib files into data table for nodes and edges.

save(data,file ='data.Rdata')

#FILL

filledData = fillData(data) #Use DOIs extracted from .bib to queury CrossRef and PubMed for additional info i.e. Titles, Abstracts and URLs

save(filledData,file ='filledData.RData')