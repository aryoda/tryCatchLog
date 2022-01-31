library(testthat)
# library(tryCatchLog)  # DO NOT LOAD THE PACKAGE (THIS IS THE TEST CASE PRECONDITION)


context("test_call_without_attaching_issue_41.R")


# IMPORTANT:
# There is an issue in devtools with testthat: "Can't detach package in tests":
# https://github.com/r-lib/devtools/issues/1797
# As workaround I have name the file with "test_zzz*" so that it is executed at the end
# without affecting other later tests (so that I can run the tests sucessfully in RStudio with devtools)


source("init_unit_test.R")



# These tests do check the namespace hook functions (for details see "?.onLoad")
# These tests do NOT detach and reload the tryCatchLog package but call the hook functions directly.



test_that("tryCatchLog functions do work without attaching the package with 'library'", {

  # print("tryCatchLog" %in% .packages())   # https://stackoverflow.com/a/37668625



  # Disable these unit tests due to a problem in
  #  covr::package_coverage(type = "tests")"
  # See test_load_package.R for details!
  skip_if_not(("covr" %in% loadedNamespaces()) == FALSE, "This unit test is skipped during code coverage profiling with 'covr' due to a bug")
  skip_on_travis()  # since I am using travis CI on github to derive the code coverage with covr



  # If the package is not loaded "detach" throws an error: invalid 'name' argument
  # Jan 31, 2022 Why detach it if it is not loaded before (at least not obviously)?
  #              The detach() should always throw an error which is not wanted but obviously does not. Why?
  #
  # Issue "Can't detach package in tests":
  # THIS IS NOT SUPPORTED BY DEVTOOLS, YOU HAVE TO RUN TESTTHAT WITHOUT DEVTOOLS FOR THIS:
  # https://github.com/r-lib/devtools/issues/1797
  # https://github.com/r-lib/testthat/issues/764
  detach("package:tryCatchLog", character.only = TRUE, unload = TRUE)

  expect_false(isNamespaceLoaded("tryCatchLog"), info = "precondition failed: tryCatchLog package may not be attached")

  # NOTE:
  #
  # expect_output() no longer works after using futile.logger 1.4.5 or higher
  # since the log output is written via message() instead of cat() since then
  # except you set the ENV var 'FUTILE_LOGGER_LEGACY' to TRUE. See:
  # https://github.com/zatonovo/futile.logger/issues/91
  # Lesson learned: Unit tests should not depend on other packages (if possible)
  #                 since their semantics could change and break the unit test!
  # Jan 31, 2022 Since logging is not under test here I have disabled the log output expectation.
  # expect_output(  # before futile.logger 1.4.5
  # expect_message(   # since futile.logger 1.4.5
    expect_error(tryCatchLog::tryCatchLog(stop("hello_error_message")),
                  regexp = "hello_error_message",
                  fixed = TRUE,
                  info = "must throw the stop message, not an unexpected internal error")
  #   , info = "the logger must produce an output"
  # )

  # load the namespace again to avoid side effects on other unit tests.
  # This must be done within the test_that function to prevent side effects on other tests (whyever)
  library(tryCatchLog)

})
