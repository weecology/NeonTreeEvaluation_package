context("Check the location of the annotations")
test_that("Load ground truth", {
  ground_truth <- load_ground_truth("SJER_052", show = FALSE)
  expect_s3_class(ground_truth, "sf")
})
