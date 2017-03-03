
#Get Titles/Abstracts from CrossRef/PubMed


fillData <- function(data){
  
  tofill = which(is.na(data$nodes$Title))
  i=0
  for (id in tofill[3254:length(tofill)]){
    i=i+1
    
    possibleError <- tryCatch(
      ReadCrossRef(data$nodes$DOI[id]),
      error=function(e) e
    )
    
    if(inherits(possibleError, "error")) next
    
    ReadCrossRef(data$nodes$DOI[id])-> bib
    
    if(is.null(bib$doi)) {print('Paper Not Found') ;next}
    if(is.null(bib$title)) {print('Title Not Found'); next}
    if(is.null(bib$url)) next
    
    if(tolower(bib$doi) == tolower(data$node$DOI[id])){
      
      #print("Title Found")
      data$nodes$Title[id] = bib$title
      if(!is.null(bib$url)) data$nodes$URL[id] = bib$url
      
    }else{warning('non-matching DOIs')}
    
    ReadPubMed(data$nodes$DOI[id],retmax=1,field='doi')-> bib2
     
    if(is.null(bib2$doi)) next
    
    if(is.null(bib2$abstract)) next
    
    if(tolower(bib2$doi) == tolower(data$node$DOI[id])){
     
      data$nodes$Abstract[id] = bib2$abstract
       print('Abstract Found')
       
     }else{warning('non-matching DOIs')}
     
    print(i)
  }
  
  print(paste("There were",length(tofill),"missing titles"))
  print(paste("Now there are",length(which(is.na(data$nodes$Title))),"missing"))
  
  print(paste("There were",length(tofill),"missing abstracts"))
  print(paste("Now there are",length(which(is.na(data$nodes$Abstract))),"missing"))
  
  return(data)
  
}

