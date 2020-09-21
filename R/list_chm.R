#' @title List paths to canopy height files
#' @description This function looks into package contents (system.file("extdata")). See download() to download full set of sensor data from zenodo.
#' @rdname list_chm
#' @export
list_chm<-function(){
  check_download()
  CHM_DIR <- paste(system.file("extdata", "NeonTreeEvaluation/evaluation/CHM/", package = "NeonTreeEvaluation"))
  CHM_images<-list.files(CHM_DIR,".tif",full.names = T)
  CHM_images<-CHM_images[!stringr::str_detect(CHM_images,".xml")]
  return(CHM_images)
}
