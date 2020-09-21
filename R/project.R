#' Project boxes from image coordinates into utm
#' In order to plot the annotations, they need to be projected and overlayed on RGB boxes
#' @param boxes a data frame with xmin, xmax, ymin, ymax columns. Each row is a tree bounding box
#' @param raster_object a rgb raster::stack to overlay annotations. This needs a utm CRS
#' @return SpatialPolygons object of annotations
#'
# boxes is a xml object returned by the parser above, raster_object is the projected RGB image
project <- function(boxes, raster_object) {

  # scale by pixel resolution
  pixel_size <- raster::res(raster_object)[1]
  boxes$xmin <- boxes$xmin * pixel_size
  boxes$xmax <- boxes$xmax * pixel_size
  boxes$ymin <- boxes$ymin * pixel_size
  boxes$ymax <- boxes$ymax * pixel_size

  # Project, do ymax before ymin to avoid overwriting, numpy origin is topleft
  unprojected_ymax <- boxes$ymax
  unprojected_ymin <- boxes$ymin

  projection_extent <- raster::extent(raster_object)
  boxes$xmin <- projection_extent@xmin + boxes$xmin
  boxes$xmax <- projection_extent@xmin + boxes$xmax
  boxes$ymax <- (projection_extent@ymax - unprojected_ymax) + (unprojected_ymax - unprojected_ymin)
  boxes$ymin <- projection_extent@ymax - unprojected_ymax

  return(boxes)
}
