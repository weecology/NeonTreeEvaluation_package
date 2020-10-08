#' Load and overlay ground truth annotations for single plot evaluation
#'
#' load_ground_truth is a wrapper function to get a plot annotation from file, project into geographic coordinates and potentially overlay on RGB data
#' @param plot_name The name of plot as given by the filename (e.g "SJER_021.tif" -> SJER_021).
#' @param show Logical. Whether to plot  the ground truth data overlayed on the RGB image.
#' @param use_polygon. Logical Use multipoint polygon annotation instead of bounding boxes
#' @return A SpatialPolygonsDataFrame of ground truth boxes.
#' @export
#'
load_field_crown <- function(plot_name, show = TRUE,use_polygon=FALSE) {

  # load rgb
  path_to_rgb <- get_data(plot_name,"rgb")

  #filter polygons
  plot_name<-stringr::str_remove(plot_name,"_competition")
  if (use_polygon){
    plot_crowns <- crown_polygons %>% filter(plotID %in% plot_name)
  } else{
    plot_crowns <- crowns %>% filter(plotID %in% plot_name)
  }
  if (show) {
    rgb <- raster::stack(path_to_rgb)
    raster::plotRGB(rgb)
    raster::plot(plot_crowns, add = TRUE)
  }
  return(plot_crowns)
}
