#' @title List paths to annotations
#' @description This function looks into package contents for ground truth annotations for the image-annotated crowns. See download() to download full set of data from zenodo.
#' @rdname list_annotations
#' @export
list_annotations<-function(){
  f<-list.files(system.file("extdata", "NeonTreeEvaluation/annotations/", package = "NeonTreeEvaluation"))
  stringr::str_match(f,"(\\w+).xml")[,2]
}
