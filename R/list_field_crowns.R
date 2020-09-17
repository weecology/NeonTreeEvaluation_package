#' @title List images that overlap with field-annotation crowns
#' @rdname list_field_crowns
#' @export
list_field_crowns<-function(){
  plot_names<-unique(crowns$plotID)
  plot_names<-paste(plot_names,"_competition",sep="")
  rgb_images<-get_data(plot_names,"rgb")

  #Ensure all exists
  rgb_images<-rgb_images[sapply(rgb_images, file.exists)]
  return(rgb_images)
}
