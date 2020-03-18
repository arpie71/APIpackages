#' History Lab API - Full text search
#'
#' This program allows a full text search using the History Lab API.
#' In addition to a search term, collection and start.date and end.date are required fields.
#' @param s.text Text to search--can be a single word or multiword phrase
#' @param collection History Lab collection to search
#' @param start.date/end.date Date range for the search
#'
#' @return
#' @export
#' @examples
#' hlapi_search('udeac', collection=c('statedeptcables','frus'),  start.date="1974-01-01", end.date="1979-12-31")



#To do: dates

require(jsonlite)
source('R/histlabapi_utils.R')

hlapi_search<-function(s.text, limit = 25,coll.name=NULL,start.date=NULL,end.date=NULL,run=NULL,...){
  url<-"http://api.declassification-engine.org/declass/v0.4/text/?"
  search<-NULL
  notice<-NULL
  if(missing(s.text)){
    if(is.null(notice)) notice <- "Please supply a search term" else notice<-paste0(notice,"\nPlease supply a search term")
    #stop(notice)
  }

if(is.null(coll.name)){
  if(is.null(notice)) notice<-"The name of at least one collection is necessary for a full-text search." else notice<-paste0(notice,"\nThe name of at least one collection is necessary for a full-text search.")
  #stop(notice)
  }

if(is.null(start.date)|is.null(end.date)) {
  if(is.null(notice)) notice<-"Please specify a start and end date for the search." else notice<-paste0(notice,"\nPlease specify a start and end date for the search.")
  }

  coll.name<-ck_list(coll.name)
    f<-ck_collections(coll.name)
  if(!is.null(f)) {
    if(is.null(notice)) notice<-f else notice<-paste0(notice,"\n",f)
  }
  if(!is.null(notice)){
    stop(notice)
  }

  url<-paste0(url,"search=",s.text)

    url<-paste0(url,"&collections=",paste(unlist(coll.name), collapse=','))

  s<-ck_date(start.date)
  e<-ck_date(end.date)

  if(as.Date(s,date.format="%y-%m-%d")>as.Date(e,date.format="%y-%m-%d")){
    stop('Start date must be less than or equal to end date.')
  }
  url<-paste0(url,"&start_date=",paste(s, collapse=','))

  url<-paste0(url,"&end_date=",paste(e, collapse=','))


  # for now hardcoding date
#  url<-paste0(url,"&start_date=1974-01-01&end_date=1979-12-31")

    if(!is.null(run)){
    d<-fromJSON(url)
    return(d)
  }
  if(is.null(run)){
    return(url)
  }

}

hlapi_search('udeac', coll.name=c('statedeptcables','frus'))

hlapi_search('udeac', coll.name=c('statedeptcables','frs'))

#hlapi_search('udeac', coll.name=c('statedeptcables','frus'), run='run')

hlapi_search('udeac', coll.name=c('statedeptcables','frus'),  start.date="1974-01-01", end.date="1979-12-31")

hlapi_search('udeac', coll.name=c('statedeptcables','frus'),  start.date="1974-01-01", end.date="1979-12-31", run='run')

#  start<end
hlapi_search('udeac', coll.name=c('statedeptcables','frus'),  start.date="1974-01-01", end.date="1973-12-31", run='run')
