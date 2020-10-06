#' Intersection-over-union of two polygons
#'
#' \code{IoU} finds the jaccard statistic for two input polygons
#' @param x A SpatialPolygonDataFrame of length 1
#' @param y A SpatialPolygonDataFrame of length 1
#' @return a numeric value indiciating the jaccard overlap

IoU <- function(x, y) {

  # find area of overlap
  suppressWarnings(intersection <- st_intersection(st_geometry(x), st_geometry(y)))
  if (length(intersection)==0) {
    return(0)
  }
  area_intersection <-  st_area(intersection)

  # find area of union
  area_union <- (st_area(x) + st_area(y)) - area_intersection

  return(area_intersection / area_union)
}
