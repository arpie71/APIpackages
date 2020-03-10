histlabapi<-function(options="string", limit=NULL) {
  # if ~regexm("`options'","(id)|(date)|(random)") {
  #nois di as error "`option' is not a valid option. Allowable options are id, date, and random."
  #exit
#}
hllist<-c("random","id","date")
ck<-grepl(paste(hllist,collapse="|"),options)
  if(any(grepl(paste(hllist,collapse="|"),options))) { 
    l<-ifelse(is.null(limit),25,limit)
#if(grep("random",options)) 
url<-paste("http://api.declassification-engine.org/declass/v0.4/",options,l,sep="")
#hlapi<-readLines("http://api.declassification-engine.org/declass/v0.4/random")
#hldf<-fromJSON(hlapi)
  return(url)
  } else {
stop(paste(paste('The option',options),'is not allowed'))
  }
}

hlapi<-readLines("http://api.declassification-engine.org/declass/v0.4/?start_date=1947-01-01&end_date=1947-1-4")