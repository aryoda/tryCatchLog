# Tests are run within the folder "tryCatchLog/tests/testthat".
# Clean it up at the beginning of a test!

library(testthat)



# Silent warnings -------------------------------------------------------------------------------------------------

context("test_silent_messages.R")



source("init_unit_test.R")



# suppress logging of errors and warnings to avoid overly output
source("disable_logging_output.R")



# Test implementations --------------------------------------------------------------------------------------------

test_that("Globally disabled silent messages throw a message if no parameter given", {
  expect_message(tryCatchLog(message("hello")))
  expect_message(tryLog(message("hello")))
})



test_that("Globally disabled silent messages throw a message if parameter says the same", {
  expect_message(tryCatchLog(message("hello"), silent.messages = FALSE))
  expect_message(tryLog(message("hello"), silent.messages = FALSE))
})



test_that("enabled silent messages throw a message", {
  expect_silent(tryCatchLog(message("hello"), silent.messages = TRUE))
  expect_silent(tryLog(message("hello"), silent.messages = TRUE))
})



options("tryCatchLog.silent.messages" = TRUE)



test_that("Globally enabled silent messages throws no message", {
  expect_silent(tryCatchLog(message("hello")))
  expect_silent(tryLog(message("hello")))
})


test_that("Globally enabled silent messages throws a message when overwritten via parameter", {
  expect_message(tryCatchLog(message("hello"), silent.messages = FALSE))
  expect_message(tryLog(message("hello"), silent.messages = FALSE))
})



# Some "cross checks"



test_that("warnings are thrown", {
  expect_warning(tryLog(log(-1)))
})



test_that("errors are silent but returned as object of 'try-error' class", {
  expect_silent(tryLog(log("a")))
  expect_equal(class(tryLog(log("a"))), "try-error")
  # expect_true("condition" %in% names(attributes(tryLog(log("a")))))
})



test_that("tryCatchLog did throw an error", {
  expect_error(tryCatchLog(log("abc"), error = stop))
})


