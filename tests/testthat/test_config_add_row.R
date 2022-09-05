library(testthat)
library(tryCatchLog)



context("test_config_add_row.R")



source("init_unit_test.R")



# suppress logging of errors and warnings to avoid overly output
source("disable_logging_output.R")


config <- config.create()

test_that("config.add.row is silent for valid data", {

  expect_silent({
    config <- config.add.row(config, "my condition", TRUE, TRUE, Severity.Levels$TRACE, FALSE, FALSE)
  })

})



test_that("config.add.row does really add a correct row", {

  config <- config.create()
  old.row.number <- NROW(config)
  config <- config.add.row(config, "my condition", TRUE, TRUE, Severity.Levels$TRACE, FALSE, TRUE)

  expect_equal(NROW(config), old.row.number + 1)

  added.row <- tail(config,1)

  expect_equal(added.row$cond.class, "my condition")
  expect_equal(added.row$silent, TRUE)
  expect_equal(added.row$write.to.log, TRUE)
  expect_equal(added.row$log.as.severity, "TRACE")
  expect_equal(added.row$include.full.call.stack, FALSE)
  expect_equal(added.row$include.compact.call.stack, TRUE)

})




test_that("config.add.row requires an existing config", {

  expect_error({
      config <- config.add.row(NA, "my condition", TRUE, TRUE, Severity.Levels$TRACE, FALSE, FALSE)
    }
    , regexp = "Invalid tryCatchLog configuration"
    , fixed  = TRUE
  )

  expect_error({
    config <- config.add.row(NULL, "my condition", TRUE, TRUE, Severity.Levels$TRACE, FALSE, FALSE)
  }
  , regexp = "Invalid tryCatchLog configuration"
  , fixed  = TRUE
  )

})
