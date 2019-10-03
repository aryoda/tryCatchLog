library(tryCatchLog)
library(testthat)

# Test call stack suppression introduced in v1.1.5 (feature request #44).
# Since tryLog() calls tryCatchLog() internally it suffice to test tryLog.



context("test_call_stack_suppression.R")



source("init_unit_test.R")



options("width" = 129)  # default value in R is 129



# suppress logging of errors and warnings to avoid overly output
# source("disable_logging_output.R")
# enable tryCatchLog's default logging to the console so that expect_output() works
set.logging.functions()    # Default: Activate the package-internal minimal logging functions


test_that("call stack 'include*' args works", {

  expect_warning(
    expect_output(
      tryLog(log(-1), include.full.call.stack = T, include.compact.call.stack = T)
      , "Compact call stack:"
      , fixed = TRUE)
  )

  expect_warning(
    expect_output(
      tryLog(log(-1), include.full.call.stack = F, include.compact.call.stack = T)
      , "Compact call stack:"
      , fixed = TRUE)
  )

  expect_warning(
    expect_output(
      tryLog(log(-1), include.full.call.stack = T, include.compact.call.stack = T)
      , "Full call stack:"
      , fixed = TRUE)
  )

  expect_warning(
    expect_output(
      tryLog(log(-1), include.full.call.stack = T, include.compact.call.stack = F)
      , "Full call stack:"
      , fixed = TRUE)
  )

})




test_that("contains only included call stacks", {

  # Note: RegExps are not very strong to recognize "not contained".
  #       This is achieved by using
  #           ^((?!searchword)(.|\n|\r))*$
  #       where "searchword" is the text expression that shall not be included.
  #       It works using a look-ahead of the unwanted searchword and matches only
  #       if the searchword is not found.
  #           (?!searchword)  =  look ahead to be sure the searchword is not found...
  #       The new line (\n) and carriage return (\r) must also be consumed as a character
  #       to match the complete end of string with $


  # Simple "does not contain" example
  # expect_output(cat("hello world"), "^((?!bye).)*$", perl = TRUE)

  expect_output(
    tryLog(log(-1), include.full.call.stack = T, include.compact.call.stack = F, silent.warnings = TRUE)
    , "^((?!Compact call stack)(.|\\n|\\r))*$", perl = TRUE)

  expect_warning(
    expect_output(
      tryLog(log(-1), include.full.call.stack = F, include.compact.call.stack = T)
      , "^((?!Full call stack)(.|\\n|\\r))*$", perl = TRUE)
  )

})



test_that("suppressed call stack is still visible in last.tryCatchLog.result", {

  expect_output(
      # just to capture the output which would polute the test summary otherwise
      tryLog(log(-1), include.full.call.stack = F, include.compact.call.stack = F, silent.warnings = T)
  )

  x <- last.tryCatchLog.result()

  expect_equal(NROW(x), 1)

  expect_is(x$compact.stack.trace, "character", info = "compact stack trace must always be in the last.tryCatchLog.result")
  expect_is(x$full.stack.trace, "character", info = "full stack trace must always be in the last.tryCatchLog.result")

})




#
# tryCatchLog(log(-1), include.full.call.stack = F)
# tryCatchLog(log(-1), include.full.call.stack = F, include.compact.call.stack = F)
#
#
# tryLog(log(-1), include.full.call.stack = T, include.compact.call.stack = T)
# tryLog(log(-1), include.full.call.stack = F)
# tryLog(log(-1), include.full.call.stack = F, include.compact.call.stack = F)
#
# log(-1)
#
# flog.threshold(ERROR)
# flog.threshold(INFO)
# library(futile.logger)
# ?flog.threshold
#
# x <- tryCatchLog::last.tryCatchLog.result()
