#' Compute evaluation statistics for one plot of image-annotated crowns
#'
#' @param predictions
#' The format of the submission is either a csv with 5 columns: plot_name, xmin, ymin, xmax, ymax or a sf polygon object with poylgons in image coordinates.
#' Each row contains information for one predicted bounding box.
#' The plot column should be named the same as the files in the dataset (e.g. SJER_021), not the path to the file.
#' @param show Logical. Plot the overlayed annotations for each plot?
#' @param project_boxes Logical. Should the boxes be projected into utm coordinates? This is needed if the box coordinates are given from the image origin (top left is 0,0)
#' @param compute_PR Logical. Should the average precision and recall be computed?
#' @return If compute_PR=T, the recall and precision scores for the plot, if False, the intersection-over-union scores for each prediction.
#' @export
#'
image_crowns <- function(predictions, show = TRUE, project_boxes = TRUE) {
  # find ground truth file
  plot_name <- unique(predictions$plot_name)
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

  #check sf polygon or csv file
  is_polygons = any(class(predictions) == "sf")
  #If is_polygons, project must be true
  if(is_polygons){
    predictions <- sf_to_spatial_polygons(predictions, rgb)
  } else{
    predictions <- boxes_to_spatial_polygons(predictions, rgb, project_boxes = project_boxes)
  }

  # project boxes

  if (show) {
    raster::plotRGB(rgb)
    plot(st_geometry(ground_truth), border = "black", add = TRUE)
    plot(st_geometry(predictions), border = "red", add = TRUE)
  }

  # Create spatial polygons objects
  result <- compute_precision_recall(ground_truth, predictions, summarize = FALSE)
  return(result)
}
