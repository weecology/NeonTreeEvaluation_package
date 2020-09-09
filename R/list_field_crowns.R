#' @title List images that overlap with field-annotation crowns
#' @rdname list_field_crowns
#' @export
list_field_crowns<-function(){
  plot_names<-c(unique(MLBS$plotID),unique(OSBS$plotID))
  plot_names<-stringr::str_replace(plot_names,".tif","_competition")
  rgb_images<-get_data(plot_names,"rgb")
  return(rgb_images)
}
