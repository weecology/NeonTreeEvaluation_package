#' Compute evaluation metrics for the field-collected crowns
#'
#' \code{evaluate_field_crowns} implements the matching and scoring algorithm on crowns that were drawn on a tablet while physically standing in the field.
#' @details For details on the protocol for field-based crown delineation see Graves et al. (2018). see \code{field_crowns}
#' Not all evaluation data are available for all plots. This function will look for matching plot name and ignore other plots.
#' @references Graves S, Gearhart J, Caughlin TT, Bohlman S. 2018. A digital mapping method for linking high-resolution remote sensing images to individual tree crowns. PeerJ Preprints 6:e27182v1 https://doi.org/10.7287/peerj.preprints.27182v1
#' @inheritParams field_crowns
#' @param summarize Compute summary statistics for crown recall
#' @param project Whether to project the supplied bounding box coordinates from image coordinates into geographic coordinates (utm QGS84). This is needed for computing recall scores.
#' @return If summarize is True, a set of summary measures from \code{summary_statistics} for the overall score, the entire site score, and the per-plot score.
#' If False, a dataframe with the intersection-over-union scores for each prediction.
#' @examples
#' \donttest{
#' data("submission")
#' df <- submission %>% dplyr::filter(plot_name=="OSBS_95_competition")
#' results <- evaluate_field_crowns(submission = df,project = FALSE, summarize = TRUE)
#' }
#'  @export

evaluate_field_crowns <- function(predictions,summarize=TRUE,show=TRUE,project = FALSE){
  #check x
  if(!"plot_name" %in% colnames(predictions)){
    stop("column named 'plot_name' is required (.e.g 'MLBS_052') to match images to annotation)")
  }

  #Make sure data has been downloaded
  check_download()

  field_crown_plots <- list_field_crowns()
  plotnames<-stringr::str_match(field_crown_plots,"(\\w+).tif")[,2]
  predictions<-predictions %>% dplyr::filter(plot_name %in% plotnames)

  if(nrow(predictions)==0){
    stop("No plot names matching the field crown data, see list_field_crowns for paths to RGB field crown imagery.")
  }
  results <- predictions %>% group_by(plot_name) %>% do(field_crowns(., project_boxes=project, show=show))

  if(summarize){
    return(summary_statistics(results,calc_count_error=FALSE))
  } else{
    return(results)
  }
}
