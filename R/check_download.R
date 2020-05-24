#' Check if data has been downloaded
#' @return a set of file paths
#' @export

check_download<-function(){
  destination<-paste(system.file(package = "NeonTreeEvaluation"),"/extdata/",sep="")
  f<-list.files(destination)
  if(length(f)==0){
    stop("Data has not been downloaded to package contents. Due to data size, the package code and data live in different repositories. To download the sensor and evaluation data, use download().")
  }
}
