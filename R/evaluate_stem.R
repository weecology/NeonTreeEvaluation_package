#' Evaluate predictions against NEON field data
#' @param submission A five column dataframe in the order plot_name, xmin, xmax, ymin, ymax. Each row is a predicted bounding box.
#' @param show Logical. Plot the overlayed annotations for each plot?
#' @param project_boxes Logical. Should the boxes be projected into utm coordinates? This is needed if the box coordinates are given from the image origin (top left is 0,0)
#' @param stem_dat Object. A sf object with utm coordinates
#' @details For each plot in the submission, this function will check if there are field collected stem data and score whether each stem is within a predicted tree bounding box
#' @return The recall scores for each image
#' @export
evaluate_stem<-function(plot_prediction,stem_dat, project_boxes=FALSE, show=T){

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

  #Blan has a zone error
  if(str_detect(unique(plot_data$siteID),"BLAN")){
    sf::st_crs(plot_data)<-32618
    } else{
    sf::st_crs(plot_data)<-raster::crs(rgb)
    plot_data<-st_transform(plot_data,rgb@crs)
  }

  if(show){
    raster::plotRGB(rgb)
    plot(sf::st_geometry(predictions),add=T,col=NA)
    plot(plot_data,add=T,cex=1,pch=16)
  }

  #select order
  tree_in_prediction <- sf::st_within(x=plot_data,y=predictions,sparse = T)

  #only get unique matches, cannot double count.
  stem_recall<-length(unique(tree_in_prediction))/nrow(plot_data)

  return(data.frame(stem_recall))
}
