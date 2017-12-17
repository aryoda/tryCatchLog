library(testthat)
library(tryCatchLog)
# library(futile.logger)


context("package loading")



test_that("non-existing options are initialized when package is loaded", {

  # if the package is not loaded "detach" throws an error: invalid 'name' argument
  detach("package:tryCatchLog", character.only = TRUE, unload = TRUE)

  expect_false(isNamespaceLoaded("tryCatchLog"))



  # Unset the options
  options("tryCatchLog.write.error.dump.file" = NULL)
  options("tryCatchLog.silent.warnings"       = NULL)
  options("tryCatchLog.silent.messages"       = NULL)



  expect_null(getOption("tryCatchLog.write.error.dump.file"))
  expect_null(getOption("tryCatchLog.silent.warnings"))
  expect_null(getOption("tryCatchLog.silent.messages"))



  library(tryCatchLog)


  # tryCatchLog initializes all non-existing options to FALSE
  expect_false(getOption("tryCatchLog.write.error.dump.file"))
  expect_false(getOption("tryCatchLog.silent.warnings"))
  expect_false(getOption("tryCatchLog.silent.messages"))



  # new line string is initialized
  expect_true(tryCatchLog::platform.NewLine() %in% c("\n", "\r\n"))

})



test_that("existing options are left untouched when package is loaded", {

  # if the package is not loaded "detach" throws an error: invalid 'name' argument
  detach("package:tryCatchLog", character.only = TRUE, unload = TRUE)

  expect_false(isNamespaceLoaded("tryCatchLog"))



  # Unset the options
  options("tryCatchLog.write.error.dump.file" = TRUE)
  options("tryCatchLog.silent.warnings"       = TRUE)
  options("tryCatchLog.silent.messages"       = TRUE)



  expect_true(getOption("tryCatchLog.write.error.dump.file"))
  expect_true(getOption("tryCatchLog.silent.warnings"))
  expect_true(getOption("tryCatchLog.silent.messages"))



  library(tryCatchLog)


  expect_true(getOption("tryCatchLog.write.error.dump.file"))
  expect_true(getOption("tryCatchLog.silent.warnings"))
  expect_true(getOption("tryCatchLog.silent.messages"))

})

