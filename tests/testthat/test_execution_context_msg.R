library(testthat)
library(tryCatchLog)




context("test_execution_context_msg.R")



source("init_unit_test.R")



# suppress logging of errors and warnings to avoid overly output
source("disable_logging_output.R")



test_that("execution.context.msg = NA works", {

  expect_silent(tryCatchLog(1 + 2, execution.context.msg = NA))
  expect_equal(NROW(last.tryCatchLog.result()), 0)

  expect_warning(tryCatchLog(log(-1), execution.context.msg = NA))
  last.result <- last.tryCatchLog.result()
  expect_equal(last.result$msg.text, "NaNs produced")
  expect_equal(last.result$execution.context.msg[1], "")

  expect_message(tryCatchLog(message("hello NA"), execution.context.msg = NA_character_))
  last.result <- last.tryCatchLog.result()
  expect_equal(last.result$msg.text, "hello NA\n")
  expect_equal(last.result$execution.context.msg[1], "")

  expect_warning(tryCatchLog(warning("test"), execution.context.msg = list(NA_character_, NA_integer_, NA)))
  expect_equal(last.tryCatchLog.result()$execution.context.msg[1], "")

})



test_that("execution.context.msg with length > 1 works", {

  expect_silent(tryCatchLog(1 + 2, execution.context.msg = "one"))
  expect_equal(NROW(last.tryCatchLog.result()), 0)

  expect_warning(tryCatchLog(1 + 2, execution.context.msg = c("first", "second")), "more than one element")

  expect_warning(tryCatchLog(log(-1), execution.context.msg = 1:2), "more than one element")
  expect_equal(last.tryCatchLog.result()$execution.context.msg[1], "1")

  expect_warning(tryCatchLog(warning("test"), execution.context.msg = 1:3), "more than one element")
  expect_equal(last.tryCatchLog.result()$execution.context.msg[1], "1")

  expect_warning(tryCatchLog(warning("test"), execution.context.msg = 1:4), "more than one element")
  expect_equal(last.tryCatchLog.result()$execution.context.msg[1], "1")

  expect_true(is.character(last.tryCatchLog.result()$execution.context.msg))

})



test_that("execution.context.msg with length == 0 works",  {

  expect_warning(tryCatchLog(warning("test"), execution.context.msg = character(0)), "test")
  expect_equal(last.tryCatchLog.result()$execution.context.msg[1], "")

  expect_warning(tryCatchLog(warning("test"), execution.context.msg = integer(0)), "test")
  expect_equal(last.tryCatchLog.result()$execution.context.msg[1], "")

})



test_that("execution.context.msg with coercion works",  {

  expect_silent(tryCatchLog(1 + 2, execution.context.msg = 1))
  expect_equal(NROW(last.tryCatchLog.result()), 0)

  expect_warning(tryCatchLog(warning("test"), execution.context.msg = 1), "test")
  expect_equal(last.tryCatchLog.result()$execution.context.msg[1], "1")

  expect_warning(tryCatchLog(warning("test"), execution.context.msg = 2L), "test")
  expect_equal(last.tryCatchLog.result()$execution.context.msg[1], "2")

  a <- 10 + 5
  expect_warning(tryCatchLog(warning("test"), execution.context.msg = a), "test")
  expect_equal(last.tryCatchLog.result()$execution.context.msg[1], "15")

  expect_warning(tryCatchLog(warning("test"), execution.context.msg = 100 + 10), "test")
  expect_equal(last.tryCatchLog.result()$execution.context.msg[1], "110")

  expect_warning(tryCatchLog(warning("test"), execution.context.msg = list(a = 3, b = "x")), "test")
  expect_equal(last.tryCatchLog.result()$execution.context.msg[1], "3")

  # test a data type that cannot be converted to character ("closure")
  expect_error(tryCatchLog(warning("test"), execution.context.msg = function() 4), "cannot coerce")
  expect_equal(NROW(last.tryCatchLog.result()), 0)

})



test_that("execution.context.msg with nested elements and length > 1 works",  {

  expect_warning(tryCatchLog(warning("test"), execution.context.msg = as.data.frame(mtcars)), "test")
  expect_equal(last.tryCatchLog.result()$execution.context.msg[1], "21")

  # expression with nesting level 3
  expect_warning(tryCatchLog(warning("test"), execution.context.msg = list(a = list(b = list(c = 1:10)))), "test")
  expect_equal(last.tryCatchLog.result()$execution.context.msg[1], "1")

})
