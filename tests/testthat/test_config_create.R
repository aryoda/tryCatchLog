library(testthat)
library(tryCatchLog)



# Basic tests -----------------------------------------------------------------------------------------------------

context("test_config_create.R")



source("init_unit_test.R")



# suppress logging of errors and warnings to avoid overly output
source("disable_logging_output.R")



test_that("config.create without arguments creates a basic config", {

  expect_silent(config <- config.create())

  expect_s3_class(config, tryCatchLog:::.CONFIG.CLASS.NAME)

  expected_names <- c("cond.class", "silent", "write.to.log", "log.as.severity", "include.full.call.stack", "include.compact.call.stack")
  expect_equal(names(config), expected_names)

})



test_that("config.validate is silent for valid data", {

  expect_silent({
    config <- config.create()
    tryCatchLog:::config.validate(config)
  })

})



test_that("empty config cells are found", {

  expect_error({
      config <- config.create(cond.class = c("error", "warning", NA, "a", "b"))
    }
    , regexp = "config has empty cells"
    , fixed  = TRUE
  )

})



test_that("invalid severity level is found", {

  expect_error({
    config <- config.create(log.as.severity = c("WARN", "EXTREM", "INFO", "INFO", "INFO"))
  }
  , regexp = "invalid severity level"
  , fixed  = TRUE
  )

})



test_that("duplicated condition classes are found", {

  expect_error({
    config <- config.create(cond.class = c("error", "warning", "message", "error", "interrupt"))
  }
  , regexp = "duplicated condition class names"
  , fixed  = TRUE
  )

})
