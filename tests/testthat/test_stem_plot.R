#test stem_plot functions for a sample set
library(dplyr)
context("Check wrapper of unprojected submission against field stems produces predictions ")
test_that("stem_plot", {
  field<-field %>% group_by(individualID) %>% arrange(desc(eventID)) %>% slice(1) %>% filter(plotID=="TEAK_057")
  plots_to_evaluate<-unique(as.character(submission$plot_name[submission$plot_name %in% field$plotID]))
  predictions = submission %>% filter(plot_name %in% plots_to_evaluate)
  result <- stem_plot(df=predictions,field=field,projectbox = T,show=F)
  expect_gt(sum(result$rs),0)
})
