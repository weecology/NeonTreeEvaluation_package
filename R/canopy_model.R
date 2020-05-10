#' Canopy model generation from normalized las
#'
#' \code{canopy_model} returns a canopy height raster from a lidR point cloud
#' @param las A lidar cloud read in by lidR package
#' @return A raster with the canopy height estimated for each grid cell.
#' @examples
#' path <- get_data("SJER_052", "lidar")
#' las<-readLAS(path)
#' plot(canopy_model(las))
#' @export
canopy_model <- function(las, res = 0.5) {
  chm <- lidR::grid_canopy(las, res = res, lidR::pitfree(c(0, 2, 5, 10, 15), c(0, 1.5)))
  return(chm)
}
