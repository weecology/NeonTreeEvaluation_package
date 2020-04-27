#' Evaluate submission for all plots
#' @inheritParams evaluate_plot
#' @details
#' This function is a wrapper for \code{evaluate_plot}. It first looks which plot_names match the benchmark dataset. Plots with no predictions, or which are not included, are ignored.
#' @return If compute_PR is True, a dataframe of precision-recall scores or each plot. If False, a dataframe with the IoU scores for each prediction for all plots.
#' @export
#'

evaluate_benchmark<-function(submission,project_boxes=FALSE, show=T,compute_PR=F){
  results<-submission %>% group_by(plot_name)  %>% do(evaluate_plot(.,project_boxes=project_boxes,show=show,compute_PR=compute_PR))
  return(results)
}
