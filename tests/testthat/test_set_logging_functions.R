# Tests are run within the folder "tryCatchLog/tests/testthat".
# Clean it up at the beginning of a test!

library(tryCatchLog)
library(testthat)



context("test_set_logging_functions.R")



source("init_unit_test.R")


# Explicitly enable the log output for these tests.
# This uses the default internal logging functions of tryCatchLog.
tryCatchLog::set.logging.functions()

# print(tryCatchLog:::.tryCatchLog.env$info.log.func)  # just for test debugging



# Test implementations --------------------------------------------------------------------------------------------

test_that("Error is logged as ERROR", {

  expect_output(
      tryLog(signalCondition(simpleError("log this condition"))),
                regexp = "^ERROR.*log this condition"
  )

})



test_that("Warning is logged as WARN", {

  expect_output(
    tryLog(signalCondition(simpleWarning("log this condition")), silent.warnings = TRUE),
    regexp = "^WARN.*log this condition"
  )

})






test_that("Message is logged as INFO", {

  expect_output(
    tryLog(signalCondition(simpleMessage("log this condition")), silent.messages = TRUE),
    regexp = "^INFO.*log this condition"
  )

})



test_that("Interrupt condition is logged as FATAL", {

  expect_output({
    ic <- structure(list(), class = c("interrupt", "condition"))
    tryLog(signalCondition(ic))
    }
    , regexp = "^FATAL.*User-requested interrupt"
  )

})



test_that("user-defined condition is logged as INFO", {

  expect_output({
    cond <- tryCatchLog:::condition(class = c(), message= "log this user-defined condition")
    tryLog(signalCondition(cond), logged.conditions = "condition")
  }
  , regexp = "^INFO.*log this user-defined condition"
  )

})
