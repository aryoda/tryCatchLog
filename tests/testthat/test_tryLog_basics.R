# Basic tests of tryLog

# Tests are run within the folder "tryCatchLog/tests/testthat".
# Clean it up at the beginning of a test!

library(futile.logger)



# Basic tests -----------------------------------------------------------------------------------------------------

context("Basic tests of tryCatchLog")

# set up test context
options("tryCatchLog.dump.errors.to.file" = FALSE)    # global default setting for all tryCatchLog call params "dump.errors.to.file"
options("tryCatchLog.silent.warnings" = FALSE)

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




test_that("warnings are shown but do not stop execution", {
  expect_warning(tryLog(log(-1)))
})



test_that("errors are silent but returned as object of 'try-error' class", {
  expect_silent(tryLog(log("a")))
  expect_equal(class(tryLog(log("a"))), "try-error")
  # expect_true("condition" %in% names(attributes(tryLog(log("a")))))
})

