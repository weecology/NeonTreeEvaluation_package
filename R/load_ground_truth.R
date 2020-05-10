#' Load and overlay ground truth annotations for single plot evaluation
#'
#' load_ground_truth is a wrapper function to get a plot annotation from file, project into geographic coordinates and potentially overlay on RGB data
#' @param plot_name The name of plot as given by the filename (e.g "SJER_021.tif" -> SJER_021).
#' @param show Logical. Whether to plot  the ground truth data overlayed on the RGB image.
#' @return A SpatialPolygonsDataFrame of ground truth boxes.
#' @export
#'
load_ground_truth <- function(plot_name, show = TRUE) {

  # Load xml of annotations
  siteID <- stringr::str_match(plot_name, "(\\w+)_")[, 2]

  path_to_xml <- paste(system.file("extdata", "annotations", package = "NeonTreeEvaluation"), "/", plot_name, ".xml", sep = "")
  if (!file.exists(path_to_xml)) {
    message(paste("There are no annotations for file", path_to_xml, "skipping..."))
    return(NULL)
  }
  xmls <- xml_parse(path_to_xml)

  # load rgb
  path_to_rgb <- paste(system.file("extdata", "evaluation/RGB", package = "NeonTreeEvaluation"), "/", plot_name, ".tif", sep = "")

  if (file.exists(path_to_rgb)) {
    rgb <- raster::stack(path_to_rgb)
  } else {
    warning(path_to_rgb, "does not exist in current benchmark, skipping")
    return(NULL)
  }

  # Read RGB image as projected raster

  # View one plot's annotations as polygons, project into UTM
  # copy project utm zone (epsg), xml has no native projection metadata
  ground_truth <- boxes_to_spatial_polygons(boxes = xmls, raster_object = rgb, project_boxes = TRUE)

  if (show) {
    raster::plotRGB(rgb)
    raster::plot(ground_truth, add = T)
  }
  return(ground_truth)
}
