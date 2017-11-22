# library(futile.logger)
# library(tryCatchLog)
# library(testthat)



context("last.tryCatchLog.result")

# set up test context
options("tryCatchLog.dump.errors.to.file" = FALSE)
options("tryCatchLog.silent.warnings"     = FALSE)
options("tryCatchLog.silent.messages"     = FALSE)



# flog.threshold("FATAL")                         # suppress logging of errors and warnings to avoid overly output
# flog.threshold("INFO")



test_that("no conditions are logged initially", {

  tryCatchLog:::reset.last.tryCatchLog.result()   # internal function!

  expect_equal(last.tryCatchLog.result(), data.frame())

})



test_that("last logged condition are reset", {

  expect_equal(last.tryCatchLog.result(), data.frame())

  tryCatchLog(TRUE)
  expect_equal(last.tryCatchLog.result(), data.frame())

  expect_warning(tryCatchLog(log(-1)))
  expect_equal(NROW(last.tryCatchLog.result()), 1)

  tryCatchLog(TRUE)
  expect_equal(class(last.tryCatchLog.result()), "data.frame")

  tryLog(log("a"))
  expect_equal(NROW(last.tryCatchLog.result()), 1)

  tryCatchLog(TRUE)
  expect_equal(NROW(last.tryCatchLog.result()), 0)



  tryLog(1 + 2)
  expect_equal(last.tryCatchLog.result(), data.frame())

  tryLog(log("a"))
  expect_equal(NROW(last.tryCatchLog.result()), 1)

  tryLog(NULL)
  expect_equal(last.tryCatchLog.result(), data.frame())

})



test_that("last logged condition contains all conditions", {

  tryCatchLog(TRUE)
  expect_equal(last.tryCatchLog.result(), data.frame())

  expect_warning(tryCatchLog(log(-1)))
  expect_equal(NROW(last.tryCatchLog.result()), 1)

  expect_error(expect_warning(tryCatchLog({log(-1); log("a")}, error = stop)))
  expect_equal(NROW(last.tryCatchLog.result()), 2)

  expect_error(expect_warning(tryCatchLog({message("hello"); log(-1); log("a")}, error = stop)))
  expect_equal(NROW(last.tryCatchLog.result()), 3)

  expect_equal(substr(last.tryCatchLog.result()[1,]$msg.text, 1, 5), "hello")

})



test_that("column values are correct", {

  expect_error(expect_warning(tryCatchLog({message("hello"); log(-1); log("a")}, error = stop)))

  log <- last.tryCatchLog.result()

  expect_equal(log$severity, c("INFO", "WARN", "ERROR"))
  expect_equal(log$msg.text, c("hello\n", "NaNs produced", "non-numeric argument to mathematical function"))
  expect_equal(class(log$compact.stack.trace), "character")
  expect_equal(class(log$full.stack.trace), "character")

})


