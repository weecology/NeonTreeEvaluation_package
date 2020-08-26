#' Compute evaluation statistics for one plot of image-annotated crowns
#'
#' @param submission A five column dataframe in the order plot_name, xmin, xmax, ymin, ymax. Each row is a predicted bounding box.
#' @param show Logical. Plot the overlayed annotations for each plot?
#' @param project_boxes Logical. Should the boxes be projected into utm coordinates? This is needed if the box coordinates are given from the image origin (top left is 0,0)
#' @param compute_PR Logical. Should the average precision and recall be computed?
#' @return If compute_PR=T, the recall and precision scores for the plot, if False, the intersection-over-union scores for each prediction.
#' @export
#'
image_crowns <- function(submission, show = TRUE, project_boxes = TRUE) {
  # find ground truth file
  plot_name <- unique(submission$plot_name)
  if (!length(plot_name) == 1) {
    stop(paste("There are", length(plot_name), "plot names. Please submit one plot of annotations to this function"))
  }

  ground_truth <- load_ground_truth(plot_name, show = FALSE)
  if (is.null(ground_truth)) {
    return(data.frame(NULL))
  }

  # Read RGB image as projected raster
  siteID <- stringr::str_match(plot_name, "(\\w+)_")[, 2]

  path_to_rgb <-get_data(plot_name, "rgb")
  print(plot_name)
  rgb <- raster::stack(path_to_rgb)

  # project boxes
  predictions <- boxes_to_spatial_polygons(submission, rgb, project_boxes = project_boxes)

  if (show) {
    raster::plotRGB(rgb)
    sp::plot(ground_truth, border = "black", add = TRUE)
    sp::plot(predictions, border = "red", add = TRUE)
  }

  # Create spatial polygons objects
  result <- compute_precision_recall(ground_truth, predictions, summarize = FALSE)
  return(result)
}
