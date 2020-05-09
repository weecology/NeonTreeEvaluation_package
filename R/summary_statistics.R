#' Summary statistics for evaluated crowns
#'
#' \code{summary_statistics} returns a standardized summary of plot evaluations. The mean recall and precision can be calculated either for the entire dataset, or for each of the 22 geographic sites.
#' @param results A data frame of matched predictions and ground truth returned from \code{evaluate_plot}
#' @param by_site Logical. Should average recall and precision be calculated for each geographic site seperately? Defaults to FALSE, such that a single summary is returned for all sites.
#' @param plot_result Logical. Generate a ggplot of results as a side effect?
#' @param threshold Float. Intersection-over-union threshold to consider a prediction a true positive.
#' @return A data frame of averaged recall and precision scores
#' @export

summary_statistics<-function(results, by_site=FALSE,plot_result=T, threshold=0.5){
  #Summary precision and recalls across all images
  if(!by_site){
    true_positives = results$IoU > threshold

    #number of ground truth
    statistic<-results %>% group_by(plot_name) %>% do(PR(.,threshold=threshold)) %>% ungroup() %>% summarize(precision=mean(precision),recall=mean(recall))

  } else{
    #Infer site
    results<-results %>% mutate(Site=str_match(plot_name,"(\\w+)_")[,2])

    #Two awkward sites do to naming structure.
    results[stringr::str_detect(results$plot_name,"2018_SJER"),"Site"]<-"SJER"
    results[stringr::str_detect(results$plot_name,"2018_TEAK"),"Site"]<-"TEAK"

    #number of ground truth by site
    statistic<-results %>% group_by(Site) %>% do(PR(.,threshold=threshold))

    if(plot_result){
      df<-reshape2::melt(statistic,id.vars=c("Site"))
      p<-ggplot2::ggplot(df,ggplot2::aes(y=value,x=Site)) + ggplot2::geom_boxplot()  + ggplot2::coord_flip() + ggplot2::facet_wrap(~variable)
      print(p)
    }
  }
  return(statistic)
}
