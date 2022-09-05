library(testthat)
library(tryCatchLog)



context("test_config_validate.R")



source("init_unit_test.R")



# suppress logging of errors and warnings to avoid overly output
source("disable_logging_output.R")



test_that("config.validate is silent for valid data", {

  expect_silent({
    config <- config.create()
    tryCatchLog:::config.validate(config)
  })

})



test_that("config.validate finds invalid column names", {

  config <- config.create()
  valid.col.names <- colnames(config)

  for (i in seq_along(valid.col.names)) {
    invalid.col.names <- valid.col.names
    invalid.col.names[i] <- paste0(invalid.col.names[i], "x")
    names(config) <- invalid.col.names

    expect_error(tryCatchLog:::config.validate(config)
                 , regexp = "expected column names"
                 , fixed  = TRUE)
  }

})



test_that("config.validate finds invalid column data types", {

  config <- config.create()

  for (i in seq_len(NCOL(config))) {

    wrong.config <- config
    wrong.config[, i] <- Sys.Date() # replicates to correct length

    expect_error(tryCatchLog:::config.validate(wrong.config)
                 , regexp = "expected column classes"
                 , fixed  = TRUE)
  }

})



test_that("is.config does work", {

  expect_error({
    tryCatchLog:::config.validate(NA)
    }
    , regexp = "config is not a data.frame"
  )

  expect_silent({
    res <- tryCatchLog:::config.validate(NULL, throw.error.with.findings = FALSE)
  })

  expect_false(res$status)

  expect_match(res$findings
               , regexp = "config is not a data.frame"
               , fixed  = TRUE
  )

})


