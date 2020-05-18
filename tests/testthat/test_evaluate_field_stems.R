library(dplyr)
context("Check wrapper of unprojected submission against field stems ")
test_that("evaluate_field_stems", {
  data("submission")
  expect_equal(dim(submission),c(5927,5))

  result<-submission %>% filter(stringr::str_detect(plot_name,"HARV")) %>%
    evaluate_field_stems(.,project=T)

  expect_equal(colnames(result),c("plot_name","submission","field"))
  expect_is(result$submission,"integer")
  })
