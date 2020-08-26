#' @title List paths to annotations
#' @rdname list_annotations
#' @export
list_annotations<-function(){
  f<-list.files(system.file("extdata", "NeonTreeEvaluation/annotations/", package = "NeonTreeEvaluation"))
  stringr::str_match(f,"(\\w+).xml")[,2]
}
