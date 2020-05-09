#' Read tree annotations for a NEON site from a set of XML files
#'
#' @param siteID NEON site abbreviation (e.g. "HARV")
#' @return a dataframe of tree annotations in the format xmin, xmax, ymin, ymax
#'
readTreeXML <- function(siteID) {
  path <- paste(system.file("extdata", "annotations/", package = "NeonTreeEvaluation"))
  f <- list.files(path, pattern = siteID, full.names = T, recursive = T)
  dat <- dplyr::bind_rows(lapply(f, xml_parse))
  return(dat)
}
