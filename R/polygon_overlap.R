#' Find area of overlap among sets of polygons
#'
#' \code{convex_hull} is a wrapper function to iterate through a SpatialPolygonsDataFrame
#' @param pol A ground truth polygon
#' @param prediction prediction polygons
#' @return A data frame with the crown ID, the prediction ID and the area of overlap.

polygon_overlap <- function(pol, predictions) {
  overlap_area <- c()
  for (x in 1:nrow(predictions)) {
    pred_poly <- predictions[x, ]
    intersect_poly <- sf::st_intersection(st_geometry(pol), st_geometry(pred_poly))
    if (!length(intersect_poly)==0) {
      overlap_area[x] <- st_area(intersect_poly)
    } else {
      overlap_area[x] <- 0
    }
  }
  data.frame(crown_id = pol$crown_id, prediction_id = predictions$crown_id, area = overlap_area)
}
