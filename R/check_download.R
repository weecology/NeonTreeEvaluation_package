#' Check if data has been downloaded
#' @return a set of file paths
#' @export

check_download<-function(){
  RGB_DIR <- paste(system.file("extdata", "NeonTreeEvaluation/evaluation/RGB/", package = "NeonTreeEvaluation"))

  #Check if in testing env
  if(!identical(Sys.getenv("TESTTHAT"), "true")){
    f<-list.files(RGB_DIR)
    if(length(f) < 10){
      stop("Data has not been downloaded to package contents. Due to data size, the package code and test data live in this package To download the full sensor and evaluation data, use download().")
    }
  }
}
