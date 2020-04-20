library(testthat)
library(tryCatchLog)



context("test_user_defined_conditions.R")



source("init_unit_test.R")



# suppress logging of errors and warnings to avoid overly output
source("disable_logging_output.R")



# Creating user-defined conditions is currently only an internal feature of tryCatchLog...
udc1 <- tryCatchLog:::condition("my_condition_class", "message1")
udc2 <- tryCatchLog:::condition("my_other_condition_class")



test_that("user-defined conditions are logged", {

  # > tryCatch(signalCondition(udc1))
  # NULL

  # Once all established handlers for the condition have been tried, signalCondition returns NULL
  expect_null(signalCondition(udc1))

  expect_silent(tryCatchLog(signalCondition(udc1))) # user-defined conditions do not pop-up anywhere

  last.result <- last.tryCatchLog.result()

  expect_equal(NROW(last.result), 1)
  expect_equal(last.result$msg.text, "message1")
  expect_equal(last.result$severity, "INFO")


  expect_silent(tryCatchLog(signalCondition(udc2))) # condition with empty message

  last.result <- last.tryCatchLog.result()

  expect_equal(NROW(last.result), 1)
  expect_equal(last.result$msg.text, "")
  expect_equal(last.result$severity, "INFO")

})



test_that("user-defined conditions are catched", {

  catched <- NA
  tryCatchLog(signalCondition(udc1), condition = function(c) catched <<- c)

  last.result <- last.tryCatchLog.result()

  expect_equal(NROW(last.result), 1)
  expect_equal(last.result$msg.text, "message1")
  expect_equal(last.result$severity, "INFO")

  expect_equal(class(catched), c("my_condition_class", "condition"))

})



test_that("silent.messages do not suppress user-defined conditions", {

  tryCatchLog(signalCondition(udc1), silent.messages = TRUE)

  last.result <- last.tryCatchLog.result()

  expect_equal(NROW(last.result), 1)
  expect_equal(last.result$msg.text, "message1")
  expect_equal(last.result$severity, "INFO")

})



test_that("user-defined conditions work within stacked tryCatchLog expressions", {

  # outer handler
  catched <- NA
  expect_silent(tryCatchLog(tryCatchLog(signalCondition(udc1)), condition = function(c) catched <<- c))

  last.result <- last.tryCatchLog.result()

  expect_equal(NROW(last.result), 1)
  expect_equal(last.result$msg.text, "message1")
  expect_equal(last.result$severity, "INFO")

  expect_equal(class(catched), c("my_condition_class", "condition"))



  # inner handler
  catched <- NA
  expect_silent(tryCatchLog(tryCatchLog(signalCondition(udc1), condition = function(c) catched <<- c)))

  last.result <- last.tryCatchLog.result()

  expect_equal(NROW(last.result), 1)
  expect_equal(last.result$msg.text, "message1")
  expect_equal(last.result$severity, "INFO")

  expect_equal(class(catched), c("my_condition_class", "condition"))



  # inner and outer handler
  catched_inner <- NA
  catched_outer <- NA
  expect_silent(tryCatchLog(
                  tryCatchLog(signalCondition(udc1), condition = function(c) catched_inner <<- c)
                  , condition = function(c) catched_outer <<- c))

  last.result <- last.tryCatchLog.result()

  expect_equal(NROW(last.result), 1)
  expect_equal(last.result$msg.text, "message1")
  expect_equal(last.result$severity, "INFO")

  expect_equal(class(catched_inner), c("my_condition_class", "condition"))
  expect_true(is.na(catched_outer))  # inner handler consumed the condition so it does not bubble up



  # no handler
  expect_silent(tryCatchLog(tryCatchLog(signalCondition(udc1))))

  last.result <- last.tryCatchLog.result()

  expect_equal(NROW(last.result), 1)
  expect_equal(last.result$msg.text, "message1")
  expect_equal(last.result$severity, "INFO")

  expect_equal(class(catched), c("my_condition_class", "condition"))

})


# withCallingHandlers(stop("my error"), error = function(e) print("error handler"), condition = function(c) print("condition handler"), include.full.call.stack = F)
# tryCatch(stop("my error"), error = function(e) print("error handler"), condition = function(c) print("condition handler"), include.full.call.stack = F)
# tryCatch(stop("my error"), condition = function(c) print("condition handler"), error = function(e) print("error handler"), include.full.call.stack = F)
# tryCatch(warning("my error"), error = function(e) print("error handler"), condition = function(c) print("condition handler"), include.full.call.stack = F)
# tryCatchLog(stop("my error"), error = function(e) print("error handler"), condition = function(c) print("condition handler"), include.full.call.stack = F)
