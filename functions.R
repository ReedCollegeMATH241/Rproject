removeURL <- function(text) gsub("(http[[:alnum:][:punct:]]*|www[[:alnum:][:punct:]]*)", "", text)
removeDEL <- function(text) gsub("\\[deleted\\]", "NA.", text)
capNA<-function(text)gsub('^na\\..*?$','NA.',text)
removeLink<-function(x){
  t<-gsub("\\[\\]|\\[(.*?)\\]\\(.*?\\)",'\\1',x)
  gsub("/r/[a-z]*",'',t)
}
removeHyph <-function(text) gsub("([a-zA-Z']+)(-+|/)([a-zA-Z']+)","\\1 \\3",text)
removeCarat<-function(text) gsub("\\^","",text)
removeLong<-function(x)gsub('[[:graph:]]{30,}','',x)%>%capNA
cln_up<-function(x){removeDEL(x)%>%
                      removeLink %>% removeURL%>% removeHyph%>% removeCarat%>%
                      replace_contraction()%>%
                      replace_abbreviation(abbreviation = qdapDictionaries::abbreviations,
                                           replace = NULL, ignore.case = TRUE)}%>%
  stemmer(capitalize=FALSE,warn=FALSE)