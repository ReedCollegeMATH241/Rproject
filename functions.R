library(ggplot2)
library(qdap)
library(dplyr)
library(rJava)
library(magrittr)
library(tm)
library(weatherData)
library(DT)
library(openNLP)
library(sentiment)
removeHyph <-function(text) gsub("([a-zA-Z']+)(-+|/)([a-zA-Z']+)","\\1 \\3",text)
removeURL <- function(text) gsub("http[[:alnum:][:punct:]A-Za-z//]*", "", text)
removeDEL <- function(text) gsub("\\[deleted\\]", "NA.", text)
capNA<-function(text)gsub('^na\\..*?$','NA.',text)
removeLink<-function(x){
  t<-gsub("\\[\\]|\\[(.*?)\\]\\(.*?\\)",'\\1',x)
  gsub("/r/[a-z]*",'',t)
}
removeCarat<-function(text) gsub("\\^","",text)
removeLong<-function(x)gsub('[[:graph:]]{30,}','',x)%>%capNA
removeTags<-function(x)gsub('#\\w*','',x)
cln_up<-function(x){removeDEL(x)%>% PlainTextDocument %>%
                      removeLink %>% removeURL%>% removeHyph%>% removeCarat%>% removeTags %>%
                      replace_contraction()%>%
                      replace_abbreviation(abbreviation = qdapDictionaries::abbreviations,
                                           replace = NULL, ignore.case = TRUE)}%>%
  stemmer(capitalize=FALSE,warn=FALSE)
cln_up_sans<-function(x){removeDEL(x)%>%
                           PlainTextDocument %>%
                    removeURL%>% removeHyph%>% removeCarat%>% removeTags %>%
                      replace_contraction()%>%
                      replace_abbreviation(abbreviation = qdapDictionaries::abbreviations,
                                           replace = NULL, ignore.case = TRUE)
}
dm<-function(twits){
  cor<-Corpus(VectorSource(twits$text))
  cor<-tm_map(cor,function(x) iconv(x,'ASCII', to='UTF-8-MAC', sub='byte'))%>%
    tm_map(cln_up_sans)%>%
    tm_map(sent_detect)%>%
    tm_map(gsub,pattern = '@',replacement = '')
    # tm_map(gsub,pattern = '$',replacement = '.$')
  dl<-twits
  dl$text<- as.data.frame(cor)$text
  dl <- dl %>%
    subset(!(text==''|text=='…')) %>%
    subset(!(grepl(pattern='^RT',text)|grepl(pattern='^Hot Seller',text)))
  dl
}
grab_geo<-function(x,dist,unit){
  gsub(' ','',paste(paste(geocode(x)[2:1],collapse=','),",10mi",collapse=''))
}