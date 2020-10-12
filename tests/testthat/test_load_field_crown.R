context("Check loading of the field crowns yields a spatial object")
test_that("Load ground truth", {
  ground_truth <- load_field_crown("OSBS_95_competition", show = FALSE)
  expect_s3_class(ground_truth, "sf")
})
