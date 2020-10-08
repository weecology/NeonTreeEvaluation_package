#' Compute precision and recall statistics between predicted tree boxes and ground truth data
#' @details The numeric identity of the crown is stored in a column named crown_id. An error will be raised if this column does not exist.
#' @param ground_truth A SpatialPolygonDataFrame of ground truth polygons.
#' @param predictions A SpatialPolygonDataFrame of prediction polygons.
#' @param threshold The intersection-over-union threshold for a prediction overlap with a ground truth to be considered a true positive.
#' @param summarize Logical. If true, return the precision and recall for this dataset, if false, return a data frame of matched crowns and the IoU overlap with ground truth.
#' @return The recall and precision scores for the plot.
#' @export
#'
compute_precision_recall <- function(ground_truth, predictions, threshold = 0.4, summarize = TRUE) {

  # check for
  if (!"crown_id" %in% colnames(predictions)) {
    stop("Crown IDs need to be stored in a numeric index named 'crown_id'")
  }

  assignment <- assign_trees(ground_truth = ground_truth, predictions = predictions)
  statdf <- calc_jaccard(assignment = assignment, ground_truth = ground_truth, predictions = predictions)

  if (summarize) {
    true_positives <- statdf$IoU > threshold
    recall <- round(sum(true_positives, na.rm = TRUE) / nrow(ground_truth), 3)
    precision <- round(sum(true_positives, na.rm = TRUE) / nrow(predictions), 3)
    return(data.frame(recall, precision))
  } else {
    # append total ground truth and prediction for images to take cumulative sum
    statdf$total_ground <- nrow(ground_truth)
    statdf$total_prediction <- nrow(predictions)

    return(statdf)
  }
}
