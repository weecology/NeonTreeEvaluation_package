#' Summary statistics for evaluated crowns
#'
#' \code{summary_statistics} returns a standardized summary of plot evaluations. The mean recall and precision can be calculated either for the entire dataset, or for each of the 22 geographic sites.
#' @param results A data frame of matched predictions and ground truth returned from \code{evaluate_plot}
#' @param by_site Logical. Should average recall and precision be calculated for each geographic site separately? Defaults to FALSE, such that a single summary is returned for all sites.
#' @param threshold Float. Intersection-over-union threshold to consider a prediction a true positive.
#' @param calc_plot_level Calculate plot-level statistic comparing the total predictions to the total crowns. This only makes sense for the image-annotated crowns, and not the field-annotated crowns.
#' @return A names list of overall mean precision and recall, by site, and plot level summary
#' @export

grand_summary <-function(results, threshold = 0.4){
  # Summary precision and recalls across all images
  true_positives <- results$IoU > threshold

  # number of ground truth
  statistic <- results %>%
    group_by(plot_name) %>%
    do(PR(., threshold = threshold)) %>%
    ungroup() %>%
    summarize(precision = mean(precision), recall = mean(recall))
  return(statistic)
}

#' @title Site summary table for image-evaluated crowns
#' @rdname site_summary
#' @export
site_summary<-function(results, threshold = 0.4){
  # Infer site
  results <- results %>% mutate(Site = stringr::str_match(plot_name, "(\\w+)_")[, 2])

  # Two awkward sites do to naming structure.
  results[stringr::str_detect(results$plot_name, "2018_SJER"), "Site"] <- "SJER"
  results[stringr::str_detect(results$plot_name, "2018_TEAK"), "Site"] <- "TEAK"

  # number of ground truth by site
  statistic <- results %>%
    group_by(Site) %>%
    do(PR(., threshold = threshold))

  return(statistic)
}

plot_level<-function(results,threshold){
  r<-results %>% group_by(plot_name) %>% distinct(total_ground,total_prediction) %>%
    rename("ground_truth"="total_ground","submission"="total_prediction") %>% dplyr::select(plot_name,submission,ground_truth)
  return(r)
  }

count_plot<-function(results){
  # Infer site
  results <- results %>% mutate(Site = stringr::str_match(plot_name, "(\\w+)_")[, 2])

  # Two awkward sites do to naming structure.
  results[stringr::str_detect(results$plot_name, "2018_SJER"), "Site"] <- "SJER"
  results[stringr::str_detect(results$plot_name, "2018_TEAK"), "Site"] <- "TEAK"

  p<-results %>% group_by(plot_name) %>%
    slice(1) %>%
    mutate(error=abs(total_prediction-total_ground)) %>%
    ggplot(.,aes(x=Site,y=error)) + geom_boxplot() + labs(y="|Predicted - Observed Tree Count|") +
    coord_flip()
  return(p)
}

summary_statistics <- function(results, threshold = 0.4, calc_plot_level=T, calc_count_error=F) {
  df<-list()

  df[["overall"]]<-grand_summary(results, threshold)
  df[["by_site"]]<-site_summary(results,threshold)

  if(calc_plot_level){
    df[["plot_level"]]<-plot_level(results,threshold)
  }
  if(calc_count_error){
    df[["count_error"]] <- count_plot(results)
  }

  return(df)
}
