# library(tryCatchLog)
library(testthat)



context("test_limited_Labels_Compact.R")



source("init_unit_test.R")



# suppress logging of errors and warnings to avoid overly output
# source("disable_logging_output.R")



test_that("maxwidth argument ensures width limits", {

  string.pattern <- "123456789 "

  # maxwidth at least 40 chars
  call.stack <- call("a.function", paste(rep(string.pattern, 5), collapse = ""))
  res <- tryCatchLog:::limitedLabelsCompact(call.stack, compact = FALSE, maxwidth = 10)

  expect_equal(res[2], paste(rep(string.pattern, 4), collapse = ""), info = "maxwidth is set to 40 chars if smaller")



  # maxwidth cutted to 1000 characters
  call.stack <- call("a.function", paste(rep(string.pattern, 250), collapse = ""))
  res <- tryCatchLog:::limitedLabelsCompact(call.stack, compact = FALSE, maxwidth = 9999)

  expect_equal(res[2], paste(rep(string.pattern, 200), collapse = ""), info = "maxwidth is cut after 2000 chars")

})
