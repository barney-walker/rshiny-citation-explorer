visGraphPrep <- function(data){
  
  nodes = data$nodes
  edges = data$edges
  
  fA = paste0(toupper(substr(nodes$firstAuthor, 1, 1)), tolower(substring(nodes$firstAuthor, 2)))
  
  nodes$title <- paste(fA,nodes$Year) # Text on click
  nodes$label <- paste(fA,nodes$Year) # Text on click
  nodes$group[(nodes$key)] <- 'key'
  nodes$group[!(nodes$key)] <- 'notkey'
  
  nodes$id = 1:nrow(nodes)
  
  
  links = data.frame(id = 1:nrow(edges), from = match(edges$citer,nodes$DOI), to = match(edges$cited,nodes$DOI),type = edges$type)
  
  return(list(nodes=nodes,edges=links))
  
}