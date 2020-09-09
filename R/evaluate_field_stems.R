#' Compute evaluation scores for the field collected stem data
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
#' The format of the submission is a csv with 5 columns: plot_name, xmin, ymin, xmax, ymax  follows
#' Each row contains information for one predicted bounding box.
#' The plot column should be named the same as the files in the dataset (e.g. SJER_021), not the path to the file.
#' Not all evaluation data are available for all plots. This function will look for matching plot name and ignore other plots.
#' @param summarize logical If True, report the root mean squared error (RMSE) between the number of field crowns and predicted crowns. If false, return the list of crowns per plot.
#' @return If summarize is True, a set of summary measures from \code{summary_statistics} for the overall score, the entire site score, and the per-plot score.
#' If False, a dataframe with the intersection-over-union scores for each prediction.
#' @examples
#' data("submission")
#' df<-submission %>% filter(plot_name %in% c("SJER_052"))
#' results<-evaluate_field_stems(submission = df,project = F, show=T, summarize = T)
#' @import dplyr ggplot2
#' @md
#' @export

evaluate_field_stems<-function(submission,project=TRUE, show=T, summarize=T){

  if(!"plot_name" %in% colnames(submission)){
    stop("column named 'plot_name' is required (.e.g 'MLBS_052') to match images to annotation)")
  }

  #Check for data
  check_download()
  field = clean_field_data(field)

  site_plots<-field %>% group_by(plotID,individualID) %>%
    summarize(samples=length(unique(eventID))) %>%
    filter(samples>1) %>%
    ungroup() %>%
    mutate(plotID=as.character(plotID))

  results<-list()
  plot_names <- unique(site_plots$plotID)
  plots_to_run<-unique(submission$plot_name[submission$plot_name %in% plot_names])

  if(length(plots_to_run)==0){
    stop("No submitted plot_names with matching field stem data, see list_field_stems()")
  }
  for(x in plots_to_run){
    print(x)
    results[[x]]<-process_plot(x, show=show)
  }
  results<-results[!sapply(results,is.null)]
  results<-bind_rows(results)

  if(summarize){
    df <-list()
    df[["overall"]] <- results %>% summarize(recall=mean(recall))
    df[["by_site"]] <- results %>% group_by(Site=siteID) %>% summarize(recall=mean(recall))
    df[["plot_level"]] <-results
    return(df)
  } else{
    return(results)
  }
}

process_plot<-function(x, show){
  #matching RGB tile
  rgb_images<-list_rgb()
  rgb_path<-rgb_images[stringr::str_detect(rgb_images,x)]
  if(length(rgb_path)==0){return(NULL)}
  r<-raster::stack(rgb_path)

  #Field data, min height threshold is 3.
  field_points<-field %>% filter(plotID==x) %>% sf::st_as_sf(.,coords=c("itcEasting","itcNorthing")) %>% filter(height>3)
  sf::st_crs(field_points)<-raster::crs(r)

  predictions<-submission %>% filter(plot_name==x)
  if(nrow(predictions)==0){
    warning(paste("No predictions made for plot",x))
    return(NULL)
    }

  spatial_boxes<- predictions %>%
    NeonTreeEvaluation::boxes_to_spatial_polygons(.,r) %>%
    sf::st_as_sf() %>%
    mutate(height=predictions$height, score=predictions$score)

  #Filter the field data for erroneous temporal connections, the CHM must have positive heights, see OSBS_022, can use as an example of all sorts of challenges.
  CHM_images <- list_chm()
  CHM_path <- CHM_images[stringr::str_detect(CHM_images,x)]

  if(length(CHM_path)==0){
    warning(paste("No LiDAR data found made for plot",x))
    return(NULL)}

  chm <- raster::raster(CHM_path)

  #Thresholds
  field_points$CHM_height <- raster::extract(chm,field_points)

  #Could it be seen?
  field_points<-field_points %>%
    filter(abs(CHM_height-height)<4)

  #Min height based on the predictions
  #field_points<-field_points[field_points$height > quantile(spatial_boxes$height,0.01),]
  unique_locations<-field_points %>%
    distinct(individualID,.keep_all = T)

  joined <- sf::st_join(unique_locations, spatial_boxes)
  joined <- joined %>% filter(!is.na(crown_id)) %>%
    group_by(crown_id) %>% slice(1)

  missing <- unique_locations %>% filter(!uid %in% joined$uid)

  if(show){
    raster::plotRGB(r)
    plot(sf::st_geometry(spatial_boxes),add=T)
    plot(sf::st_geometry(joined),add=T,col="red",pch=20)

    #Missing
    plot(sf::st_geometry(missing),add=T,col="blue",pch=20)
  }

  #Stem recall rate
  tree_in_prediction <-unique_locations  %>%
    sf::st_intersects(x=.,y=spatial_boxes)

  #Which match, do not allow multiples to double count.
  matches<-lengths(tree_in_prediction)
  matches[matches>1]<-1

  #unique matches
  joined_df<-sf::st_join(spatial_boxes,unique_locations)
  single_matches<-joined_df %>%
    group_by(crown_id) %>%
    filter(height == max(height))

  single_recall<-nrow(single_matches)/nrow(unique_locations)

  #Create point matches between data and predictions
  matched_df<-matched_pairs(spatial_boxes, field_points) %>%
    mutate(plot_name=x)

  if(nrow(matched_df)>0){
    siteID=unique(matched_df$siteID)
    result<-data.frame(siteID=siteID,plot_name=x,recall=single_recall)
    return(result)
  } else{
    warning(paste("No matching prediction between  data found made for plot",x))
    return(NULL)
  }
}

clean_field_data<-function(field){
  field$area<-field$maxCrownDiameter*field$ninetyCrownDiameter
  field<-field %>%  filter(!is.na(itcEasting),!stringr::str_detect(eventID,"2014"),growthForm %in% c("single bole tree","multi-bole tree","small tree","sapling"),stemDiameter>15) %>%
    droplevels() %>%
    filter(height>3|is.na(height))

  #Limit difference in heights
  to_remove<-field %>% group_by(individualID) %>%
    summarize(mean=mean(height),sum_difference = abs(sum(diff(height)))) %>%
    filter(sum_difference > 8)
  field<-field %>%
    filter(!individualID %in% to_remove$individualID)
}

matched_pairs<-function(spatial_boxes,field_points){

  #Spatial join
  possible_matches<-sf::st_join(spatial_boxes,field_points,left=FALSE)

  #If there are heights, take the tallest height
  tallest_points<-possible_matches %>%
    group_by(crown_id) %>%
    mutate(height_diff= CHM_height - height) %>%
    arrange(height_diff) %>% slice(1)  %>%
    as.data.frame() %>%
    dplyr::select(crown_id, individualID)

  matched_height<-possible_matches %>% inner_join(tallest_points)

  return(matched_height)
}


