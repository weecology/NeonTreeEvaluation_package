context("Check the location of the annotations")
test_that("Load ground truth",{
  ground_truth<-load_ground_truth("BLAN_009",show=TRUE)
  expect_s4_class(ground_truth,"SpatialPolygonsDataFrame")
})

