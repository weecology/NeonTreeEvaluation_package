context("Check conversion of submission dataframe to polygon objects")
test_that("dataframe to polygons", {

  xml_path <-get_data("SJER_052","annotations")
  df <- xml_parse(xml_path)

  # load rgb data
  rgb <- raster::stack(get_data("SJER_052","rgb"))

  # Check raster
  expect_s4_class(rgb, "RasterStack")

  ground_truth <- boxes_to_spatial_polygons(df, rgb)
  # correct size
  expect_equal(dim(ground_truth)[1], 9)
})
