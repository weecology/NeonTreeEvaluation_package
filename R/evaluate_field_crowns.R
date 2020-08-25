#' Compute intersection-over-union scores from the field collected crowns
#'
#' \code{evaluate_field_crowns} implements the matching and scoring algorithm on crowns that were drawn on a tablet while physically standing in the field.
#' @details For details on the protocol for field-based crown delineation see Graves et al. (2018). see \code{field_crowns}
#' @references Graves S, Gearhart J, Caughlin TT, Bohlman S. 2018. A digital mapping method for linking high-resolution remote sensing images to individual tree crowns. PeerJ Preprints 6:e27182v1 https://doi.org/10.7287/peerj.preprints.27182v1
#' @inheritParams evaluate_plot
#' @return A data frame with the crown ID matched to the prediction ID.
#' @examples
#'
#' @export

evaluate_field_crowns <- function(submission,summarize=T,project = FALSE){

  #Make sure data has been downloaded
  check_download()

  field_crown_plots <- list_field_crowns()

  plotnames <- get_plotnames(field_crown_plots)

  results<-submission %>% filter(plot_name %in% plotnames) %>% group_by(plot_name) %>% do(evaluate_plot(., project_boxes=project))

  if(summarize){
    return(summary_statistics(results,calc_plot_level=T))
  } else{
    return(results)
  }
}

#split fullpaths into plot names
get_plotnames<-function(field_crown_plots){
  basename<-stringr::str_match(field_crown_plots,"RGB/(\\w+).tif")[,2]
  return(basename)
}
