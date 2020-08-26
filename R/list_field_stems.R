#' @title List images that overlap with field-annotation crowns
#' @rdname list_field_stems
#' @export
list_field_stems<-function(){
  RGB_DIR <- paste(system.file("extdata", "NeonTreeEvaluation/evaluation/RGB/", package = "NeonTreeEvaluation"))
  rgb_images<-list.files(RGB_DIR,full.names = T)
  plots <- as.character(unique(field$plotID))
  available<-sapply(plots, function(x){
    sum(stringr::str_detect(rgb_images,x)) == 1
  })
  return(plots[available])
}
