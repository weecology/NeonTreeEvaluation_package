context("Check conversion of submission dataframe to polygon objects")
test_that("dataframe to polygons",{
  xml_path<-system.file("extdata","annotations/SJER_052.xml",package="NeonTreeEvaluation")
  df<-xml_parse(xml_path)

  #load rgb data
  rgb<-raster::stack(system.file("extdata","evaluation/RGB/SJER_052.tif",package="NeonTreeEvaluation"))

  #Check raster
  expect_s4_class(rgb,"RasterStack")

  ground_truth <- boxes_to_spatial_polygons(df,rgb)
  #is s4 class
  expect_s4_class(ground_truth,"SpatialPolygonsDataFrame")
  #correct size
  expect_equal(dim(ground_truth)[1],9)
})

