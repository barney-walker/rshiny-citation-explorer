getFirstAuthor <- function(authorlist){
  
  
  sapply(unname(authorlist),function(x){
    
    y = gsub(',','',strsplit(x,' ')[[1]][1])
    
    s <- strsplit(y, " ")[[1]]
    
    paste(toupper(substring(s, 1, 1)), substring(s, 2),
          sep = "", collapse = " ")
    
    })
  
  
  
  
  
}