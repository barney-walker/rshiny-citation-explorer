### Data Analysis

annotateEdges <- function(data,keypapers){
  
  
  data$edges$type = 1
  data$edges$type[data$edges$citer %in% keypapers] = 2
  data$edges$type[data$edges$cited %in% keypapers] = 3
  data$edges$type[(data$edges$citer %in% keypapers)&(data$edges$cited %in% keypapers)] = 4
  
  
  data$nodes$citecount = unname(table(data$edges$cited)[data$nodes$DOI])
  data$nodes$citecount[is.na(data$nodes$citecount)] = 0 
  
  data$nodes$cocitecount = unname(table(data$edges$cited[data$edges$type==1])[data$nodes$DOI])
  data$nodes$cocitecount[is.na(data$nodes$cocitecount)] = 0 
  
  data$nodes$citedcount = unname(table(data$edges$cited[data$edges$type==2])[data$nodes$DOI])
  data$nodes$citedcount[is.na(data$nodes$citedcount)] = 0 
  
  data$nodes$citercount = unname(table(data$edges$citer[data$edges$type==3])[data$nodes$DOI])
  data$nodes$citercount[is.na(data$nodes$citercount)] = 0 
  
  return(data)
}
