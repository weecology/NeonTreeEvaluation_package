library(dplyr)
context("evaluate_field_stems")
test_that("Check wrapper of unprojected submission against field stems produces predictions ", {
  result<-submission %>% filter(plot_name == "JERC_049") %>%
    evaluate_field_stems(.,project=T, show=F, summarize = T)
  expect_equal(length(result),3)
  })

test_that("evaluate_field_stems raise error on mismatch", {
  df<- submission %>% filter(plot_name == "TEAK_055")
  expect_error(evaluate_field_stems(df,project=T))
})
