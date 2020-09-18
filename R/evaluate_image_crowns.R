#' Compute evaluation metrics for the hand-annotated images
#'
#' Submit a set of predictions to be evaluated against individual tree crowns annotated by an observer looking at the imagery.
#' @inheritParams image_crowns
#' @param summarize Whether to compute summary statistics (TRUE) or return raw matching data (False), see \code{summary_statistics}
#' @details
#' The NeonTreeEvaluation benchmark contains evaluation data from 22 sites from the National Ecological Observation Network.
#' Crowns were annotated by looking at a combination of the RGB image, a LiDAR-derived canopy height model, hyperspectral reflectance and, where available, field collected data on stem location.
#' This function is a wrapper for \code{evaluate_plot}. It first looks which plot_names match the benchmark dataset. Plots with no predictions, or which are not included, are ignored.
#' @return If summarize is True, a set of summary measures from \code{summary_statistics} for the overall score, the entire site score, and the per-plot score.
#' If False, a dataframe with the intersection-over-union scores for each prediction.
#' @examples
#' #' data("submission")
#' df<-submission %>% filter(plot_name %in% c("SJER_052","TEAK_061","TEAK_057"))
#' results<-evaluate_image_crowns(submission = df,project = F, show=T, summarize = T)
#' @export
#'

evaluate_image_crowns <- function(submission, project = FALSE, show = TRUE, summarize=F) {
  #Check for data
  check_download()

  #check submission
  if(!"plot_name" %in% colnames(submission)){
    stop("column named 'plot_name' is required (.e.g 'MLBS_052') to match images to annotation)")
  }

  results <- submission %>%
    group_by(plot_name) %>%
    do(image_crowns(., project_boxes = project, show = show))

  if(summarize){
    return(summary_statistics(results,calc_count_error = T))
  } else{
    return(results)
  }
}
