library(testthat)
library(tryCatchLog)



context("test_user_defined_conditions.R")



source("init_unit_test.R")



# suppress logging of errors and warnings to avoid overly output
source("disable_logging_output.R")



# Creating user-defined conditions is currently only an internal feature of tryCatchLog...
# Do not use rlang or another package for this to minimize the depedencies!
udc1 <- tryCatchLog:::condition("my_condition_class", "message1")
udc2 <- tryCatchLog:::condition("my_other_condition_class")



test_that("Correct return value if a custom condition is thrown but not logged", {

  # > tryCatch(signalCondition(udc1))
  # NULL

  # Once all established handlers for the condition have been tried, signalCondition returns NULL
  # Make sure this semantics has not changed in R!
  expect_null(signalCondition(udc1))

  expect_true(tryCatchLog( {
    signalCondition(udc1)
    TRUE
  }))

})


test_that("user-defined conditions are not logged by default", {


  expect_silent(tryCatchLog(signalCondition(udc1))) # user-defined conditions do not pop-up anywhere (no console output in R by default)

  last.result <- last.tryCatchLog.result()

  # 06.09.2021 Feature #62: Do not log user-defined conditions anymore (was too chatty)
  expect_equal(NROW(last.result), 0)
  # expect_equal(last.result$msg.text, "message1")
  # expect_equal(last.result$severity, "INFO")


  expect_silent(tryCatchLog(signalCondition(udc2))) # condition with empty message

  last.result <- last.tryCatchLog.result()

  expect_equal(NROW(last.result), 0)
  # expect_equal(last.result$msg.text, "")
  # expect_equal(last.result$severity, "INFO")

})



test_that("user-defined conditions are catched but not logged by default", {

  catched <- NA
  tryCatchLog(signalCondition(udc1), condition = function(c) catched <<- c)

  last.result <- last.tryCatchLog.result()

  expect_equal(NROW(last.result), 0)
  # expect_equal(last.result$msg.text, "message1")
  # expect_equal(last.result$severity, "INFO")

  expect_equal(class(catched), c("my_condition_class", "condition"))

})



test_that("user-defined conditions work within stacked tryCatchLog expressions", {

  # outer handler
  catched <- NA
  expect_silent(tryCatchLog(tryCatchLog(signalCondition(udc1)), condition = function(c) catched <<- c))

  last.result <- last.tryCatchLog.result()

  expect_equal(NROW(last.result), 0)
  # expect_equal(last.result$msg.text, "message1")
  # expect_equal(last.result$severity, "INFO")

  expect_equal(class(catched), c("my_condition_class", "condition"))



  # inner handler
  catched <- NA
  expect_silent(tryCatchLog(tryCatchLog(signalCondition(udc1), condition = function(c) catched <<- c)))

  last.result <- last.tryCatchLog.result()

  expect_equal(NROW(last.result), 0)
  # expect_equal(last.result$msg.text, "message1")
  # expect_equal(last.result$severity, "INFO")

  expect_equal(class(catched), c("my_condition_class", "condition"))



  # inner and outer handler
  catched_inner <- NA
  catched_outer <- NA
  expect_silent(tryCatchLog(
                  tryCatchLog(signalCondition(udc1), condition = function(c) catched_inner <<- c)
                  , condition = function(c) catched_outer <<- c))

  last.result <- last.tryCatchLog.result()

  expect_equal(NROW(last.result), 0)
  # expect_equal(last.result$msg.text, "message1")
  # expect_equal(last.result$severity, "INFO")

  expect_equal(class(catched_inner), c("my_condition_class", "condition"))
  expect_true(is.na(catched_outer))  # inner handler consumed the condition so it does not bubble up



  # no handler
  expect_silent(tryCatchLog(tryCatchLog(signalCondition(udc1))))

  last.result <- last.tryCatchLog.result()

  expect_equal(NROW(last.result), 0)
  # expect_equal(last.result$msg.text, "message1")
  # expect_equal(last.result$severity, "INFO")

  expect_equal(class(catched), c("my_condition_class", "condition"))

})
