#' History Lab API - Full text search
#'
#' This program allows a full text search using the History Lab API.
#' In addition to a search term, collection and start.date and end.date are required fields.
#' @param s.text Text to search--can be a single word, multiword phrase, or multiple variants
#' @param collection History Lab collection to search
#' @param start.date/end.date Date range for the search
#' @param fields Specific History Lab fields to return
#' @param topics Return the topics for an ID or list of IDs
#' @param countries Return the countries for an ID or list of IDs
#' @param persons Return the persons for an ID or list of IDs
#' @param limit Number of results to return
#'
#' @return
#' @export
#' @examples
#' hlapi_search('udeac', collection=c('statedeptcables','frus'),  start.date="1974-01-01", end.date="1979-12-31")

#docs?full_text=wfts.iraq%20rumsfeld&select=doc_id,authored,classification,title

require(jsonlite)
source('R/histlabapi_utils.R')

hlapi_search<-function(s.text, fields=NULL, entity.type=NULL, or = FALSE, start.date=NULL,end.date=NULL, limit = 25,run=NULL,...){
  url<-"http://api.foiarchive.org/docs?"
  search<-NULL
  notice<-NULL
  if(missing(s.text)){
    if(is.null(notice)) notice <- "Please supply a search term" else notice<-paste0(notice,"\nPlease supply a search term")
  }

#if(is.null(coll.name)){
#  if(is.null(notice)) notice<-"The name of at least one collection is necessary for a full-text search." else notice<-paste0(notice,"\nThe name of at least one collection is necessary for a full-text search.")
#  #stop(notice)
#  }
  if(is.null(fields)){
    fields = c('doc_id','authored','title')
  }
  if(!is.null(fields)){
    fields<-ck_list(fields)
    f<-ck_fields(fields)
    if(!is.null(f)) stop(f)
  }

#  coll.name<-ck_list(coll.name)
#    f<-ck_collections(coll.name)
#  if(!is.null(f)) {
#    if(is.null(notice)) notice<-f else notice<-paste0(notice,"\n",f)
#  }

    if(!is.null(start.date)&is.null(end.date)){
      if(is.null(notice)) notice<-"Please specify an end date." else notice<-paste0(notice,"\nPlease specify an end date.")
    }
    if(!is.null(end.date)&is.null(start.date)){
      if(is.null(notice)) notice<-"Please specify a start date." else notice<-paste0(notice,"\nPlease specify a start date.")
    }

    if(!is.null(notice)){
      stop(notice)
    }

  url<-paste0(url,configsearch(s.text,or))
  url<-paste0(url,"&select=",paste(unlist(fields), collapse=','))
    if(!is.null(entity.type)) {
      url<-ck_entities(url,entity.type)
    }

    #url<-paste0(url,"&collections=",paste(unlist(coll.name), collapse=','))

      if(!is.null(end.date)&!is.null(start.date)){
  s<-ck_date(start.date)
  e<-ck_date(end.date)

  if(as.Date(s,date.format="%y-%m-%d")>as.Date(e,date.format="%y-%m-%d")){
    stop('Start date must be less than or equal to end date.')
  }
  url<-paste0(url,"&authored=gte.",paste(s, collapse=','))

  url<-paste0(url,"&authored=lte.",paste(e, collapse=','))
  }
  url<-paste0(url,"&limit=",limit)

    if(isTRUE(run)){
      return(hlresults(url))
    }
  if(!isTRUE(run)){
    return(url)
  }
}

# Error queries

##  start date < end date
hlapi_search('udeac', coll.name=c('statedeptcables','frus'),  start.date="1974-01-01", end.date="1973-12-31", run='run')


## no search term
hlapi_search( fields=c("doc_id","title","classification"))

## bad field
hlapi_search('udeac', coll.name=c('statedeptcables','frus'), fields="doc")


# Good queries
hlapi_search('udeac', coll.name=c('statedeptcables','frus'))

hlapi_search(c('udeac','asean'), coll.name=c('statedeptcables','frus'))

hlapi_search(c('udeac','asean'), run=TRUE)
hlapi_search(c('udeac','asean'), or=TRUE, run=TRUE)
hlapi_search(c('ford','asean'), run=TRUE)
hlapi_search(c('asean'), run=TRUE)

hlapi_search(c('udeac','asean'),  entity.type="topics")
hlapi_search(c('udeac','asean'),  or=TRUE,entity.type="topics")

h<-hlapi_search(c('united nations'), limit = 100000, fields=c('doc_id','title'))

h<-hlapi_search(c('league of nations'), run=TRUE, limit = 100000, fields=c('doc_id','title'))
hlapi_search(c('league of nations'),  limit = 100000, fields=c('doc_id','title'))

#hlapi_search('udeac', coll.name=c('statedeptcables','frus'), run='run')

hlapi_search('udeac', coll.name=c('statedeptcables','frus'),  start.date="1950-01-01", end.date="2000-12-31", fields=c('body'))

#hlapi_search('udeac', coll.name=c('statedeptcables','frus'),  start.date="1974-01-01", end.date="1979-12-31", run='run')


hlapi_search('united nations', coll.name=c('statedeptcables','frus'),  start.date="1974-01-01", end.date="1979-12-31")

hlapi_search('united nations', coll.name=c('statedeptcables','frus'),  start.date="1974-01-01", end.date="1979-12-31", run='run')

hlapi_search('league of  nations', coll.name=c('statedeptcables','frus'),  start.date="1974-01-01", end.date="1979-12-31")


hlapi_search(c('udeac','asean'))
hlapi_search(c('ford','asean'), run=TRUE)
hlapi_search(c('asean'), run=TRUE)


h<-hlapi_search(c('udeac','asean'),  entity.type="topics", or=TRUE, run=TRUE)
hlapi_search(c('udeac','asean'),  entity.type="topics", or=TRUE,  start.date="1950-01-01", end.date="1970-12-31", run=TRUE)

hlapi_search(c('udeac','asean'),  entity.type="countries", or=TRUE,  start.date="1950-01-01", end.date="1970-12-31", run=TRUE)
hlapi_search(c('udeac','asean'),  entity.type=c("topics","countries"), or=TRUE,  start.date="1950-01-01", end.date="1970-12-31", run=TRUE)
