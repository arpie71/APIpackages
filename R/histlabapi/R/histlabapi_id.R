#' History Lab API - Search by ID or IDs
#'
#' This program returns a list of random IDs from across the collections.
#' Neither the date nor the collection parameters are accepted.
#' If an ID is not in the History Lab database, the function will not return results for that ID.
#'
#' @param ids ID or list of IDs to search for
#' @param fields Specific History Lab fields to return
#' @param topics Return the topics for an ID or list of IDs
#' @param limit Number of results to return
#'
#' @return
#' @export
#' @examples
#' hlapi_id(ids='ives-1771013-o_18', topics=TRUE, run='run')
#' hlapi_id(ids=c('1973LIMA07564','P760191-2216','1973LIMA01001'))
#' hlapi_id(ids=c('1973LIMA07564'))
#' hlapi_id(ids='1973LIMA07564', fields=c('subject','title'))



require(jsonlite)
source('R/histlabapi_utils.R')

hlapi_id<-function(ids=NULL, fields=NULL, topics=FALSE, run = NULL,...){
  url<-"http://api.declassification-engine.org/declass/v0.4/?"
  notice<-NULL

  if(is.null(ids)) stop("You selected the id option but provided no ids. Please list ids, separated by a comma.")

  ids<-gsub(',\\s+',',',ids)
  ids<-gsub('\\s+',',',ids)
  if((length(ids)>1|length(as.list(strsplit(ids,",")[[1]]))>1)&topics) stop('Only one ID can be used with the topic option')
  if(length(ids)>1|length(as.list(strsplit(ids,",")[[1]]))>1) s.id<-'ids=' else s.id<-'id='

  url<-paste0(url,s.id,paste(unlist(ids), collapse=','))
#print("here")
  if(!is.null(fields)){
    fields<-ck_list(fields)
    f<-ck_fields(fields)
    if(!is.null(f)) stop(f)
    url<-paste0(url,"&fields=",paste(unlist(fields), collapse=','))
  }
  if(topics) {
    if(!is.null(fields)) warning('Fields cannot be used with the topics option and will be ignored.')
    url<-paste0("http://api.declassification-engine.org/declass/v0.4/topics/doc/",paste(unlist(ids), collapse=','))

  }

  if(!is.null(run)){
    u<-fromJSON(url)
    return(u)
  }
  if(is.null(run)){
    return(url)
  }

}


#hlapi_id(ids=c('1973LIMA07564','P760191-2216','1973LIMA01001'), run='run')

#hlapi_id(ids='1973LIMA07564,P760191-2216,1973LIMA01001', run='run')

hlapi_id(ids='1973LIMA07564, P760191-2216, 1973LIMA01001')

hlapi_id(ids='1973LIMA07564 P760191-2216 1973LIMA01001')
hlapi_id(ids='1973LIMA07564 P760191-2216  1973LIMA01001')

hlapi_id(ids=c('1973LIMA07564','P760191-2216','1973LIMA01001'), run='run')
hlapi_id(ids=c('1973LIMA07564'))

hlapi_id(ids='1973LIMA07564', run='run')
hlapi_id(ids='1973LIMA07564', fields=c('subject','title'), run='run')

hlapi_id(ids='ives-1771013-o_18', topics=TRUE, run='run')

hlapi_id(ids='ives-1771013-o_18', fields=c('subject','title'), topics=TRUE)

hlapi_id(ids=c('ives-1771013-o_18','chives-1771497_37'), fields=c('subject','title'), topics=TRUE)

hlapi_id(ids=c('ives-1771013-o_18','chives-1771497_37'), fields=c('subject','title'), topics=TRUE, run='run')

hlapi_id(ids=c('ives-1771013-o_18'), fields=c('subject','title'), topics=TRUE, run='run')


hlapi_id(ids=c('ives-1771013-o_18'),  topics=TRUE, coll.name='frus')
