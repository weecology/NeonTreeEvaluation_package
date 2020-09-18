#test count_trees functions for a sample set
library(dplyr)
library(raster)
context("Projected polygons and field stems produces predictions")
test_that("count_trees produces valid RS predictions", {
  field<-field %>% group_by(individualID) %>% arrange(desc(eventID)) %>% slice(1) %>% filter(plotID=="TEAK_057")
  plots_to_evaluate<-unique(as.character(submission$plot_name[submission$plot_name %in% field$plotID]))
  predictions = submission %>% filter(plot_name %in% plots_to_evaluate)

  #Project
  rgb_images<-list_rgb()
  rgb_path<-rgb_images[stringr::str_detect(rgb_images,"TEAK_057")]
  r<-raster::stack(rgb_path)
  spdf<-boxes_to_spatial_polygons(predictions,r,project_boxes = T)

  field_data<-field %>% droplevels() %>% filter(plotID == "TEAK_057") %>%
    sf::st_as_sf(.,coords=c("itcEasting","itcNorthing"),crs=raster::projection(spdf))

  #Run
  result <- count_trees(spdf=spdf,field_data=field_data)
  expect_gt(sum(result$rs),0)
})
