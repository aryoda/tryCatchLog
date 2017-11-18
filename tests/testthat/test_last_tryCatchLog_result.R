library(futile.logger)
library(tryCatchLog)
library(testthat)



context("last.tryCatchLog.result")

# set up test context
options("tryCatchLog.dump.errors.to.file" = FALSE)
options("tryCatchLog.silent.warnings"     = FALSE)
options("tryCatchLog.silent.messages"     = FALSE)



# flog.threshold("FATAL")                         # suppress logging of errors and warnings to avoid overly output
# flog.threshold("INFO")



test_that("no conditions are logged initially", {

  tryCatchLog:::reset.last.tryCatchLog.result()   # internal function!

  expect_equal(last.tryCatchLog.result(), list())

})



test_that("last logged condition are reset", {

  expect_equal(last.tryCatchLog.result(), list())

  tryCatchLog(TRUE)
  expect_equal(last.tryCatchLog.result(), list())

  expect_warning(tryCatchLog(log(-1)))
  expect_equal(length(last.tryCatchLog.result()), 1)

  tryCatchLog(TRUE)
  expect_equal(last.tryCatchLog.result(), list())

  tryLog(log("a"))
  expect_equal(length(last.tryCatchLog.result()), 1)

  tryCatchLog(TRUE)
  expect_equal(last.tryCatchLog.result(), list())



  tryLog(1 + 2)
  expect_equal(last.tryCatchLog.result(), list())

  tryLog(log("a"))
  expect_equal(length(last.tryCatchLog.result()), 1)

  tryLog(NULL)
  expect_equal(last.tryCatchLog.result(), list())

})



test_that("last logged condition contains all conditions", {

  tryCatchLog(TRUE)
  expect_equal(last.tryCatchLog.result(), list())

  expect_warning(tryCatchLog(log(-1)))
  expect_equal(length(last.tryCatchLog.result()), 1)

  expect_error(expect_warning(tryCatchLog({log(-1); log("a")}, error = stop)))
  expect_equal(length(last.tryCatchLog.result()), 2)

  expect_error(expect_warning(tryCatchLog({message("hello"); log(-1); log("a")}, error = stop)))
  expect_equal(length(last.tryCatchLog.result()), 3)

  expect_equal(substr(last.tryCatchLog.result()[[1]], 1, 5), "hello")

})



