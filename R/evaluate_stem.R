#' Evaluate predictions against NEON field data
#' @param submission A five column dataframe in the order plot_name, xmin, xmax, ymin, ymax. Each row is a predicted bounding box.
#' @param show Logical. Plot the overlayed annotations for each plot?
#' @param project_boxes Logical. Should the boxes be projected into utm coordinates? This is needed if the box coordinates are given from the image origin (top left is 0,0)
#' @details For each plot in the submission, this function will check if there are field collected stem data and score whether each stem is within a predicted tree bounding box
#' @return The recall scores for each image
#'
evaluate_stem<-function(plot_prediction,project_boxes=FALSE, show=T, stem_dat=NULL){

  #If user hasn't read in stem dat, read it from package contents, faster to preload it.
  if(!exists("stem_dat")){
    #read field data as simple feature
    path <- system.file("extdata/field_data.csv",package = "NeonTreeEvaluation")
    stem_dat<-sf::st_read(path, options=c("X_POSSIBLE_NAMES=easting","Y_POSSIBLE_NAMES=northing"))
  }

  #point in poylgon
  plot_data<-stem_dat %>% filter(plotID %in% unique(plot_prediction$plot_name)) %>%  group_by(individualID) %>% arrange(eventID) %>% slice(1) %>% filter(!is.na(easting))

  if(nrow(plot_data)==0){
    return(data.frame(stem_recall=NA))
  }

  #read image to get CRS
  rgb_path<-get_data(unique(plot_prediction$plot_name),"rgb")
  if(file.exists(rgb_path)){
    rgb<-raster::stack(rgb_path)
  } else {
    return(data.frame(stem_recall=NA))
  }

  #Create predictions spatial object
  predictions <- boxes_to_spatial_polygons(plot_prediction,rgb,project_boxes = project_boxes)
  predictions<-sf::st_as_sf(predictions)

  #unique by individual ID
  sf::st_crs(plot_data)<-raster::crs(rgb)

  if(show){
    raster::plotRGB(rgb)
    plot(sf::st_geometry(predictions),add=T,col=NA)
    plot(plot_data,add=T,cex=2,pch=16)
  }

  #select order
  tree_in_prediction <- sf::st_within(x=plot_data,y=predictions,sparse = T)

  #only get unique matches, cannot double count.
  stem_recall<-length(unique(tree_in_prediction))/nrow(plot_data)

  return(data.frame(stem_recall))
}
