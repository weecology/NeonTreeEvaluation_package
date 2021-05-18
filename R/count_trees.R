#' Internal function for counting trees for evaluate_field_stems.R
#' @noRd

count_trees<-function(field_data,spdf,image_name, show=F){

  #Find canopy models
  CHM_images<-list_chm()

  #Load plots
  plot_name<-as.character(unique(field_data$plotID))

  #Does the point have positive height in the LiDAR?
  CHM_path<-CHM_images[stringr::str_detect(CHM_images,image_name)]

  if(length(CHM_path)==0){warning(paste("No CHM image found for plot name:",image_name))}

  chm<-raster::raster(CHM_path)
  field_data$CHM_height<-raster::extract(chm,field_data)
  field_data_filter<-field_data %>% filter(CHM_height>3)
  if(nrow(field_data_filter)==0){return(data.frame(rs=NA,field=NA))}

  #Get prediction centroid
  spdf<-sf::st_as_sf(spdf)
  sf::st_agr(spdf) = "constant"
  prediction_centroids<-sf::st_centroid(spdf)

  e<-raster::extent(field_data_filter)

  #buffer extent by 3m
  e@xmin<-e@xmin -1
  e@ymin <- e@ymin - 1
  e@xmax <- e@xmax +1
  e@ymax<-e@ymax + 1

  #Crop
  centroids_to_include = sf::st_crop(prediction_centroids,e)

  if(nrow(centroids_to_include) == 0){
    warning("No overlapping points between predictions and field stems, check project argument to ensure spatial data is being correctly interpreted.")
    return(NULL)
  }
  cropped_prediction<-spdf[spdf$crown_id %in% centroids_to_include$crown_id,]
  if(nrow(cropped_prediction)==0){return(NULL)}

  #View
  if(show){
    rgb_images<-list_rgb()
    rgb_path<-rgb_images[stringr::str_detect(rgb_images,as.character(plot_name))]
    r<-raster::stack(rgb_path)
    raster::plotRGB(r)
    plot(sf::st_geometry(field_data_filter),add=T,col=field_data$subplotID,pch=16,cex=1)
    plot(sf::st_geometry(cropped_prediction),add=T)
  }

  field_count = field_data_filter %>% as.data.frame() %>% group_by(individualID) %>% arrange(desc(eventID)) %>% slice(1) %>% nrow(.)
  data.frame(rs=nrow(cropped_prediction),field=field_count)
}
