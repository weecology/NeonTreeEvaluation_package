context("Check field crown evaluation")
library(dplyr)

test_that("Field crown summaries produce precision and recall", {
  data("submission")
  results <- submission %>%
    filter(plot_name %in% "OSBS_95_competition") %>%
    evaluate_field_crowns(.,summarize = T,project = T)
  expect_equal(length(results),3)
})
