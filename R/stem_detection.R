#' Evaluate predictions against NEON field data
#' @param submission A five column dataframe in the order plot_name, xmin, xmax, ymin, ymax. Each row is a predicted bounding box.
#' @param show Logical. Plot the overlayed annotations for each plot?
#' @param project_boxes Logical. Should the boxes be projected into utm coordinates? This is needed if the box coordinates are given from the image origin (top left is 0,0)
#' @param field_data a csv file with spatial coordinates "easting" and "northing" corresponding to utm locations of each point
#' @details For each plot in the submission, this function will check if there are field collected stem data and score whether each stem is within a predicted tree bounding box
#' @return The average stem recall scores for each image in the submission

stem_detection <- function(submission, project_boxes = FALSE, show = TRUE, field_data = NA) {
  if (!is.na(field_data)) {
    path <- system.file("extdata/field_data.csv", package = "NeonTreeEvaluation")
    field_data <- sf::st_read(path, options = c("X_POSSIBLE_NAMES=easting", "Y_POSSIBLE_NAMES=northing"))
  }
  results <- submission %>%
    group_by(plot_name) %>%
    do(evaluate_stem(., project_boxes = project_boxes, show = show, stem_dat = field_data))
}
