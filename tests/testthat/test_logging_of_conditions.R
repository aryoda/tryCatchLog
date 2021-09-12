# Tests are run within the folder "tryCatchLog/tests/testthat".
# Clean it up at the beginning of a test!

library(tryCatchLog)
library(testthat)



context("test_logging_of_conditions.R")



source("init_unit_test.R")



# suppress logging of errors and warnings to avoid overly output
source("disable_logging_output.R")



# Creating user-defined conditions is currently only an internal feature of tryCatchLog...
# Do not use rlang or another package for this to minimize the depedencies!
udc1 <- tryCatchLog:::condition("my_condition_class", "message1")
udc2 <- tryCatchLog:::condition("my_other_condition_class")



# Test implementations --------------------------------------------------------------------------------------------

test_that("Correct return value if a custom condition is thrown and logged", {

  expect_true(tryCatchLog( {
    signalCondition(udc1)
    TRUE
  }, logged.conditions = NA))

  expect_true(tryCatchLog( {
    signalCondition(udc1)
    TRUE
  }, logged.conditions = "my_condition_class"))

})



test_that("Missing conditon message works", {

  catched <- NA
  tryCatchLog(signalCondition(tryCatchLog:::condition("class1", message = NULL)), condition = function(c) catched <<- c, logged.conditions = NA)

  expect_null(catched$message, "")

  last.result <- last.tryCatchLog.result()

  expect_equal(NROW(last.result), 1)
  expect_equal(last.result$msg.text, "")

})



test_that("An error is thrown for any value of logged.conditions", {
  for (logged.conditions in list(NULL, NA, c("cond1", "cond2"))) {
    expect_error(tryCatchLog(stop("error"), logged.conditions = logged.conditions))
    expect_silent(tryLog(stop("error"), logged.conditions = logged.conditions))
  }
})



test_that("A warning is thrown for any value of logged.conditions", {
  for (logged.conditions in list(NULL, NA, c("cond1", "cond2"))) {
    expect_warning(tryCatchLog(warning("warning"), logged.conditions = logged.conditions))
    expect_warning(tryLog(warning("warning"), logged.conditions = logged.conditions))
  }
})



test_that("A message is thrown for any value of logged.conditions", {
  for (logged.conditions in list(NULL, NA, c("cond1", "cond2"))) {
    expect_message(tryCatchLog(message("hello"), logged.conditions = logged.conditions))
    expect_message(tryLog(message("hello"), logged.conditions = logged.conditions))
  }
})



test_that("tryCatchLog is silent when a condition is thrown and logged.conditions is NULL", {
  # silence is the default behaviour for conditions in base R even though the condition bubbles up!
  expect_silent(tryCatchLog(signalCondition(udc1), logged.conditions = NULL))
})



test_that("tryCatchLog logs a condition when a condition is thrown and logged.conditions is NA", {
  expect_condition(tryCatchLog(signalCondition(udc1), logged.conditions = NA))
})



test_that("tryCatchLog logs a condition when a condition which class is in logged.conditions is thrown", {
  expect_condition(tryCatchLog(signalCondition(udc1), logged.conditions = c("my_condition_class", "cond2")))
  expect_condition(tryCatchLog(signalCondition(udc1), logged.conditions = c("cond2", "my_condition_class")))
})



test_that("tryCatchLog is silent when a condition which class is NOT in logged.conditions is thrown", {
  expect_silent(tryCatchLog(signalCondition(udc1), logged.conditions = c("cond1", "cond2")))
})



test_that("logged user-defined conditions are catched and logged correctly", {

  catched <- NA
  tryCatchLog(signalCondition(udc1), condition = function(c) catched <<- c, logged.conditions = NA)

  last.result <- last.tryCatchLog.result()

  expect_equal(NROW(last.result), 1)
  expect_equal(last.result$msg.text, "message1")
  expect_equal(last.result$severity, "INFO")

  expect_equal(class(catched), c("my_condition_class", "condition"))

})



test_that("silent.messages do not suppress user-defined conditions", {

  tryCatchLog(signalCondition(udc1), silent.messages = TRUE, logged.conditions = NA)

  last.result <- last.tryCatchLog.result()

  expect_equal(NROW(last.result), 1)
  expect_equal(last.result$msg.text, "message1")
  expect_equal(last.result$severity, "INFO")

})



test_that("user-defined conditions work within stacked tryCatchLog expressions with enabled logging", {

  # outer handler
  catched <- NA
  expect_silent(tryCatchLog(tryCatchLog(signalCondition(udc1)), condition = function(c) catched <<- c, logged.conditions = NA))

  last.result <- last.tryCatchLog.result()

  expect_equal(NROW(last.result), 1)
  expect_equal(last.result$msg.text, "message1")
  expect_equal(last.result$severity, "INFO")

  expect_equal(class(catched), c("my_condition_class", "condition"))



  # inner handler
  catched <- NA
  expect_silent(tryCatchLog(tryCatchLog(signalCondition(udc1), condition = function(c) catched <<- c, logged.conditions = NA), logged.conditions = NA))

  last.result <- last.tryCatchLog.result()

  expect_equal(NROW(last.result), 1)
  expect_equal(last.result$msg.text, "message1")
  expect_equal(last.result$severity, "INFO")

  expect_equal(class(catched), c("my_condition_class", "condition"))



  # inner and outer handler
  catched_inner <- NA
  catched_outer <- NA
  expect_silent(tryCatchLog(
    tryCatchLog(signalCondition(udc1), condition = function(c) catched_inner <<- c, logged.conditions = NA)
    , condition = function(c) catched_outer <<- c, logged.conditions = NA))

  last.result <- last.tryCatchLog.result()

  expect_equal(NROW(last.result), 1)
  expect_equal(last.result$msg.text, "message1")
  expect_equal(last.result$severity, "INFO")

  expect_equal(class(catched_inner), c("my_condition_class", "condition"))
  expect_true(is.na(catched_outer))  # inner handler consumed the condition so it does not bubble up



  # no handler
  expect_silent(tryCatchLog(tryCatchLog(signalCondition(udc1), logged.conditions = NA), logged.conditions = NA))

  last.result <- last.tryCatchLog.result()

  expect_equal(NROW(last.result), 1)
  expect_equal(last.result$msg.text, "message1")
  expect_equal(last.result$severity, "INFO")

  expect_equal(class(catched), c("my_condition_class", "condition"))

})
