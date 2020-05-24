#' Intersection-over-union of two polygons
#'
#' \code{IoU} finds the jaccard statistic for two input polygons
#' @param x A SpatialPolygonDataFrame of length 1
#' @param y A SpatialPolygonDataFrame of length 1
#' @return a numeric value indiciating the jaccard overlap

IoU <- function(x, y) {

  # find area of overlap
  suppressWarnings(intersection <- raster::intersect(x, y))
  if (is.null(intersection)) {
    return(0)
  }
  area_intersection <- sum(sapply(intersection@polygons, function(x) {
    x@area
  }))

  # find area of union
  area_union <- (x@polygons[[1]]@area + y@polygons[[1]]@area) - area_intersection

  return(area_intersection / area_union)
}
