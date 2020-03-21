#' History Lab API - Entity search
#'
#' This program allows a search of the History Lab API by type of entity (countries, topics, or persons).
#'
#' @param entity.type The type of entity to search (countries, topics, and/or persons)
#' @param value The code of the specific entity to be searched
#' @param coll.name History Lab collection to search
#' @param start.date/end.date Date range for the search
#' @param fields Specific History Lab fields to return
#'
#' @return
#' @export
#' @examples
#' hlapi_entity(c('countries','topics'), fields=c('subject','title'), value=c('100','0'), limit=50, run='run')


require(jsonlite)
source('R/histlabapi_utils.R')

hlapi_entity<-function(entity.type, value, limit = 25,fields=NULL,coll.name=NULL,date=NULL,start.date=NULL,end.date=NULL,run=NULL,...){
url<-"http://api.declassification-engine.org/declass/v0.4/?"
search<-NULL
notice<-NULL
if(missing(entity.type)){
  notice <- "Please supply an entity: countries, topics, and/or persons"
  stop(notice)
}

if(missing(value)){
  notice <- "Please supply a value or values for the entity or entities"
  stop(notice)
}

entity.type<-ck_list(entity.type)
#value<-ck_list(value)

if(length(value)!=length(entity.type)){
  notice <- "The number of entities and the number of values do not match."
  stop(notice)
}

for(i in 1:length(entity.type)){
  if(entity.type[i] %ni% c("countries", "persons", "topics")){
    notice <- "Acceptable entities are countries, topics, and/or persons"
    stop(notice)
  }
  v<-toupper(gsub("( |&|,)","AND",value[i]))
  v<-toupper(gsub("(\\|)","OR",v))

  # Make sure countries is 3-digits
  if(entity.type[i]=="countries"){
    g.list<-strsplit(v,'AND')
        for(j in 1:length(g.list[[1]])){
      if(nchar(g.list[[1]][j])==2) g.list[[1]][j]<-paste0("0",g.list[[1]][j])
      if(nchar(g.list[[1]][j])>3|nchar(g.list[[1]][j])<2) stop('Invalid value for countries')
    }
      v<-(paste0(g.list[[1]],collapse="AND"))
      }

  if(entity.type[i]=="countries"&!is.null(search)) search<-paste0(search,"&geo_ids=",v)
  if(entity.type[i]=="countries"&is.null(search)) search<-paste0("geo_ids=",v)
  if(entity.type[i]=="topics"&!is.null(search)) search<-paste0(search,"&topic_ids=",v)
  if(entity.type[i]=="topics"&is.null(search)) search<-paste0("topic_ids=",v)
  if(entity.type[i]=="persons"&!is.null(search)) search<-paste0(search,"&person_ids=",v)
  if(entity.type[i]=="persons"&is.null(search)) search<-paste0("person_ids=",v)
}
url<-paste0(url,search)
# Check fields if fields entered
if(!is.null(fields)){
  fields<-ck_list(fields)
  f<-ck_fields(fields)
  if(!is.null(f)) stop(f)
  url<-paste0(url,"&fields=",paste(unlist(fields), collapse=','))
  }

#Check collections if collections entered
if(!is.null(coll.name)){
  coll.name<-ck_list(coll.name)
  f<-ck_collections(coll.name)
  if(!is.null(f)) stop(f)
  url<-paste0(url,"&collections=",paste(unlist(coll.name), collapse=','))
}

if(!is.null(date)&(!is.null(start.date)|!is.null(end.date))){
  if(is.null(notice)) notice<-"You cannot specify both a date and a start or end date." else notice<-paste0(notice,"\nYou cannot specify both a date and a start or end date.")
}
if(!is.null(start.date)&is.null(end.date)){
  if(is.null(notice)) notice<-"Please specify an end date." else notice<-paste0(notice,"\nPlease specify an end date.")
}
if(!is.null(end.date)&is.null(start.date)){
  if(is.null(notice)) notice<-"Please specify a start date." else notice<-paste0(notice,"\nPlease specify a start date.")
}

if(!is.null(notice)){
  stop(notice)
}
if(!is.null(date)) {
  d<-ck_date(date)
  url<-paste0(url,"&date=",d)
    }

if(!is.null(start.date)) {
  s<-ck_date(start.date)
  url<-paste0(url,"&start_date=",s)

}

if(!is.null(end.date)) {
  e<-ck_date(end.date)
  url<-paste0(url,"&end_date=",e)
  if(as.Date(s,date.format="%y-%m-%d")>as.Date(e,date.format="%y-%m-%d")){
    stop('Start date must be less than or equal to end date.')
  }
  }

url<-paste0(url,"&page_size=",limit)

if(!is.null(run)){
u<-fromJSON(url)
return(u)
}
if(is.null(run)){
return(url)
  }
}


