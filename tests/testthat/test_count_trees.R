#test count_trees functions for a sample set
library(dplyr)
library(raster)
context("Projected polygons and field stems produces predictions")
test_that("count_trees produces valid RS predictions", {
  field<-field %>% group_by(individualID) %>% arrange(desc(eventID)) %>% slice(1) %>% filter(plotID=="SJER_052")
  predictions = submission %>% filter(plot_name == "SJER_052_2018")

  #Project
  rgb_images<-list_rgb()
  rgb_path<-rgb_images[stringr::str_detect(rgb_images,"SJER_052_2018")]
  r<-raster::stack(rgb_path)
  spdf<-boxes_to_spatial_polygons(predictions,r,project_boxes = T)

  field_data<-field %>% droplevels() %>% filter(plotID == "SJER_052") %>%
    sf::st_as_sf(.,coords=c("itcEasting","itcNorthing"),crs=raster::projection(spdf))

  #Run
  result <- count_trees(spdf=spdf,field_data=field_data, image_name = "SJER_052_2018")
  expect_gt(sum(result$rs),0)
})
