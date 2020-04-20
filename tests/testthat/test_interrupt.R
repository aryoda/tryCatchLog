library(testthat)
library(tryCatchLog)



context("test_interrupt.R")



source("init_unit_test.R")



# suppress logging of errors and warnings to avoid overly output
source("disable_logging_output.R")



# Simulate a user interrupt using the same structure as a user-triggered interrupt.
# This is the structure of an original interrupt condition.
# Observe: There is no "message" or "call" attribute available (other conditions do have that)!
ic <- structure(list(), class = c("interrupt", "condition"))

# My playground to test a non-standard interrupt condition
# ic <- tryCatchLog:::condition("interrupt", message = NULL)  # extended version with message and call attributes



test_that("interrupt conditions are logged", {

  expect_silent(tryCatchLog(signalCondition(ic))) # signalCondition returns NULL so it is silent

  last.result <- last.tryCatchLog.result()

  expect_equal(NROW(last.result), 1)
  expect_equal(last.result$msg.text, "User-requested interrupt")   # this message was injected by tryCatchLog
  expect_equal(last.result$severity, "INFO")



  catched.i <- NA
  tryCatchLog(signalCondition(ic), interrupt = function(i) catched.i <<- i)

  last.result <- last.tryCatchLog.result()

  expect_equal(NROW(last.result), 1)
  expect_equal(last.result$msg.text, "User-requested interrupt")
  expect_equal(last.result$severity, "INFO")

  expect_equal(class(catched.i), c("interrupt", "condition"))



  # Check for unwanted side effects

  catched.i <- NA
  expect_error(tryCatchLog(stop("an error"), interrupt = function(i) catched.i <<- i))

  last.result <- last.tryCatchLog.result()

  expect_equal(NROW(last.result), 1)
  expect_equal(last.result$severity, "ERROR")
  expect_equal(last.result$msg.text, "an error")



  expect_condition(tryCatchLog(signalCondition(ic), error = function(e) print("gotcha")), class = "interrupt")

  last.result <- last.tryCatchLog.result()

  expect_equal(NROW(last.result), 1)
  expect_equal(last.result$msg.text, "User-requested interrupt")
  expect_equal(last.result$severity, "INFO")

})



test_that("silent.messages do not suppress interrupt conditions", {

  tryCatchLog(signalCondition(ic), silent.messages = TRUE)

  last.result <- last.tryCatchLog.result()

  expect_equal(NROW(last.result), 1)
  expect_equal(last.result$msg.text, "User-requested interrupt")
  expect_equal(last.result$severity, "INFO")


})
