#' Download sensor and annotation data for the NeonTreeEvaluation Benchmark
#' @param training Download training data? See details
#' @author The core zenodo download was written by Juniper Simonis in Weecology/portalcasting
#' @references
#' Juniper Simonis, & Ethan White. (2019, July 11). weecology/portalcasting: hookup to zenodo (Version v0.8.0-1). Zenodo. http://doi.org/10.5281/zenodo.3332974
#' Weinstein, Ben G., et al. "Cross-site learning in deep learning RGB tree crown detection." Ecological Informatics 56 (2020): 101061.
#' @details
#' The training data is a large set of training tiles (>5GB). Training tiles are geographically seperate from the evaluation data.
download<-function(training=FALSE, destination=NULL){

  if(is.null(destination)){
    destination<-paste(system.file(package = "NeonTreeEvaluation"),"/extdata/",sep="")
  }

  #Evaluation data
  eval_url<-zenodo_url(concept_rec_id=3723356)
  download.file(eval_url,destination, mode = "wb")

  #Optional Training Data
  if(training){
    url<-zenodo_url(concept_rec_id=3459802)
    destination<-paste(system.file(package = "NeonTreeEvaluation"),"/extdata/",sep="")
    download.file(eval_url,destination, mode = "wb")
  }
}

#' @title Obtain the URL for a Zenodo record to be downloaded
#'
#' @description \code{zenodo_url} obtains the URL for a given Zenodo record,
#'  identified either by the concept record identifier (\code{concept_rec_id})
#'  and version (\code{rec_version}) or record identifier (\code{rec_id}).
#'  (\strong{Note}: if \code{rec_id} is used, it overrides
#'  \code{concept_rec_id}). \cr \cr
#'  \code{zenodo_versions}: determines the available version numbers and the
#'  corresponding record identifier for each version available for a given
#'  Zenodo concept (group of records).
#'
#' @param concept_rec_id Concept record identifier, a \code{character} value
#'  corresponding to the Zenodo concept.
#'
#' @param rec_version \code{character} value of the version number or
#'   \code{"latest"} (default) for the data to be download.
#'
#' @param rec_id Optional input record identifier, a \code{character} value
#'  corresponding to the Zenodo record.
#'
#'
#' @return \code{zenodo_url}: \code{character} value of the URL for the zip
#'  to be downloaded. \cr \cr
#'  \code{zenodo_versions}: a \code{data.frame} of version number and record
#'  identifier for each version available.
#'
#' @examples
#'  \donttest{
#'    zenodo_versions("3770410")
#'    zenodo_url("3770410", "latest")
#'    zenodo_url("3770410", "1.1.0")
#'  }
#'
#' @export
#'
zenodo_url <- function(concept_rec_id = 3723356, rec_version = "latest",
                       rec_id = NULL){
  if(is.null(rec_id)){
    avail_versions <- zenodo_versions(concept_rec_id = concept_rec_id)
    if(rec_version == "latest"){
      rec_id <- concept_rec_id
    } else{
      spot <- which(avail_versions$version == rec_version)
      if(length(spot) == 0){
        stop(paste0("version ", rec_version, " not available"), call. = FALSE)
      }
      rec_id <- avail_versions$rec_id[spot]
    }
  } else if (!is.null(concept_rec_id)){
    warning("both concept_rec_id and rec_id input. rec_id takes precedence")
  }

  url <- paste0("https://zenodo.org/api/records/", rec_id)
  res <- httr::GET(url)
  stop_for_status(res)
  content(res)$files[[1]]$links$download
}


zenodo_versions <- function(concept_rec_id, arg_checks = TRUE){
  url <- paste0("https://zenodo.org/api/records/?size=9999&",
                "q=conceptrecid:", concept_rec_id, "&all_versions=True")
  res <- GET(url)
  stop_for_status(res)
  cont <- content(res)
  nv <- length(cont)
  vers <- rep(NA, nv)
  recid <- rep(NA, nv)
  for(i in 1:nv){
    vers[i] <- cont[[i]]$metadata$version
    recid[i] <- cont[[i]]$record_id
  }
  data.frame(version = vers, rec_id = recid)
}


