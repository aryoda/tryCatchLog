library(futile.logger)
library(tryCatchLog)
library(testthat)



context("stacked tryCatchLog")

# set up test context
options("tryCatchLog.dump.errors.to.file" = FALSE)
options("tryCatchLog.silent.warnings"     = FALSE)
options("tryCatchLog.silent.messages"     = FALSE)



flog.threshold("FATAL")                         # suppress logging of errors and warnings to avoid overly output
# flog.threshold("INFO")


test_that("only one error occurs", {

  expect_error(tryCatchLog(tryCatchLog(tryCatchLog(stop("throw.my.error")))),
               "throw.my.error",
               fixed = TRUE
  )

  log <- last.tryCatchLog.result()

  expect_equal(NROW(log), 1, info = "only one error")
  expect_equal(log$severity[1], "ERROR")

})



test_that("only one warning occurs", {

  expect_warning(tryCatchLog(tryCatchLog(tryCatchLog(warning("throw.my.warning")))),
               "throw.my.warning",
               fixed = TRUE
  )

  log <- last.tryCatchLog.result()

  expect_equal(NROW(log), 1, info = "only one warning")
  expect_equal(log$severity[1], "WARN")

})



test_that("only one message occurs", {

  expect_message(tryCatchLog(tryCatchLog(tryCatchLog(message("throw.my.message")))),
                 "throw.my.message",
                 fixed = TRUE
  )

  log <- last.tryCatchLog.result()

  expect_equal(NROW(log), 1, info = "only one message")
  expect_equal(log$severity[1], "INFO")

})



test_that("exactly one error, warning and message occurs", {

  expect_warning(
    expect_message(
      expect_error(tryCatchLog(
                   tryCatchLog(
                     tryCatchLog({message("throw.a.message")
                                  warning("throw.a.warning")
                                  stop("throw.an.error")
                                 })
                   )
                 ),
                 "throw.an.error",
                 fixed = TRUE
      ),
      "throw.a.message",
      fixed = TRUE
    ),
    "throw.a.warning",
    fixed = TRUE
  )

  log <- last.tryCatchLog.result()

  expect_equal(NROW(log), 3, info = "only three log entries")
  expect_equal(log$severity[1], "INFO")
  expect_equal(log$severity[2], "WARN")
  expect_equal(log$severity[3], "ERROR")

})




test_that("a catched warning does not bubble up after handling", {

  expect_output(tryCatchLog(tryCatchLog(tryCatchLog(warning("throw.my.warning")),
                                        warning = function(w) print(w$message)))
  )

  log <- last.tryCatchLog.result()

  expect_equal(NROW(log), 1, info = "only one warning")
  expect_equal(log$severity[1], "WARN")

})



test_that("a catched message does not bubble up after handling", {

  expect_output(tryCatchLog(tryCatchLog(tryCatchLog(message("throw.my.message")),
                                        message = function(m) print(m$message)))
  )

  log <- last.tryCatchLog.result()

  expect_equal(NROW(log), 1, info = "only one message")
  expect_equal(log$severity[1], "INFO")

})



test_that("a catched error does not bubble up after handling", {

  expect_output(tryCatchLog(tryCatchLog(tryCatchLog(stop("throw.my.error")),
                                        error = function(e) print(e$message)))
  )

  log <- last.tryCatchLog.result()

  expect_equal(NROW(log), 1, info = "only one error")
  expect_equal(log$severity[1], "ERROR")

})
