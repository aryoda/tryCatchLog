library(testthat)
library(tryCatchLog)



# Basic tests -----------------------------------------------------------------------------------------------------

context("test_config_load_save.R")



source("init_unit_test.R")



# suppress logging of errors and warnings to avoid overly output
source("disable_logging_output.R")



test_that("config can be saved and loaded again", {

  config.file.name <- "test_config.csv"

  unlink(config.file.name)  # delete previous test file for a clean test setup



  config <- config.create()

  config.save(config, config.file.name)

  expect_true(file.exists(config.file.name), label = "Written config file could not be found")



  loaded.config <- config.load(config.file.name)

  expect_s3_class(loaded.config, tryCatchLog:::.CONFIG.CLASS.NAME)

  expected_names <- c("cond.class", "silent", "do.not.log", "log.as.severity", "include.full.call.stack", "include.compact.call.stack")
  expect_equal(names(loaded.config), expected_names)

  expect_equal(loaded.config, config)

})
