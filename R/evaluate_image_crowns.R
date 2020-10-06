#' Compute evaluation metrics for the hand-annotated images
#'
#' Submit a set of predictions to be evaluated against individual tree crowns annotated by an observer looking at the imagery.
#' @inheritParams image_crowns
#' @param project Whether to submission coordinates need to be projected in UTM geographic coordinates. If a polygon shp submission is provided, project will be set to True.
#' @param summarize Whether to compute summary statistics (TRUE) or return raw matching data (False), see \code{summary_statistics}
#' @details
#' The NeonTreeEvaluation benchmark contains evaluation data from 22 sites from the National Ecological Observation Network.
#' Crowns were annotated by looking at a combination of the RGB image, a LiDAR-derived canopy height model, hyperspectral reflectance and, where available, field collected data on stem location.
#' This function is a wrapper for \code{evaluate_plot}. It first looks which plot_names match the benchmark dataset. Plots with no predictions, or which are not included, are ignored.
#' @return If summarize is True, a set of summary measures from \code{summary_statistics} for the overall score, the entire site score, and the per-plot score.
#' If False, a dataframe with the intersection-over-union scores for each prediction.
#' @examples
#' #' data("submission")
#' df<-submission %>% dplyr::filter(plot_name %in% c("SJER_052","TEAK_061","TEAK_057"))
#' results<-evaluate_image_crowns(submission = df,project = FALSE, show=TRUE, summarize = TRUE)
#' @export
#'

evaluate_image_crowns <- function(predictions, project = FALSE, show = TRUE, summarize=FALSE) {
  #Check for data
  check_download()

  #check submission type
  if(!"plot_name" %in% colnames(predictions)){
    stop("column named 'plot_name' is required (.e.g 'MLBS_052') to match images to annotation)")
  }

  results <- predictions %>%
    group_by(plot_name) %>%
    do(image_crowns(., project_boxes = project, show = show))

  if(summarize){
    return(summary_statistics(results,calc_count_error = TRUE))
  } else{
    return(results)
  }
}
