library(dplyr)
context("Check wrapper of unprojected submission against field stems produces predictions ")
test_that("evaluate_field_stems", {
  data("submission")
  result<-submission %>% filter(plot_name == "MLBS_074") %>%
    evaluate_field_stems(.,project=T, show=F, summarize = T)

  expect_equal(length(result),3)
  })

test_that("evaluate_field_stems raise error on mismatch", {
  data("submission")
  df<- submission %>% filter(plot_name == "TEAK_055")
  expect_error(evaluate_field_stems(df,project=T))
})
