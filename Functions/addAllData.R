addAllData <- function (file,data)
  
{
  
nodes = data$nodes
edges = data$edges
  
#Read in bibtex line by line
  
full_text = readLines(file)

#Find line numbers where new article starts

article_start = which(regexpr("@",full_text)==1)
article_end = which(full_text == '}')

#For each paper extract biblio info and list of cited DOIs

for(i in 1:length(article_start))
  
{
  article = full_text[article_start[i]:article_end[i]]
  
  bib = extractAllInfo(article)
  
  existingEntry = which(nodes$DOI==bib$DOI)
  
  if(length(existingEntry)==1){
    
    if(!is.na(nodes$fullcite[existingEntry])) next else
    
      nodes = nodes[-existingEntry,]
  } 
  
  nodes = data.table::rbindlist(list(nodes,bib),fill=T)

  refs = unlist(bib$refs) #Extract references from full record
    
  oldrefs = refs[which((refs %in% nodes$DOI))] # References already in the database 
  
  for (ref in oldrefs){
    
    nodes$shortcite[which(nodes$doi==ref)] = names(oldrefs)[which(oldrefs==ref)] #Add shortcite to existing 
  
  }
  
  newrefs = refs[which(!(refs %in% nodes$DOI))] # References not yet in database
  
  if(length(newrefs)==0) next
  
  
  test2 = strsplit(trimws(names(newrefs)),', ')
  
  newdata = lapply(X = names(newrefs),function(x){
    
    y = strsplit(trimws(x),', ')[[1]]
    
    return(as.list(y[1:3]))
    
    
  })
  
  
  newnodes = data.table::rbindlist(newdata)
  
  newnodes$DOI = unname(newrefs)
  newnodes$shortcite = names(newrefs)

  names(newnodes) = c('Author','Year','Journal','DOI','shortcite')
 
  nodes = data.table::rbindlist(list(nodes,newnodes),fill=T)
  newedges = data.table(cited = unname(refs),citer = bib$DOI) #Create new edges
  
  edges = rbind(edges,newedges) #Add to edge data-base

   
}

data = list(nodes = nodes, edges = edges)

return(data)

}

