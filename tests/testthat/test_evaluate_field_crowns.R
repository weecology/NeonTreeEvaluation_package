context("Check field crown evaluation")
library(dplyr)

test_that("Field crown summaries produce precision and recall", {
  results <- submission %>%
    filter(plot_name %in% "OSBS_95_competition") %>%
    evaluate_field_crowns(.,summarize = T,project = T)
  expect_equal(length(results),3)
})

test_that("Field crown csv and shp produce same score", {
  results_csv <- submission %>%
    filter(plot_name %in% "OSBS_95_competition") %>%
    evaluate_field_crowns(.,summarize = T,project = T)

  #Drop column to ensure it
  results_shp <- submission_polygons %>% select(-xmin) %>%
    filter(plot_name %in% "OSBS_95_competition") %>%
    evaluate_field_crowns(.,summarize = T,project = T)

  expect_equal(results_csv[["overall"]],results_shp[["overall"]])
})
