#' Utility functions for listing plots and location of data
#' @examples
#' @return a set of file paths
#' @export

list_rgb<-function(){
  RGB_DIR <- paste(system.file("extdata", "evaluation/RGB/", package = "NeonTreeEvaluation"))
  rgb_images<-list.files(RGB_DIR,".tif",full.names = T)
  rgb_images<-rgb_images[!str_detect(rgb_images,".xml")]
  return(rgb_images)
}

list_chm<-function(){
  CHM_DIR <- paste(system.file("extdata", "evaluation/CHM/", package = "NeonTreeEvaluation"))
  CHM_images<-list.files(CHM_DIR,".tif",full.names = T)
  CHM_images<-CHM_images[!str_detect(CHM_images,".xml")]
  return(CHM_images)
}