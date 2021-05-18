library(dplyr)
library(raster)
context("sf_to_spatial_polygons")
test_that("produces a clean submission document ", {
  predictions<-submission_polygons %>% filter(plot_name=="SJER_052_2018")
  rgb<-raster::stack(get_data("SJER_052_2018","rgb"))
  projected_polygons <- sf_to_spatial_polygons(predictions,rgb = rgb)
  expect_equal(colnames(projected_polygons),c("xmin","ymin","xmax","ymax","score","label","plot_name","L2","geometry","crown_id"))
})
