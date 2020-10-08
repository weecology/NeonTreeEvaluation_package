#' Compute evaluation statistics for one plot of field-annotated crowns
#'
#' @param x submission csv table or polygon shp file
#' @param show Logical. Plot the overlayed annotations for each plot?
#' @param project_boxes Logical. Should the boxes be projected into utm coordinates? This is needed if the box coordinates are given from the image origin (top left is 0,0)
#' @param compute_PR Logical. Should the average precision and recall be computed?
#' @param use_polygon. Logical. For field-annotated crowns, use polygons for evaluation rather than bounding boxes.
#' @return If compute_PR=T, the recall and precision scores for the plot, if False, the intersection-over-union scores for each prediction.
#' @details The format of the submission is either a csv with 5 columns: plot_name, xmin, ymin, xmax, ymax with #' Each row contains information for one predicted bounding box or a shp file of unprojected polygons.
#' The plot column should be named the same as the files in the dataset (e.g. SJER_021), not the path to the file (e.g. /path/to/SJER_021.tif).
#' @export
#'
field_crowns <- function(x, show = TRUE, project_boxes = TRUE, use_polygon=FALSE) {
  # find ground truth file
  plot_name <- unique(x$plot_name)
  print(plot_name)

  if (!length(plot_name) == 1) {
    stop(paste("There are", length(plot_name), "plot names. Please submit a single plot of annotations to this function, to run all plots in a x see evaluate_field_crowns."))
  }

  ground_truth <- load_field_crown(plot_name, show = FALSE, use_polygon=use_polygon)
  ground_truth$crown_id<-1:nrow(ground_truth)

  # Read RGB image as projected raster
  siteID <- stringr::str_match(plot_name, "(\\w+)_\\d+_")[, 2]
  path_to_rgb <-get_data(plot_name, "rgb")
  rgb <- raster::stack(path_to_rgb)

  # project boxes
  #check sf polygon or csv file
  is_polygons = any(class(x) == "sf")
  #If is_polygons, project must be true
  if(is_polygons){
    predictions <- sf_to_spatial_polygons(x, rgb)
  } else{
    predictions <- boxes_to_spatial_polygons(x, rgb, project_boxes = project_boxes)
  }

  if(show){
    raster::plotRGB(rgb)
    plot(st_geometry(ground_truth), border = "black", add = TRUE)
    plot(st_geometry(predictions), border = "red", add = TRUE)
  }

  # Create spatial polygons objects
  result <- compute_precision_recall(ground_truth, predictions, summarize = FALSE,threshold = 0.4)
  return(result)
}
