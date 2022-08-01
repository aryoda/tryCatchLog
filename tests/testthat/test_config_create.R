library(testthat)
library(tryCatchLog)



# Basic tests -----------------------------------------------------------------------------------------------------

context("test_config_create.R")



source("init_unit_test.R")



# suppress logging of errors and warnings to avoid overly output
source("disable_logging_output.R")



# TODO Implement more unit tests
test_that("config.create without arguments creates a basic config", {

  expect_silent(config <- config.create())

  expect_s3_class(config, tryCatchLog:::.CONFIG.CLASS.NAME)

  expected_names <- c("cond.class", "silent", "write.to.log", "log.as.severity", "include.full.call.stack", "include.compact.call.stack")
  expect_equal(names(config), expected_names)

})
