#' Precision and recall for a set of prediction results
#'
#' \code{PR} is an internal function not called by the user for summary statistics
#' @param results A dataframe returned from \code{evaluate_plot}
#' @return Summary recall and precision

PR<-function(results,threshold){
  true_positives = results$IoU > threshold

  n<-results %>% group_by(plot_name) %>% distinct(total_ground, total_prediction)
  total_ground = sum(n$total_ground)
  total_prediction = sum(n$total_prediction)
  recall <- round(sum(true_positives,na.rm=T)/total_ground,3)
  precision <- round(sum(true_positives,na.rm=T)/total_prediction,3)
  statistic <-  data.frame(recall, precision)
  return(statistic)
}
