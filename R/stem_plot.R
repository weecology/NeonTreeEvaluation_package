#' Internal function for evaluate_field_stems
#' @noRd
stem_plot<-function(df,field, projectbox=T, show=T){
  #Find plot
  image_name <- as.character(unique(df$plot_name))
  print(image_name)
  #Select image and create spatial polygons
  rgb_images<-list_rgb()
  rgb_path<-rgb_images[stringr::str_detect(rgb_images,image_name)]

  #Check path
  if(length(rgb_path)==0){warning(paste("No RGB image found for plot name:",image_name))}

  #Project into spatial object
  r<-raster::stack(rgb_path)
  spdf<-boxes_to_spatial_polygons(df,r,project_boxes = projectbox)

  #Convert to the most recent year
  plot_name = stringr::str_match(image_name,"(\\w+)_\\d+")[,2]

  #load field data
  field_data<-field %>% droplevels() %>% filter(plotID == plot_name) %>% sf::st_as_sf(.,coords=c("itcEasting","itcNorthing"),crs=raster::projection(spdf))

  #Was the plot completely sampled?
  plotType<-unique(field_data$plotType)
  subplots<-na.omit(unique(field_data$subplotID))

  #If there are non-contigious plots compute subplots separately
  if(plotType=="distributed" & sum(subplots %in% c(41,31,40,32))==4){
    plot_result<- count_trees(field_data,spdf,show=show) %>% mutate(plotID=plot_name)
  } else{
    plot_result<-list()
    for(subplot in subplots){
      projected_subplot<-field_data %>% filter(subplotID==subplot)
      plot_result[[subplot]]<-count_trees(field_data,spdf,image_name=image_name, show=show) %>% mutate(plotID=plot_name,subplot=subplot)
    }
    plot_result<-bind_rows(plot_result)
  }

  return(plot_result)
}
