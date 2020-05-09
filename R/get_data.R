#' Retrieve sensor or annotation data from package contents
#'
#' \code{get_data} is a set of utility functions for finding the path of benchmark data on disk
#' @param plot_name A plot name.
#' @param type Which data object should be returned: "rgb" for camera imagery,"lidar" for 3D point clouds,"hyperspectral" for 426 band raster,"annotations" for dataframe of bounding box ground truth.
#' @return The filename of the object.
#' @export

get_data <- function(plot_name, type) {
  if (!type %in% c("rgb", "lidar", "hyperspectral", "annotations")) {
    stop(paste("No type option", type, "Available type arguments:'rgb','lidar','hyperspectral','annotations'"))
  }

  if (type == "rgb") {
    path <- get_rgb(plot_name)
  }
  if (type == "lidar") {
    path <- get_lidar(plot_name)
  }
  if (type == "hyperspectral") {
    path <- get_hyperspectral(plot_name)
  }
  if (type == "annotations") {
    path <- get_annotations(plot_name)
  }
  return(path)
}

get_rgb <- function(plot_name) {
  path <- paste(system.file("extdata", "evaluation/RGB/", package = "NeonTreeEvaluation"), "/", plot_name, ".tif", sep = "")
  return(path)
}

get_lidar <- function(plot_name) {
  path <- paste(system.file("extdata", "evaluation/LiDAR/", package = "NeonTreeEvaluation"), "/", plot_name, ".laz", sep = "")
  return(path)
}

get_hyperspectral <- function(plot_name) {
  path <- paste(system.file("extdata", "evaluation/Hyperspectral/", package = "NeonTreeEvaluation"), "/", plot_name, "_hyperspectral.tif", sep = "")
  return(path)
}

get_annotations <- function(plot_name) {
  path <- paste(system.file("extdata", "annotations/", package = "NeonTreeEvaluation"), "/", plot_name, ".xml", sep = "")
  return(path)
}
