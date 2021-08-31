# Tests are run within the folder "tryCatchLog/tests/testthat".
# Clean it up at the beginning of a test!

library(testthat)



# Silent warnings -------------------------------------------------------------------------------------------------

context("test_logging_of_conditions.R")



source("init_unit_test.R")



# suppress logging of errors and warnings to avoid overly output
source("disable_logging_output.R")



# Test implementations --------------------------------------------------------------------------------------------

test_that("A message is displayed for any value of logged.conditions", {
  for (logged.conditions in list(NULL, NA, c("cond1", "cond2"))) {
    expect_message(tryCatchLog(message("hello"), logged.conditions = logged.conditions))
    expect_message(tryLog(message("hello"), logged.conditions = logged.conditions))
  }
})

test_that("tryCatchLog is silent when a condition is thrown and logged.conditions is NULL", {
  expect_silent(tryCatchLog(rlang::signal("condition 1", class = "cond1"), logged.conditions = NULL))
})

test_that("tryCatchLog logs a condition when a condition is thrown and logged.conditions is NA", {
  expect_condition(tryCatchLog(rlang::signal("condition 1", class = "cond1"), logged.conditions = NA))
})

test_that("tryCatchLog logs a condition when a condition which class is in logged.conditions is thrown", {
  expect_condition(tryCatchLog(rlang::signal("condition 1", class = "cond1"), logged.conditions = c("cond1", "cond2")))
})

test_that("tryCatchLog is silent when a condition which class is NOT in logged.conditions is thrown", {
  expect_silent(tryCatchLog(rlang::signal("condition 3", class = "cond3"), logged.conditions = c("cond1", "cond2")))
})


