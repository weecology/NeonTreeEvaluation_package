#' Utility functions for listing plots and location of data
#' @return a set of file paths from the downloaded sensor data
#' @title List paths to RGB files
#' @rdname list_rgb
#' @export
list_rgb<-function(){
  check_download()
  RGB_DIR <- paste(system.file("extdata", "NeonTreeEvaluation/evaluation/RGB/", package = "NeonTreeEvaluation"))
  rgb_images<-list.files(RGB_DIR,".tif",full.names = T)
  rgb_images<-rgb_images[!stringr::str_detect(rgb_images,".xml")]
  return(rgb_images)
}
