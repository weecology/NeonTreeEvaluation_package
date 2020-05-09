context("Check plot evaluation")
library(dplyr)

test_that("eval_plot creates results", {
  submission <- read.csv(system.file("extdata", "Weinstein2019.csv", package = "NeonTreeEvaluation"))
  results <- submission %>%
    filter(plot_name %in% sample(plot_name, 1)) %>%
    group_by(plot_name) %>%
    do(evaluate_plot(., show = FALSE))
  expect_equal(nrow(results), 1)
  expect_equal(ncol(results), 3)
})
