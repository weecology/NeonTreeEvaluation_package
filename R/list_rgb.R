#' Utility functions for listing plots and location of data
#' @examples
#' @return a set of file paths
#' @export

list_rgb<-function(){
  check_download()
  RGB_DIR <- paste(system.file("extdata", "NeonTreeEvaluation/evaluation/RGB/", package = "NeonTreeEvaluation"))
  rgb_images<-list.files(RGB_DIR,".tif",full.names = T)
  rgb_images<-rgb_images[!stringr::str_detect(rgb_images,".xml")]
  return(rgb_images)
}

list_chm<-function(){
  check_download()
  CHM_DIR <- paste(system.file("extdata", "NeonTreeEvaluation/evaluation/CHM/", package = "NeonTreeEvaluation"))
  CHM_images<-list.files(CHM_DIR,".tif",full.names = T)
  CHM_images<-CHM_images[!stringr::str_detect(CHM_images,".xml")]
  return(CHM_images)
}
