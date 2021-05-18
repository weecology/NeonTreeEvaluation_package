library(testthat)
test_that("Check test data exists",{
  # Assert that same data files exist
  expect_true(file.exists(get_data("SJER_052_2018", "rgb")))
  expect_true(file.exists(get_data("SJER_052_2018", "lidar")))
  expect_true(file.exists(get_data("SJER_052_2018", "hyperspectral")))
  expect_true(file.exists(get_data("SJER_052_2018", "annotations")))

  # get data error on bad type arguments
  expect_error(get_data("SJER_052_2018", "RGB"))
})


