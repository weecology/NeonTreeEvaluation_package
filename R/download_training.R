#' @title Download training data tiles for the NeonTreeEvaluation Benchmark
#' @description The benchmark dataset contains both evaluation and training data for future use. While the annotations and evaluation data are modest in size, the training data is over 20GB and cannot be included directly in the package.
#' To download the data, the download_data funtion pulls the training tiles from the Zenodo archive and places them alongside the evalution data by default
#'
zenodo_url <- function(concept_rec_id = NULL, rec_version = "latest",
                       rec_id = NULL, arg_checks = TRUE){
  check_args(arg_checks = arg_checks)
  if(is.null(rec_id)){
    avail_versions <- zenodo_versions(concept_rec_id = concept_rec_id,
                                      arg_checks = arg_checks)
    if(rec_version == "latest"){
      rec_id <- concept_rec_id
    } else{
      spot <- which(avail_versions$version == rec_version)
      if(length(spot) == 0){
        stop(paste0("version ", rec_version, " not available"))
      }
      rec_id <- avail_versions$rec_id[spot]
    }
  } else if (!is.null(concept_rec_id)){
    warning("both concept_rec_id and rec_id input. rec_id takes precedence")
  }

  url <- paste0("https://zenodo.org/api/records/", rec_id)
  res <- GET(url)
  stop_for_status(res)
  content(res)$files[[1]]$links$download
}

download_training<-function(destination){
  source_url <- zenodo_url()
  resp <- GET(source_url)
}
