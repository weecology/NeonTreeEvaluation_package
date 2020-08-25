library(testthat)

# Assert that same data files exist
expect_true(file.exists(get_data("SJER_052", "rgb")))
expect_true(file.exists(get_data("SJER_052", "lidar")))
expect_true(file.exists(get_data("SJER_052", "hyperspectral")))
expect_true(file.exists(get_data("SJER_052", "annotations")))

# get data error on bad type arguments
expect_error(get_data("SJER_052", "RGB"))

#Make sure annotations are list
expect_equal(length(list_annotations()), 212)

