#' Summary statistics for benchmark evaluation
#'
#' \code{summary_statistics} returns a helpful summary of a set of plot evaluations
#' @param results A dataframe returned from \code{evaluate_plot}
#' @param method "all" for averaging recall across images, or "site" to average per geographic site
#' @param plot_result generate a ggplot of results
#' @return Summary recall and precision
#' @export
#'
summary_statistics<-function(results, method="all",plot_result=T, threshold=0.5){
  #Summary precision and recall across all images
  if(method=="all"){
    true_positives = results$IoU > threshold

    #number of ground truth
    n<-results %>% group_by(plot_name) %>% distinct(total_ground, total_prediction)
    total_ground = sum(n$total_ground)
    total_prediction = sum(n$total_prediction)
    recall <- round(sum(true_positives,na.rm=T)/total_ground,3)
    precision <- round(sum(true_positives,na.rm=T)/total_prediction,3)

    statistic <- data.frame(recall, precision)
  }

  if(method=="site"){
    #Infer site
    results<-results %>% mutate(Site=str_match(plot_name,"(\\w+)_")[,2])

    #Two awkward sites do to naming structure.
    results[stringr::str_detect(results$plot_name,"2018_SJER"),"Site"]<-"SJER"
    results[stringr::str_detect(results$plot_name,"2018_TEAK"),"Site"]<-"TEAK"

    #calculate statitics by site
    #number of ground truth by site
    PR<-function(results){
      true_positives = results$IoU > threshold

      n<-results %>% group_by(plot_name) %>% distinct(total_ground, total_prediction)
      total_ground = sum(n$total_ground)
      total_prediction = sum(n$total_prediction)
      recall <- round(sum(true_positives,na.rm=T)/total_ground,3)
      precision <- round(sum(true_positives,na.rm=T)/total_prediction,3)
      statistic <-  data.frame(recall, precision)
      return(statistic)
    }

    statistic<-results %>% group_by(Site) %>% do(PR(.))

    if(plot_result){
      df<-reshape2::melt(statistic,id.vars=c("Site"))
      p<-ggplot2::ggplot(df,ggplot2::aes(y=value,x=Site)) + ggplot2::geom_boxplot()  + ggplot2::coord_flip() + ggplot2::facet_wrap(~variable)
      print(p)
    }
  }
  return(statistic)
}
