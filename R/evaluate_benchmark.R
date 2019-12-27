#' Evaluate submission for all plots
#' \code{summary_statistics} returns a helpful summary of a set of plot evaluations
#' @inheritParams evaluate_plot
#' @details
#' This function first looks which plot_names match the benchmark dataset. Plots with no predictions, or which are not included, are ignored.
#' @return A raster with the canopy height estimated for each grid cell.
#' @export
#'

evaluate_benchmark<-function(submission,project_boxes=FALSE, show=T,compute_PR=F){
  results<-submission %>% group_by(plot_name)  %>% do(evaluate_plot(.,project_boxes=project_boxes,show=show,compute_PR=compute_PR))
  return(results)
}
