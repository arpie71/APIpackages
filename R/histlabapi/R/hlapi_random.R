#' History Lab API - Return random IDs
#'
#' This program returns a list of random IDs from across the collections.
#' The only allowed parameter is limit which controls the number of IDs returned.
#' @param limit Number of IDs to return
#'
#' @return
#' @export
#' @examples
#' hlapi_random(limit= 50 )

require(jsonlite)
source('R/histlabapi_utils.R')

hlapi_random<-function(limit = NULL, run = NULL,...){
  url<-"http://api.declassification-engine.org/declass/v0.4/random/"

  if(!is.null(limit)) url<-paste0(url,'?limit=',limit)

  if(!is.null(run)){
  return(url)
}
if(is.null(run)){
  d<-fromJSON(url)
  return(d)
}

  }

hlapi_random()
hlapi_random(limit=50)

h<-hlapi_random(limit=25)

