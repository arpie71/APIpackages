#' History Lab API - Search by ID or IDs
#'
#' This program returns a list of random IDs from across the collections.
#' Neither the date nor the collection parameters are accepted.
#' If an ID is not in the History Lab database, the function will not return results for that ID.
#'
#' @param ids ID or list of IDs to search for
#' @param fields Specific History Lab fields to return
#' @param topics Return the topics for an ID or list of IDs
#' @param countries Return the countries for an ID or list of IDs
#' @param persons Return the persons for an ID or list of IDs
#' @param limit Number of results to return
#'
#' @return
#' @export
#' @examples
#' hlapi_id(ids='ives-1771013-o_18', topics=TRUE, run='run')
#' hlapi_id(ids=c('1973LIMA07564','P760191-2216','1973LIMA01001'))
#' hlapi_id(ids=c('1973LIMA07564'))
#' hlapi_id(ids='1973LIMA07564', fields=c('subject','title'))

#"http://api.foiarchive.org/docs?doc_id=eq.frus1969-76ve05p1d11&select=doc_id,body,title,topics(topic_name)"

require(jsonlite)
source('R/histlabapi_utils.R')


hlapi_id<-function(ids=NULL, entity.type=NULL, fields=NULL, run = NULL,...) {
    url<-"http://api.foiarchive.org/docs?doc_id=in.("
    notice<-NULL

    if(is.null(ids)) stop("You selected the id option but provided no ids. Please list ids, separated by a comma.")

    ids<-gsub(',\\s+',',',ids)
    ids<-gsub('\\s+',',',ids)

    url<-paste0(url,paste(unlist(ids), collapse=','),")")
    if(is.null(fields)){
      fields = c('doc_id','authored','title')
    }
    if(!is.null(fields)){
      fields<-ck_list(fields)
      f<-ck_fields(fields)
      if(!is.null(f)) stop(f)
    }
    url<-paste0(url,"&select=",paste(unlist(fields), collapse=','))

    if(!is.null(entity.type)) {
      url<-ck_entities(url,entity.type)
    }

    if(!is.null(run)){
    u<-hlresults(url)
    return(hlresults(url))
    }
    if(is.null(run)){
      return(url)
    }

}

# frus1969-76ve05p1d11, frus1958-60v03d44
#"http://api.foiarchive.org/docs?doc_id=eq.frus1969-76ve05p1d11&select=doc_id,body,title,topics(topic_name)"

## Single ID
hlapi_id(ids='frus1969-76ve05p1d11', run = TRUE)

hlapi_id(ids='frus1969-76ve05p1d11', fields = c('doc_id','body','title'), run = TRUE)

## With topics
hlapi_id(ids='frus1969-76ve05p1d11', fields = c('doc_id','body','title'), entity.type="topics", run = TRUE)

## With countries
hlapi_id(ids='frus1969-76ve05p1d11', fields = c('doc_id','body','title'), entity.type="countries", run = TRUE)

hlapi_id(ids='frus1969-76ve05p1d11', fields = c('doc_id','body','title'), entity.type="persons", run = TRUE)

## Topics & countries
hlapi_id(ids='frus1969-76ve05p1d11', fields = c('doc_id','body','title'), entity.type=c("topics","countries"), run = TRUE)

hlapi_id(ids='frus1969-76ve05p1d11',  entity.type=c("topics","countries"), run = TRUE)

## Multiple IDs
hlapi_id(ids=c('frus1969-76ve05p1d11','frus1958-60v03d44'), fields = c('doc_id','body','title'), run=TRUE)

hlapi_id(ids=c('frus1969-76ve05p1d11','frus1958-60v03d44'), run=TRUE)


hlapi_id(ids=c('frus1969-76ve05p1d11','frus1958-60v03d44'), fields = c('doc_id','body','title'), entity.type=c('topics','countries'), run=TRUE)
hlapi_id(ids=c('frus1969-76ve05p1d11','frus1958-60v03d44'), entity.type=c('topics','countries'), run=TRUE)

## Wrong ID - only returns correct ID infor
hlapi_id(ids=c('frus1969','frus1958-60v03d44'), run=TRUE)

hlapi_id(ids=c('frus1969'), run=TRUE)
