
importData <- function(path){
  
  
  data = list(nodes = data.frame(), edges = data.table())
  
  #######DATA IMPORT
  
  #Read in records for key papers
  
  keyfiles <- list.files(path=paste(path,'Key/',sep=''),pattern="*.bib", full.names=T, recursive=FALSE)
  for(keyfile in keyfiles){addAllData(keyfile,data) -> data} #Extract doi and references of key papers 
  
  #Save key papers in list
  keypapers = data$nodes$DOI[!is.na(data$nodes$fullcite)] #Full records will only be there for the key papers.
  
  #Read in records of papers that cite key papers
  
  files <- list.files(path=path, pattern="*.bib", full.names=T, recursive=FALSE) 
  for(file in files){addAllData(file,data) -> data} #Extract doi and references of all papers citing each root paper. 
  
  #First Author
  data$nodes$firstAuthor = sapply(X = data$nodes$Author,function(x){y = gsub(',','',strsplit(x,' ')[[1]][1])})
  
  data$nodes$key = data$nodes$DOI %in% keypapers
  
  data = annotateEdges(data,keypapers) #Annotate edge types
  
}


