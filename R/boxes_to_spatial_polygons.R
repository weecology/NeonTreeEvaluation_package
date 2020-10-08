#' Convert xml crown annotations into projected bounding boxes.
#' In order to plot the annotations, they need to be projected and overlayed on RGB boxes
#'
#' @param boxes A data frame with xmin, xmax, ymin, ymax columns. Each row is a crown bounding box.
#' @param raster_object A RGB raster to overlay annotations
#' @param project_boxes Whether boxes need to be projected to utm from image coordinates (origin 0,0 top left)
#' @examples
#' \donttest{
#' xml<-get_data("SJER_052","annotations")
#' annotations<-xml_parse(xml)
#' rgb_path<-get_data("SJER_052","rgb")
#' rgb<-raster::stack(rgb_path)
#' ground_truth <- boxes_to_spatial_polygons(annotations,rgb)
#' plot(ground_truth)
#' }s
#' @return SpatialPolygons object of annotations
#' @importFrom sf as
#' @export

# boxes is a xml object returned by the parser above, raster_object is the projected RGB image
boxes_to_spatial_polygons <- function(boxes, raster_object, project_boxes = TRUE) {
  if (project_boxes) {
    boxes <- project(boxes, raster_object)
  }

  projected_polygons <- list()
  for (x in 1:nrow(boxes)) {
    e <- raster::extent(c(
      boxes$xmin[x],
      boxes$xmax[x],
      boxes$ymin[x],
      boxes$ymax[x]
    ))
    projected_polygons[[x]] <- as(e, "SpatialPolygons")
    projected_polygons[[x]]@polygons[[1]]@ID <- as.character(x)
  }

  projected_polygons <- as(sp::SpatialPolygons(lapply(
    projected_polygons,
    function(x) slot(x, "polygons")[[1]]
  )), "SpatialPolygonsDataFrame")

  projected_polygons@data$crown_id <- 1:nrow(projected_polygons)
  sp::proj4string(projected_polygons) <- raster::projection(raster_object)

  #as sf objection
  projected_polygons<-as(projected_polygons, "sf")
  return(projected_polygons)
}
