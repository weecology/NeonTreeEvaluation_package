#' Compute evaluation statistics for one plot of field-annotated crowns
#'
#' @param submission
#' The format of the submission is a csv with 5 columns: plot_name, xmin, ymin, xmax, ymax  follows
#' Each row contains information for one predicted bounding box.
#' The plot column should be named the same as the files in the dataset (e.g. SJER_021), not the path to the file.
#' @param show Logical. Plot the overlayed annotations for each plot?
#' @param project_boxes Logical. Should the boxes be projected into utm coordinates? This is needed if the box coordinates are given from the image origin (top left is 0,0)
#' @param compute_PR Logical. Should the average precision and recall be computed?
#' @return If compute_PR=T, the recall and precision scores for the plot, if False, the intersection-over-union scores for each prediction.
#' @export
#'
field_crowns <- function(submission, show = TRUE, project_boxes = TRUE) {
  # find ground truth file
  plot_name <- unique(submission$plot_name)

  if (!length(plot_name) == 1) {
    stop(paste("There are", length(plot_name), "plot names. Please submit a single plot of annotations to this function, to run all plots in a submission see evaluate_field_crowns."))
  }

  ground_truth <- load_field_crown(plot_name, show = FALSE)
  ground_truth$crown_id<-1:nrow(ground_truth)

  # Read RGB image as projected raster
  siteID <- stringr::str_match(plot_name, "(\\w+)_\\d+_")[, 2]
  path_to_rgb <-get_data(plot_name, "rgb")
  rgb <- raster::stack(path_to_rgb)

  # project boxes
  predictions <- boxes_to_spatial_polygons(submission, rgb, project_boxes = project_boxes)

  if(show){
    raster::plotRGB(rgb)
    sp::plot(ground_truth, border = "black", add = TRUE)
    sp::plot(predictions, border = "red", add = TRUE)
  }

  # Create spatial polygons objects
  result <- compute_precision_recall(ground_truth, predictions, summarize = FALSE)
  return(result)
}
