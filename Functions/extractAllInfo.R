extractAllInfo <- function(article)
  
{
  
  authorStart = 2 #grep("Author = {",article,perl=T)
  authorEnd = grep("},",article,perl=T)[1]
  
  starts = c(authorStart,grep("= {{",article,perl=T))
  ends = c(authorEnd,grep("}},",article,perl=T))
  
  if(length(starts)!=length(ends)) print(article)
  
  bibinfo <- list()
  
  bibinfo$fullcite = paste(article,sep='\n',collapse='')
  bibinfo$citekey = substr(article[1],11,nchar(article[1])-1)
 
  
  for(i in 1:(length(ends))){
    
    property = paste(article[starts[i]:ends[i]],sep='\n',collapse = '')
    
    match = regexpr(' = {',property,perl=T)
    
    name = gsub('-','',substr(property[1],1,match[1]-1),perl=T)
    
    value = as.list(substr(property,match+attr(match,'match.length')[1],nchar(property)-1))
    
    value = gsub('{','',gsub('}','',value,perl=T),perl=T)
    
    bibinfo[[ name ]] <- value
    
  }
  
  if(is.null(bibinfo$DOI)){bibinfo$DOI <- bibinfo$UniqueID}
  
  doilines = grep(", DOI 10.",article)
  
  refs = article[doilines]
  
  refs = gsub('Cited-References = {{','',refs,perl=T)
  refs = gsub('}},','',refs,perl=T)
  
  doistarts = regexpr("DOI 10[.]",refs)
  
  dois = substr(refs,doistarts+4,nchar(refs)-1)
  
  names(dois) = trimws(refs)
  
  bibinfo$refs = list(dois)
  
  
  return(bibinfo)

  
}
  


  
