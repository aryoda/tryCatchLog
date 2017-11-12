library(futile.logger)
library(tryCatchLog)
library(testthat)



context("last.tryCatchLog.log")

# set up test context
options("tryCatchLog.dump.errors.to.file" = FALSE)
options("tryCatchLog.silent.warnings"     = FALSE)
options("tryCatchLog.silent.messages"     = FALSE)



flog.threshold("FATAL")                         # suppress logging of errors and warnings to avoid overly output
# flog.threshold("INFO")

# TODO Debug this f***** RStudio error caused by the injected error handler...
tryCatchLog(log("a"))
# Error in value[[3L]](cond) : attempt to apply non-function
# Error during wrapup:

test_that("no conditions are logged initially", {

  tryCatchLog:::reset.last.tryCatchLog.log()   # internal function!

  expect_equal(last.tryCatchLog.log(), list())

})



test_that("last logged condition are reset", {

  expect_equal(last.tryCatchLog.log(), list())

  tryCatchLog(TRUE)
  expect_equal(last.tryCatchLog.log(), list())

  expect_warning(tryCatchLog(log(-1)))
  expect_equal(length(last.tryCatchLog.log()), 1)

  tryCatchLog(TRUE)
  expect_equal(last.tryCatchLog.log(), list())

  tryLog(log("a"))
  expect_equal(length(last.tryCatchLog.log()), 1)

  tryCatchLog(TRUE)
  expect_equal(last.tryCatchLog.log(), list())



  tryLog(1 + 2)
  expect_equal(last.tryCatchLog.log(), list())

  tryLog(log("a"))
  expect_equal(length(last.tryCatchLog.log()), 1)

  tryLog(NULL)
  expect_equal(last.tryCatchLog.log(), list())

})



test_that("last logged condition contains all conditions", {

  tryCatchLog(TRUE)
  expect_equal(last.tryCatchLog.log(), list())

  expect_warning(tryCatchLog(log(-1)))
  expect_equal(length(last.tryCatchLog.log()), 1)

  expect_error(expect_warning(tryCatchLog({log(-1); log("a")})))
  expect_equal(length(last.tryCatchLog.log()), 2)

  expect_error(expect_warning(tryCatchLog({message("hello"); log(-1); log("a")})))
  expect_equal(length(last.tryCatchLog.log()), 3)

  expect_equal(substr(last.tryCatchLog.log()[[1]], 1, 5), "hello")

})



