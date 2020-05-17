#' @title Download sensor and annotation data for the NeonTreeEvaluation Benchmark
#' @param training Download training data? See details
#' @param savedir Optional directory to save data in a new location. Defaults to package contents. Warning: Functions are designed for this location, only use this argument if you do not intend to run evaluation data.
#' @author The core zenodo download function was written by Juniper Simonis in Weecology/portalcasting (Simonis and White 2019). Adapted by Ben Weinstein.
#' @references
#' Juniper Simonis, & Ethan White. (2019, July 11). weecology/portalcasting: hookup to zenodo (Version v0.8.0-1). Zenodo. http://doi.org/10.5281/zenodo.3332974
#'
#' Weinstein, Ben G., et al. "Cross-site learning in deep learning RGB tree crown detection." Ecological Informatics 56 (2020): 101061.
#' @details
#' The NeonTreeEvaluation benchmark consists of two parts, 1) package code to run evaluation workflows, 2) evaluation data. Evaluation data is ~ 2GB in size and will be downloaded to package contents. See
#' The training data is a large set of training tiles (>5GB). Training tiles are geographically seperate from the evaluation data.
#' @examples
#'  \donttest{
#'  download()
#'  path<-paste(system.file(package = "NeonTreeEvaluation"),"/extdata/",sep="")
#'  list_rgb()
#'  }
#' @export
download<-function(training=FALSE, savedir=NULL,force=F){

  if(is.null(savedir)){
    destination<-paste(system.file(package = "NeonTreeEvaluation"),"/extdata/NeonTreeEvaluation.zip",sep="")
    dirname <-paste(system.file(package = "NeonTreeEvaluation"),"/extdata/NeonTreeEvaluation/",sep="")
  } else{
    destination<-file.path(savedir,"NeonTreeEvaluation.zip")
    dirname<-file.path(savedir,"NeonTreeEvaluation/")
  }

  #check if already exists.
  if(dir.exists(dirname)){
    if(!force){
      stop(paste("Data has already been downloaded to",dirname,", use force=T to overwrite"))
    }
  }

  #Evaluation data
  eval_url<-zenodo_url(concept_rec_id=3723356)
  message(paste("Downloading file to",destination))
  download.file(eval_url,destination, mode = "wb")
  unzip_download(destination)

  #Optional Training Data
  if(training){
    url<-zenodo_url(concept_rec_id=3459802)
    destination<-paste(system.file(package = "NeonTreeEvaluation"),"/extdata/",sep="")
    download.file(eval_url,destination, mode = "wb")
    unzip_download(destination)
  }
}

#' @rdname download
#'
#' @export
#'
unzip_download <- function(destination){
  #location of unzip
  base_dir<-dirname(destination)

  #get file names
  unzip_folder<-unzip(destination, list = TRUE)$Name[1]
  unzipped_folder<-file.path(base_dir,unzip_folder)

  unzip(destination,exdir=base_dir)
  final_name<-file.path(base_dir,"NeonTreeEvaluation/")
  file.rename(unzipped_folder,final_name)

  #Remove zipped files
  unlink(destination)
}
