library(testthat)
library(tryCatchLog)
# library(futile.logger)


context("namespace hook functions")


# These tests do check the namespace hook functions (for details see "?.onLoad")
# These tests do NOT detach and reload the tryCatchLog package but call the hook functions directly.



test_that("internal package state is initialized", {

  # prepare ---------------------------------------------------------------------------------------------------------

  # Preset the options

  # tryCatchLog:::.tryCatchLog.env$last.log <- NULL
  # Error in loadNamespace(name) : there is no package called ‘*tmp*’

  # tryCatchLog:::.tryCatchLog.env$newline <- "afds"
  # Error in loadNamespace(name) : there is no package called ‘*tmp*’



  # tests -----------------------------------------------------------------------------------------------------------

  # call the hook function
  expected_Newline_value <- "test_result"
  with_mock(
    `tryCatchLog:::determine.platform.NewLine` = function() return(expected_Newline_value),
    expect_silent(tryCatchLog:::.onAttach(".", "tryCatchLog"))
  )



  # new line string is initialized
  expect_equal(tryCatchLog::platform.NewLine(), expected_Newline_value)



  # clean-up---------------------------------------------------------------------------------------------------------

  # DIRTY: Reset to correct value to avoid side effects for other unit tests
  # If this line fails many other unit test results may be wrong...
  tryCatchLog:::.onAttach(".", "tryCatchLog")

  # Check reset: New line string is initialized
  expect_true(tryCatchLog::platform.NewLine() %in% c("\n", "\r\n"))

})




test_that("non-existing options are initialized when package is loaded", {

  # prepare ---------------------------------------------------------------------------------------------------------

  # Unset the options
  options("tryCatchLog.write.error.dump.file" = NULL)
  options("tryCatchLog.silent.warnings"       = NULL)
  options("tryCatchLog.silent.messages"       = NULL)

  expect_null(getOption("tryCatchLog.write.error.dump.file"))
  expect_null(getOption("tryCatchLog.silent.warnings"))
  expect_null(getOption("tryCatchLog.silent.messages"))



  # tests -----------------------------------------------------------------------------------------------------------

  # call the hook function
  expect_silent(tryCatchLog:::.onLoad(".", "tryCatchLog"))



  # tryCatchLog initializes all non-existing options to FALSE
  expect_false(getOption("tryCatchLog.write.error.dump.file"))
  expect_false(getOption("tryCatchLog.silent.warnings"))
  expect_false(getOption("tryCatchLog.silent.messages"))

})



test_that("existing options are left untouched when package is loaded", {

  # prepare ---------------------------------------------------------------------------------------------------------

  # Preset the options
  options("tryCatchLog.write.error.dump.file" = TRUE)
  options("tryCatchLog.silent.warnings"       = TRUE)
  options("tryCatchLog.silent.messages"       = TRUE)



  expect_true(getOption("tryCatchLog.write.error.dump.file"))
  expect_true(getOption("tryCatchLog.silent.warnings"))
  expect_true(getOption("tryCatchLog.silent.messages"))



  # tests -----------------------------------------------------------------------------------------------------------

  # call the hook function
  expect_silent(tryCatchLog:::.onLoad(".", "tryCatchLog"))



  expect_true(getOption("tryCatchLog.write.error.dump.file"))
  expect_true(getOption("tryCatchLog.silent.warnings"))
  expect_true(getOption("tryCatchLog.silent.messages"))

})
