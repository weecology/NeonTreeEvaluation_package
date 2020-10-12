context("Check loading of the field crowns yields a spatial object")
test_that("Load ground truth", {
  n <- list_field_crowns()
  expect_gt(length(n),0)
})
