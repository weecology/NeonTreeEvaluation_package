#' @title List images that overlap with field-collected stems
#' @description The field collected stems are individual points for each tree. They overlap with a subset of the sensor data. Use this function to determine which plots have stem data.
#' @rdname list_field_stems
#' @export
list_field_stems<-function(){
  RGB_DIR <- paste(system.file("extdata", "NeonTreeEvaluation/evaluation/RGB/", package = "NeonTreeEvaluation"))
  rgb_images<-list.files(RGB_DIR,full.names = T)
  plots <- as.character(unique(NeonTreeEvaluation::field$plotID))
  available<-sapply(plots, function(x){
    sum(stringr::str_detect(rgb_images,x)) == 1
  })
  return(plots[available])
}
