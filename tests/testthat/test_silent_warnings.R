# Tests are run within the folder "tryCatchLog/tests/testthat".
# Clean it up at the beginning of a test!

library(testthat)



# Silent warnings -------------------------------------------------------------------------------------------------

context("test_silent_warnings.R")



source("init_unit_test.R")



# suppress logging of errors and warnings to avoid overly output
source("disable_logging_output.R")



# Test implementations --------------------------------------------------------------------------------------------

test_that("Globally disabled silent warnings throw a warning if no parameter given", {
  expect_warning(tryCatchLog(log(-1)))
  expect_warning(tryLog(log(-1)))
})



test_that("Globally disabled silent warnings throw a warning if parameter says the same", {
  expect_warning(tryCatchLog(log(-1), silent.warnings = FALSE))
  expect_warning(tryLog(log(-1), silent.warnings = FALSE))
})



test_that("enabled silent warnings throw a warning", {
  expect_silent(tryCatchLog(log(-1), silent.warnings = TRUE))
  expect_silent(tryLog(log(-1), silent.warnings = TRUE))
})




# CHANGE OF OPTIONS !!! -------------------------------------------------------------------------------------------
options("tryCatchLog.silent.warnings" = TRUE)
# CHANGE OF OPTIONS !!! -------------------------------------------------------------------------------------------



test_that("Globally enabled silent warnings throws no warning", {
  expect_silent(tryCatchLog(log(-1)))
  expect_silent(tryLog(log(-1)))
})


test_that("Globally enabled silent warnings throws a warning when overwritten via parameter", {
  expect_warning(tryCatchLog(log(-1), silent.warnings = FALSE))
  expect_warning(tryLog(log(-1), silent.warnings = FALSE))
})



# Some "cross checks"



test_that("errors are silent but returned as object of 'try-error' class", {
  expect_silent(tryLog(log("a")))
  expect_equal(class(tryLog(log("a"))), "try-error")
  # expect_true("condition" %in% names(attributes(tryLog(log("a")))))
})



test_that("tryCatchLog did throw an error", {
  expect_error(tryCatchLog(log("abc"), error = stop))
})



# clean-up test setup ---------------------------------------------------------------------------------------------
options("tryCatchLog.write.error.dump.file" = FALSE)    # global default setting for all tryCatchLog call params "write.error.dump.file"
options("tryCatchLog.write.error.dump.folder" = ".")
options("tryCatchLog.silent.warnings" = FALSE)
options("tryCatchLog.silent.messages" = FALSE)



