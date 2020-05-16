context("Check wrapper of unprojected submission against field stems ")
test_that("evaluate_field_stems", {
  data("submission")
  result<-submission %>% filter(stringr::str_detect(plot_name,"MLBS")) %>%
    evaluate_field_stems(.,project=T)
  expect_equal(colnames(result),c("plot_name","submission","field"))
  expect_is(df$submission,"integer")
  })

test_that("stem_recall processes a single plot", {
  data("submission")
  df<-submission %>% filter(plot_name=="NIWO_010") %>% do(stem_recall(.,project = T))
  expect_equal(dim(df),c(1,3))
})
