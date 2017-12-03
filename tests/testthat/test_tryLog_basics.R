library(tryCatchLog)
library(testthat)
library(futile.logger)

# Basic tests of tryLog

# Tests are run within the folder "tryCatchLog/tests/testthat".
# Clean it up at the beginning of a test!




# Basic tests -----------------------------------------------------------------------------------------------------

context("tryLog")

# set up test context
options("tryCatchLog.dump.errors.to.file" = FALSE)    # global default setting for all tryCatchLog call params "dump.errors.to.file"
options("tryCatchLog.silent.warnings" = FALSE)
options("tryCatchLog.silent.messages" = FALSE)



flog.threshold("FATAL")                               # suppress logging of errors and warnings to avoid overly output



test_that("successful expression is silent", {
  expect_equal(tryLog(1 + 2), 3)
  expect_silent(tryLog(2 + 3))
  expect_equal(typeof(tryLog(1 + 2)), "double")
  expect_equal(class(tryLog(1 + 2)), "numeric")
  expect_equal(typeof(try(paste("a", "b"))
  ), "character")
})



test_that("warnings are shown and return value is produced", {
  expect_warning(tryLog(log(-1)))
  expect_warning({
    result <-
      try(log(-1))
    # NaN (double) = as.double("NaN")
    expect_equal(tryLog(log(-1)), result)
  })
})




test_that("warnings are thrown", {
  expect_warning(tryLog(log(-1)))
})



test_that("errors are silent but returned as object of 'try-error' class", {
  expect_silent(tryLog(log("a")))
  expect_equal(class(tryLog(log("a"))), "try-error")
  # expect_true("condition" %in% names(attributes(tryLog(log("a")))))
})



test_that("conditions do not bubble up to higher-level handlers", {

  # error may not bubble up
  expect_silent(tryCatchLog(tryLog(stop("simulated error")), error = function(e) stop("should never be called")))
  log <- last.tryCatchLog.result()
  expect_equal(NROW(log), 1)



  # Warning must bubble up
  expect_error(tryCatchLog(
                 tryLog(warning("simulated warning")),
                 warning = function(e) stop("warning handler called as expected")),
               "warning handler called as expected", fixed = TRUE)
  log <- last.tryCatchLog.result()
  expect_equal(NROW(log), 1)



  # Silent warning may not bubble up
  expect_silent(tryCatchLog(
    tryLog(warning("simulated warning"), silent.warnings = TRUE),
    warning = function(w) stop("warning handler may not be called"))
  )
  log <- last.tryCatchLog.result()
  expect_equal(NROW(log), 1)


  # Silent message may not bubble up
  expect_silent(tryCatchLog(
    tryLog(message("simulated message"), silent.messages = TRUE),
    message = function(m) stop("message handler may not be called"))
  )
  log <- last.tryCatchLog.result()
  expect_equal(NROW(log), 1)


})
