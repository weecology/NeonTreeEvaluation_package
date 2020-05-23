library(testthat)
library(NeonTreeEvaluation)

#Check that data has been downloaded before tests
download()
test_check("NeonTreeEvaluation")
