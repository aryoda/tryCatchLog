library(testthat)
library(tryCatchLog)


context("test_platform_functions.R")



source("init_unit_test.R")



test_that("NewLine is working", {

  # new line string is initialized
  expect_true(tryCatchLog::platform.NewLine() %in% c("\n", "\r\n"))


  # test OS-specific newline of the OS the test running on
  is.windows <- grepl(tolower(.Platform$OS.type), "windows", fixed = TRUE)

  if (is.windows) {
    expect_equal(platform.NewLine(), "\r\n")
  }

  if (!is.windows) {
    expect_equal(platform.NewLine(), "\n")
  }

})



test_that("OS-specific newlines work", {

  # Simulate an OS to test all OS-specific newlines
  with_mock( `tryCatchLog::is.windows` = function() { return(TRUE) },
             expect_true(tryCatchLog::is.windows()),
             expect_equal(tryCatchLog:::determine.platform.NewLine(), "\r\n")
  )

  # Simulate an OS to test all OS-specific newlines
  with_mock( `tryCatchLog::is.windows` = function() { return(FALSE) },
             expect_false(tryCatchLog::is.windows()),
             expect_equal(tryCatchLog:::determine.platform.NewLine(), "\n")
  )

})
