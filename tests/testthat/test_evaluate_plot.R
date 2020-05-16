context("Check plot evaluation")
library(dplyr)

test_that("eval_plot creates results", {
  data("submission")
  results <- submission %>%
    filter(plot_name %in% sample(plot_name, 1)) %>%
    group_by(plot_name) %>%
    do(evaluate_plot(., show = FALSE))
})
