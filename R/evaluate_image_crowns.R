#' Compute evaluation metrics for the hand-annotated images
#' This is the main function in the package. Submit a set of predictions to be evaluated against the image-annotated ground truth.
#' @inheritParams evaluate_plot
#' @param summarize Whether to compute summary statistics (TRUE) or return raw matching data (False), see \code{summary_statistics}
#' @details
#' The NeonTreeEvaluation benchmark contains evaluation data from 22 sites from the National Ecological Observation Network. Crowns were annotated by looking at a combination of the RGB image, a LiDAR-derived canopy height model, hyperspectral reflectance and, where available, field collected data on stem location. For evaluation of the field-collected crowns for 2 sites, see \code{evaluate_field_crowns}. The field-collected crowns were drawn by a tablet into the field, while the image crowns were drawn by looking at multiple sensor data on a screen.
#' This function is a wrapper for \code{evaluate_plot}. It first looks which plot_names match the benchmark dataset. Plots with no predictions, or which are not included, are ignored.
#' @return If summarize is True, a set of summary measures from \code{summary_statistics} If False, a dataframe with the intersection-over-union scores for each prediction.
#' @export
#'

evaluate_image_crowns <- function(submission, project_boxes = FALSE, show = TRUE, summarize=F) {

  #Check for data
  check_download()

  results <- submission %>%
    group_by(plot_name) %>%
    do(evaluate_plot(., project_boxes = project_boxes, show = show))

  if(summarize){
    return(summary_statistics(results))
  } else{
    return(results)
  }
}