hlapi_entity('topics', value='1001,1000')
hlapi_entity('topics', value=c('1001,1000'))
#Too many values for entities
hlapi_entity('topics', value=c('1001','1000'))

hlapi_entity('persons', value='1001')

hlapi_entity('topics', value=c('1001,1000|1003'))
hlapi_entity('topics', value=c('1001and1000|1003'))


#Number of entities and values do not match
hlapi_entity(c('countries','topics'), value=c('1001,1000'))

#countries has to be 2 or 3-digits
hlapi_entity(c('countries','topics'), value=c('1001','1000'))

hlapi_entity(c('countries'), value=c('120,100'))
hlapi_entity(c('countries'), value=c('120,10'))


hlapi_entity(c('topics','countries'), value=c('100','10'))

hlapi_entity(c('countries','topics'), fields=c('subject','title'), value=c('100','0'))

hlapi_entity(c('countries','topics'), fields=c('subject','body'), coll.name="kissinger", value=c('100','1000'))

hlapi_entity(c('countries','topics'), fields=c('subject','title'), value=c('100','0'), limit=50, run='run')
hlapi_entity(c('countries','topics'), fields=c('subject','title'), value=c('1000','0'), limit=50, run='run')

hlapi_entity(c('countries','topics'), fields=c('subject','title'), value=c('040','0'), limit=50)
hlapi_entity(c('countries','topics'), fields=c('subject','title'), value=c('40','0'), limit=50)

hlapi_entity(c('countries','topics'), fields=c('subject','title'), value=c('40','0'), date="12-31-1979",limit=50)

# invalid date
hlapi_entity(c('countries','topics'), fields=c('subject','title'), value=c('40','0'), date="12-33-1979",limit=50)

# date & start.date
hlapi_entity(c('countries','topics'), fields=c('subject','title'), value=c('40','0'), date="12-31-1979",start.date="1-1-1974",limit=50)

# no end.date & start.date
hlapi_entity(c('countries','topics'), fields=c('subject','title'), value=c('40','0'), start.date="1-1-1974",limit=50)

# date formats
hlapi_entity(c('countries','topics'), fields=c('subject','title'), value=c('40','0'), start.date="12/31/1974",end.date="1.1.1979",limit=50)


hlapi_entity(c('countries','topics'), fields=c('subject','title'), value=c('40','0'), start.date="12/31/1974",end.date="1.1.1979",limit=50, run='run')


#  start<end
hlapi_entity(c('countries','topics'), fields=c('subject','title'), value=c('40','0'), start.date="12/31/1974",end.date="1.1.1973",limit=50)

hlapi_entity(c('countries','topics'), fields=c('subject','title'), value=c('100and888','0'), limit=50, run='run')

hlapi_entity('topics', fields=c('subject','title'), value='0', start.date="1/1/1975",end.date="12.31.1980")


#!
# t<-fromJSON('http://api.declassification-engine.org/declass/v0.4/?geo_ids=100&fields=subject,title')
#
# limit<-250
# url ="http://api.declassification-engine.org/declass/v0.4/"
# #url= 'http://api.declassification-engine.org/declass/v0.4/?geo_ids=100&fields=subject,title'
# url <-paste(url,"?geo_ids=100&fields=subject,title&page_size=",limit,sep="")
# t<-fromJSON(url)
#
# parsed_json <- jsonlite::fromJSON(url)
# entity_data <- parsed_json$results
# num_pages<-10
# num_pages <- num_pages - 1
#
# while (is.null(parsed_json$next_page) == FALSE & num_pages > 0) {
#   print(parsed_json$next_page)
#   parsed_json <- jsonlite::fromJSON(parsed_json$next_page)
#   entity_data <- rbind(entity_data, parsed_json$results)
#   num_pages <- num_pages - 1
# }

