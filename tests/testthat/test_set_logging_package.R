library(tryCatchLog)
library(testthat)

# TODO This test influences all later running test files. Why?
# skip("Unsolved issue with log output produced after test_set_logging_package despite disable_logging_output.R")
# WORK-AROUND: FQ function name to use correct pkg internal singleton env var (could be testthat bug)


context("test_set_logging_package.R")



source("init_unit_test.R")



# suppress logging of errors and warnings to avoid overly output
source("disable_logging_output.R")


# options("tryCatchLog.preferred.logging.package" = "tryCatchLog")



test_that("using tryCatchLog pkg for logging works", {

  expect_silent(res <- tryCatchLog::set.logging.package("tryCatchLog"))
  expect_equal(res, "tryCatchLog")

})



test_that("using futile.logger pkg for logging works", {

  skip_if_not_installed("futile.logger")

  expect_silent(res <- tryCatchLog::set.logging.package("futile.logger"))  # WORK-AROUND: See comment at begin of file
  expect_equal(res, "futile.logger")

})



test_that("using lgr pkg for logging works", {

  skip_if_not_installed("lgr")

  expect_silent(res <- tryCatchLog::set.logging.package("lgr"))
  expect_equal(res, "lgr")

})



test_that("using logger pkg for logging works", {

  skip_if_not_installed("logger")

  expect_silent(res <- tryCatchLog::set.logging.package("logger"))
  expect_equal(res, "logger")

})



test_that("using logging pkg for logging works", {

  skip_if_not_installed("logging")

  expect_silent(res <- tryCatchLog::set.logging.package("logging"))
  expect_equal(res, "logging")

})


# source("disable_logging_output.R")
# test_that("Globally disabled silent messages throw a message if no parameter given", {
#   expect_message(tryCatchLog(message("hello")))
#   expect_message(tryLog(message("hello")))
# })
