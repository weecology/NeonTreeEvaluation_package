#' Find plot names with annotations
#'
#' \code{list_annotations} returns the plot names with available annotations in this release of the NeonTreeEvaluation benchmark. There are many plots for which their is sensor data, but no annotations.
#' @return A vector of plot names with available annotations
#' @export
list_annotations<-function(){
  f<-list.files(system.file("extdata", "annotations/", package = "NeonTreeEvaluation"))
  stringr::str_match(f,"(\\w+).xml")[,2]
}
