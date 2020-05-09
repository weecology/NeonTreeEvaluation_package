#' Parse crown annotations from an Pascal VOC XML file
#' @details
#' This utility function creates a dataframe from xml annotations from RectLabel or Labelme exported as the standard pascal voc format for object detection. This function is used for the evaluation of the image annotations and is not often called by users.
#' @param path Filename of the .xml file.
#' @return A dataframe of bounding box annotations in the format xmin, xmax, ymin, ymax.
#' @examples
#' xml<-get_data("SJER_052","annotations")
#' xml_parse(xml)
#' @export
#' @import xml2
#'
#Parse xml file to dataframe
xml_parse<-function(path){
  pg <- read_xml(path)

  # get all the <record>s
  recs <- xml_find_all(pg, "//name")
  names <- trimws(xml_text(recs))

  recs <- xml_find_all(pg, "//xmin")

  # extract and clean all the columns
  xmin <- trimws(xml_text(recs))

  # get all the <record>s
  recs <- xml_find_all(pg, "//ymin")

  # extract and clean all the columns
  ymin <- trimws(xml_text(recs))

  # get all the <record>s
  recs <- xml_find_all(pg, "//ymax")

  # extract and clean all the columns
  ymax <- trimws(xml_text(recs))

  # get all the <record>s
  recs <- xml_find_all(pg, "//xmax")

  # extract and clean all the columns
  xmax <- trimws(xml_text(recs))

  recs <- xml_find_all(pg, "//filename")
  filename <- trimws(xml_text(recs))

  df<-data.frame(filename=filename,xmin=as.numeric(xmin),xmax=as.numeric(xmax),ymin=as.numeric(ymin),ymax=as.numeric(ymax),name=names)

  #characters not factors
  df$filename<-as.character(df$filename)
  df$name<-as.character(df$name)

  return(df)
}
