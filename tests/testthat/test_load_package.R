library(testthat)
library(tryCatchLog)


context("test_load_package.R")



source("init_unit_test.R")



# Disable these unit tests due to a bug in
#  covr::package_coverage(type = "tests")"
# # Error: identical(names(y), names) is not TRUE
# The error is thrown in the function "merge_coverage" (https://github.com/r-lib/covr/blob/master/R/covr.R)
# and most probably caused by detaching and reloading the package in this test which causes
# the order of elements in the files to be changed.
# Note: I am using skip_if_not instead of skip_if to support old testthat versions (e. g. 1.0.2)
skip_if_not(("covr" %in% loadedNamespaces()) == FALSE, "This unit test is skipped during code coverage profiling with 'covr' due to a bug")
# TODO Open an issue at https://github.com/r-lib/covr and propose ordering the file contents before checking identify:
#      names[order(names)] == names(y)[order(names(y))]



test_that("non-existing options are initialized when package is loaded", {

  # if the package is not loaded "detach" throws an error: invalid 'name' argument
  detach("package:tryCatchLog", character.only = TRUE, unload = TRUE)

  expect_false(isNamespaceLoaded("tryCatchLog"))



  # Unset the options
  options("tryCatchLog.write.error.dump.file" = NULL)
  options("tryCatchLog.write.error.dump.folder" = ".")
  options("tryCatchLog.silent.warnings"       = NULL)
  options("tryCatchLog.silent.messages"       = NULL)



  expect_null(getOption("tryCatchLog.write.error.dump.file"))
  expect_equal(getOption("tryCatchLog.write.error.dump.folder"), ".")
  expect_null(getOption("tryCatchLog.silent.warnings"))
  expect_null(getOption("tryCatchLog.silent.messages"))



  library(tryCatchLog)


  # tryCatchLog initializes all non-existing options to FALSE
  expect_false(getOption("tryCatchLog.write.error.dump.file"))
  expect_equal(getOption("tryCatchLog.write.error.dump.folder"), ".")
  expect_false(getOption("tryCatchLog.silent.warnings"))
  expect_false(getOption("tryCatchLog.silent.messages"))



  # new line string is initialized
  expect_true(tryCatchLog::platform.NewLine() %in% c("\n", "\r\n"))

})



test_that("existing options are left untouched when package is loaded", {

  # if the package is not loaded "detach" throws an error: invalid 'name' argument
  detach("package:tryCatchLog", character.only = TRUE, unload = TRUE)

  expect_false(isNamespaceLoaded("tryCatchLog"))



  # Preset the options
  options("tryCatchLog.write.error.dump.file" = TRUE)
  options("tryCatchLog.write.error.dump.folder" = ".")
  options("tryCatchLog.silent.warnings"       = TRUE)
  options("tryCatchLog.silent.messages"       = TRUE)



  expect_true(getOption("tryCatchLog.write.error.dump.file"))
  expect_equal(getOption("tryCatchLog.write.error.dump.folder"), ".")
  expect_true(getOption("tryCatchLog.silent.warnings"))
  expect_true(getOption("tryCatchLog.silent.messages"))



  library(tryCatchLog)


  expect_true(getOption("tryCatchLog.write.error.dump.file"))
  expect_equal(getOption("tryCatchLog.write.error.dump.folder"), ".")
  expect_true(getOption("tryCatchLog.silent.warnings"))
  expect_true(getOption("tryCatchLog.silent.messages"))

})

