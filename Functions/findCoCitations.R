findCoCitations <- function(data){
  
  edges = data.table()
  
  keypapers = data$nodes$DOI[data$nodes$key]
  
  for (doi in keypapers){
    
    citers = data$edges$citer[data$edges$cited==doi]
    
    cocites = data$edges$cited[data$edges$citer %in% citers]
    
    if(length(cocites)==0) next
    
    edges = rbindlist(list(edges,data.table(citer = doi,cited=cocites[-which(cocites%in%keypapers)],type=5)))

  }
  
  #links = data.frame(id = 1:nrow(edges), from = match(edges$citer,data$nodes$DOI), to = match(edges$cited,data$nodes$DOI),type = 5)
  
  return(edges)
  
}