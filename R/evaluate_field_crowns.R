#' Compute intersection-over-union scores from the field collected crowns
#'
#' \code{evaluate_field_crowns} implements the matching and scoring algorithm on crowns that were drawn on a tablet while physically standing in the field.
#' @details For details on the protocol for field-based crown delineation see Graves et al. (2018).
#' @references Graves S, Gearhart J, Caughlin TT, Bohlman S. 2018. A digital mapping method for linking high-resolution remote sensing images to individual tree crowns. PeerJ Preprints 6:e27182v1 https://doi.org/10.7287/peerj.preprints.27182v1
#' @param submission
#' @inheritParams evaluate_plot
#' @return A data frame with the crown ID matched to the prediction ID.
#' @examples
#'
#' @export

evaluate_field_crowns <- function(submission) {

  check_download()

  #field_crown_plots <- list_field_crown_plots()

  #submission %>% field_crown_plots

  #field_crown_plots
  #for(x in ){

  #}

 }
