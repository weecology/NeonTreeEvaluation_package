library(testthat)
library(NeonTreeEvaluation)

#Check that data has been downloaded before tests
check_download()
test_check("NeonTreeEvaluation")
