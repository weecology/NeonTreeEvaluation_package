#' Load and overlay ground truth annotations for single plot evaluation
#'
#' load_ground_truth is a wrapper function to get a plot annotation from file, project into geographic coordinates and potentially overlay on RGB data
#' @param plot_name The name of plot as given by the filename (e.g "SJER_021.tif" -> SJER_021).
#' @param show Logical. Whether to plot  the ground truth data overlayed on the RGB image.
#' @return A SpatialPolygonsDataFrame of ground truth boxes.
#' @export
#'
load_field_crown <- function(plot_name, show = TRUE) {

  # Load shp of field annotations
  siteID <- stringr::str_match(plot_name, "(\\w+)_\\d+_")[, 2]
  crowns <- eval(as.symbol(siteID))
  # load rgb
  path_to_rgb <- get_data(plot_name,"rgb")

  #filter polygons
  plot_name<-stringr::str_remove(plot_name,"_competition")
  plot_name<-paste(plot_name,".tif",sep="")
  crowns <- crowns %>% filter(plotID == plot_name)
  crowns <- sf:::as_Spatial(crowns)
  if (show) {
    rgb <- raster::stack(path_to_rgb)
    raster::plotRGB(rgb)
    raster::plot(crowns, add = TRUE)
  }
  return(crowns)
}
