#' Compute evaluation scores from the field collected stem data
#'
#' \code{evaluate_field_stems} implements the matching and scoring algorithm on field stems that were collected by the NEON Woody Vegetation structure data.
#' @details
#' The following filters were applied to the raw NEON field data (ID) after download. An overstory reference tree must have:
#' * Valid spatial coordinates
#' * A unique height measurement per sampling period. Species double recorded but with different heights were discarded
#' * Sampled in more than one year to verify height measurement
#' * Changes in between year field heights of less than 6m
#' * A minimum height of 3m to match the threshold in the remote sensing workflow.
#' * Be at least within 5m of the canopy as measured by the LiDAR height model extracted at the stem location. The was used to prevent matching with understory trees in the event that overstory trees were eliminated due to failing in one of the above conditions, or not sampled by NEON.
#' @param submission
#' @return A data frame with the number of crown predictions in the sumbitted predictions and the field sampled plots.
#' @import dplyr ggplot2
#' @md
#' @export

evaluate_field_stems<-function(submission,project=TRUE, show=T){

  #Check for data
  check_download()

  result<-list()

  #Load data from package
  data(field)
  rgb_images<-list_rgb()

  #get most recent date for each data point.
  field<-field %>% group_by(individualID) %>% arrange(desc(eventID)) %>% slice(1)

  #A few poor quality subplots
  poor_quality<-data.frame(plotID=c("LENO_069","LENO_062","BART_032"),subplot=c(23,40,23))
  field<-field %>% filter(!(plotID %in% poor_quality$plotID & subplotID %in% poor_quality$subplot))

  ### Stem count ###
  #Which plots to evaluate
  plots_to_evaluate<-unique(as.character(submission$plot_name[submission$plot_name %in% field$plotID]))

  stem_count<-submission %>% filter(plot_name %in% plots_to_evaluate) %>% group_by(plot_name) %>% do(stem_plot(df=.,field=field,projectbox = project,show=show))%>%
    dplyr::ungroup() %>% dplyr::select(plot_name,rs,field) %>% dplyr::rename("submission"="rs")

  if(show){
    p<-ggplot(stem_count,aes(x=field,y=submission)) + geom_point() + stat_smooth(method="lm") + geom_abline(linetype="dashed") + labs(x="NEON Field Stems",y="Predicted Crowns")
    print(p)
  }

  return(stem_count)
}
