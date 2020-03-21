#' History Lab API - Overview
#'
#' This function allows an overview query of the History Lab API.
#' It will provide a list of fields and collections available to search as well as an overview of the entities in a collection.
#' If an entity type is mentioned but a date range is not specified using start.date and end.date, the function will return entities across the entire collection.
#'
#' Options to limit the results include collection and limit.
#'
#' @param collection Show collections or overview of collections
#' @param fields Return the list of fields
#' @param entities
#' @param entity.type Type of entity (geographic, topic, person, or classification)
#' @param start.date Start date for a top entity search
#' @param end.date End date for a top entity search
#'
#' @return
#' @export
#' @examples
#'

require(jsonlite)
source('R/histlabapi_utils.R')

hlapi_overview<-function(start.date=NULL,end.date=NULL, limit = 25,fields=FALSE,collections=FALSE, coll.name=NULL,entity.type=NULL, entity=FALSE,run=FALSE,...){

  url<-"http://api.declassification-engine.org/declass/v0.4/"
  notice<-NULL

  if((fields)&(!is.null(coll.name)|entity|!is.null(entity.type)|!is.null(start.date)|!is.null(end.date))) notice<-"Fields cannot be combined with any other option."
  # We should be able to combine fields and collections so leaving collections out for now
  if((collections)&(!is.null(coll.name)|entity|!is.null(entity.type)|!is.null(start.date)|!is.null(end.date))) notice<-"Collections cannot be combined with any other option."

  if(!is.null(notice)){
    stop(notice)
  }

  if(fields){
    url<-paste0(url,"fields")
  }

  if(collections&is.null(coll.name)){
    url<-paste0(url,"collections")
  }

  if(!is.null(entity.type)){
    entity.type<-ck_list(entity.type)
    if(length(entity.type)>1) stop('The name of only one entity can be used with this function.')
    if(entity.type %ni% c("countries", "persons", "topics")){
      notice <- "Acceptable entities are countries, topics, or persons"
      stop(notice)
    }
      }
  if(!is.null(coll.name)){
    coll.name<-ck_list(coll.name)
    f<-ck_collections(coll.name)
    if(!is.null(f)) stop(f)
    if(length(coll.name)>1) stop('The name of only one collection can be used with this function.')
  }


  if(!is.null(coll.name)&entity&is.null(start.date)&is.null(end.date)){
    if(is.null(entity.type)) url<-paste0(url,"entity_info/?collection=",coll.name)
    if(!is.null(entity.type)) url<-paste0(url,"entity_info/?collection=",coll.name,"&entity=",entity.type)
    url<-paste0(url,"&page_size=",limit)

      }

  if(!is.null(start.date)|!is.null(end.date)){
  #collection & entity name are both required
    if(!is.null(start.date)&is.null(end.date)){
      if(is.null(notice)) notice<-"Please specify an end date." else notice<-paste0(notice,"\nPlease specify an end date.")
    }
    if(!is.null(end.date)&is.null(start.date)){
      if(is.null(notice)) notice<-"Please specify a start date." else notice<-paste0(notice,"\nPlease specify a start date.")
    }
    if(is.null(coll.name)){
      if(is.null(notice)) notice<-"Please specify a collection name for a top entity search." else notice<-paste0(notice,"\nPlease specify a collection name for a top entity search.")
    }

    if(is.null(entity.type)){
      if(is.null(notice)) notice<-"Please specify an entity type for a top entity search." else notice<-paste0(notice,"\nPlease specify an entity type for a top entity search.")
    }

    if(!is.null(notice)){
      stop(notice)
    }

    url=paste0(url,"overview/")
    url<-paste0(url,"?collection=",paste(unlist(coll.name), collapse=','))
    url<-paste0(url,"&entity=",paste(unlist(entity.type), collapse=','))

    s<-ck_date(start.date)
    url<-paste0(url,"&start_date=",s)
    e<-ck_date(end.date)
    url<-paste0(url,"&end_date=",e)
    if(as.Date(s,date.format="%y-%m-%d")>as.Date(e,date.format="%y-%m-%d")){
      stop('Start date must be less than or equal to end date.')
    }
    url<-paste0(url,"&page_size=",limit)

      }

  if(run){
    u<-fromJSON(url)
    return(u)
  }
  if(!run){
    return(url)
  }


}


hlapi_overview(fields=TRUE, run=TRUE)
hlapi_overview(collections=TRUE)

hlapi_overview(fields=TRUE, coll.name='frus')
hlapi_overview(collections=TRUE, coll.name='frus')

hlapi_overview(coll.name='frus,kissinger')

hlapi_overview(coll.name='frus,kissinger', entity=TRUE)

hlapi_overview(coll.name='frus', entity=TRUE)
hlapi_overview(coll.name='frus', entity=TRUE, entity.type = 'countries', run=TRUE)
hlapi_overview(coll.name='frus', entity=TRUE, entity.type = 'persos')

hlapi_overview(coll.name='frus', entity=TRUE, entity.type = 'persons,countries')

hlapi_overview(coll.name='frus', entity=TRUE, entity.type = 'persons', start.date='1974-01-01', end.date='1/1/1979')

hlapi_overview(coll.name='frus', entity=TRUE, entity.type = 'topics', start.date='1974-01-01', end.date='1/1/1979', run=TRUE)

hlapi_overview(coll.name='frus', entity=TRUE, entity.type = 'countries', start.date='1973-01-01', end.date='12/31/1979', run=TRUE)


#http://api.declassification-engine.org/declass/v0.4/fields

#http://api.declassification-engine.org/declass/v0.4/collections

#http://api.declassification-engine.org/declass/v0.4/entity_info/?collection=collection_name

#http://api.declassification-engine.org/declass/v0.4/entity_info/?collection=collection_name&entity=entity_name

#http://api.declassification-engine.org/declass/v0.4/overview/?collection=frus&entity=countries&start_date=1973-01-01&end_date=1979-12-31

#http://api.declassification-engine.org/declass/v0.4/overview/?collection=frus&entity=persons&start_date=1973-01-01&end_date=1979-12-31

