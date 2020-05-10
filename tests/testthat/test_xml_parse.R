context("Check xml parsing of submission document")
test_that("xml parsing creates a dataframe", {
  xml_path<-get_data("SJER_052",type="annotations")
  df <- xml_parse(xml_path)
  expect_equal(dim(df)[1], 9)
  expect_equal(dim(df)[2], 6)
})
