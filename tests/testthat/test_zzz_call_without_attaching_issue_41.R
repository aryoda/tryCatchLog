library(testthat)
# library(tryCatchLog)  # DO NOT LOAD THE PACKAGE (THIS IS THE TEST CASE PRECONDITION)
#                         But: tryCatchLog is loaded anyhow when testthat is loaded (since it knows the package under test ;-)


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



  # Issue "Can't detach package in tests":
  # "detach" IS NOT SUPPORTED BY DEVTOOLS, YOU HAVE TO RUN TESTTHAT WITHOUT DEVTOOLS FOR THIS:
  # https://github.com/r-lib/devtools/issues/1797
  # https://github.com/r-lib/testthat/issues/764
  # Note: If the package is not loaded calling "detach" throws an error: invalid 'name' argument
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
  #              expect_output(  # before futile.logger 1.4.5
  #              expect_message(   # since futile.logger 1.4.5
  # July 25, 2022: I have added "expect_output" again and used the new option "tryCatchLog.preferred.logging.package"
  #                in the "init_unit_test.R" script (globally used for all unit tests).
  #                to ensure "tryCatchLog" is used for logging in every test by default (which produces output!).
  expect_output(
    expect_error(tryCatchLog::tryCatchLog(stop("hello_error_message")),
                regexp = "hello_error_message",
                fixed = TRUE,
                info = "must throw the stop message, not an unexpected internal error")
  , info = "the logger must produce an output"
  )

  cat(tryCatchLog:::.tryCatchLog.env$active.logging.package)

  # load the namespace again to avoid side effects on other unit tests.
  # This must be done within the test_that function to prevent side effects on other tests (whyever)
  library(tryCatchLog)

})
