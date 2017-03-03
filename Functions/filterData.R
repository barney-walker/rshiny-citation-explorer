filterData <- function(data,types,cols=NULL){
  
  if(is.null(cols)) cols = names(data$nodes)
  
  edges = data$edges[data$edges$type %in% types,]
  
  nodes = subset(data$nodes,subset = data$nodes$DOI %in% c(edges$cited,edges$citer) ,select = cols)
  
  return(list(nodes=nodes,edges=edges))
  
}



filterNodes <- function(data,thresh,types=1:4){
  
  deg = table(data$edges$cited[data$edges$type %in% types])
  
  key = data$nodes$DOI[data$nodes$key]
  
  list1 = c(names(deg[deg>thresh]),key)
  
  nodes = data$nodes[data$nodes$DOI %in% list1]
  
  edges = data$edges[data$edges$cited %in% list1]
  
  return(list(nodes=nodes,edges=edges))
  
}