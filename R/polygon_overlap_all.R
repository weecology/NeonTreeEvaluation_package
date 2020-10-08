#' Find area of overlap among all sets of polygons
#'
#' @param ground_truth A ground truth polygon
#' @param predictions prediction polygons
#' @return A data frame with the crown ID, the prediction ID and the area of overlap.

polygon_overlap_all <- function(ground_truth, predictions) {
  results <- suppressWarnings(sf::st_intersection(ground_truth,predictions))
  results$overlap_area <- as.numeric(sf::st_area(results))
  results <- results %>% as.data.frame() %>%
    mutate(ground_id=crown_id,prediction_id=crown_id.1) %>%
    select(ground_id,prediction_id,overlap_area)

  #pad out the rest of the matrix with zeros of no overlap
  m<-matrix(nrow=nrow(ground_truth),ncol=nrow(predictions))
  m[]=0
  for (x in 1:nrow(results)) {
    row<-results[x,]
    m[row$ground_id,row$prediction_id] <- row$overlap_area
  }
  rownames(m) <- 1:nrow(ground_truth)
  colnames(m) <- 1:nrow(predictions)

  return(m)
}
