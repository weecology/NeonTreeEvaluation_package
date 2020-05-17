context("Check image crown evaluation")
library(dplyr)

test_that("Image crown summaries", {
  data("submission")
  results <- submission %>%
    filter(plot_name %in% sample(plot_name, 1)) %>% evaluate_image_crowns(.,summarize = T,project_boxes = T)

  #Overall
  expect_equal(dim(results[["overall"]]),c(1,2))
  expect_lt(results[["overall"]]$precision,1)

  #By Site
  expect_equal(colnames(results[["by_site"]]),c("Site","recall","precision"))

  #plot_level
  expect_equal(colnames(results[["plot_level"]]),c("plot_name","submission","ground_truth"))

})