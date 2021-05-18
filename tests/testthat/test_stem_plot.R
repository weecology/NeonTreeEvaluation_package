#test stem_plot functions for a sample set
library(dplyr)
library(stringr)
context("Check wrapper of unprojected submission against field stems produces predictions ")
test_that("stem_plot", {
  field<-field %>% group_by(individualID) %>% arrange(desc(eventID)) %>% slice(1) %>% filter(plotID=="SJER_052")
  predictions = submission %>% filter(plot_name == "SJER_052_2018")
  result <- stem_plot(df=predictions,field=field,projectbox = T,show=T)
  expect_gt(sum(result$rs),0)
})
