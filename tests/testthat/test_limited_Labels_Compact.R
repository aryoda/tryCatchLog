# library(futile.logger)
# library(tryCatchLog)
# library(testthat)



context("limitedLabelsCompact")

# set up test context
options("tryCatchLog.write.error.dump.file" = FALSE)
options("tryCatchLog.silent.warnings"     = FALSE)
options("tryCatchLog.silent.messages"     = FALSE)



# flog.threshold("FATAL")                         # suppress logging of errors and warnings to avoid overly output
# flog.threshold("INFO")



test_that("maxwidth argument ensures width limits", {
  
  string.pattern <- "123456789 "

  # maxwidth at least 40 chars
  call.stack <- call("a.function", paste(rep(string.pattern, 5), collapse = ""))
  res <- tryCatchLog:::limitedLabelsCompact(call.stack, compact = FALSE, maxwidth = 10)
  
  expect_equal(res[2], paste(rep(string.pattern, 4), collapse = ""), info = "maxwidth is set to 40 chars if smaller")
  
  
  
  # maxwidth cutted to 1000 characters
  call.stack <- call("a.function", paste(rep(string.pattern, 110), collapse = ""))
  res <- tryCatchLog:::limitedLabelsCompact(call.stack, compact = FALSE, maxwidth = 9999)
  
  expect_equal(res[2], paste(rep(string.pattern, 100), collapse = ""), info = "maxwidth is cutted after 1000 chars")
  
})


