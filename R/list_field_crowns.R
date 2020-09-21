#' @title List images that overlap with field-annotation crowns
#' @description Use this function to determine which sensor data overlaps with field collected crown data
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
