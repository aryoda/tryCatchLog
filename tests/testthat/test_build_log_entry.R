library(testthat)
library(tryCatchLog)



context("test_build_log_entry.R")



source("init_unit_test.R")



options("width" = 1000)  # default is 129



# suppress logging of errors and warnings to avoid overly output
source("disable_logging_output.R")




test_that("basics", {

  stack.trace <- sys.calls()

  log.entry <- tryCatchLog:::build.log.entry(Sys.time(), "ERROR", "Message in a bottle", "context", stack.trace, "", 0)

  expect_s3_class(log.entry, "data.frame")
  expect_s3_class(log.entry, "tryCatchLog.log.entry")

  expect_equal(log.entry$severity, "ERROR")
  expect_equal(log.entry$msg.text, "Message in a bottle")
  expect_equal(log.entry$execution.context.msg, "context")

})



test_that("stack trace is correct", {

  # The example stack trace was produced and saved with:
  # tryLog(log("abc")) # with breakpoint in the function "tryCatchLog" to save the internal variable "call.stack"
  # save(stack.trace, file = "stack_trace.RData")
  # load("tests/testthat/stack_trace.RData")
  load("stack_trace.RData")

  timestamp <- Sys.time()

  log.entry <- tryCatchLog:::build.log.entry(timestamp, "ERROR", "msg", "", stack.trace, "", 0)

  expect_equal(log.entry$timestamp, timestamp)
  expect_equal(log.entry$severity, "ERROR")
  expect_equal(log.entry$msg.text, "msg")
  expect_equal(log.entry$execution.context.msg, "")

  expect_equal(log.entry$compact.stack.trace,
               paste0("  1 tryLog(log(\"abc\"))\n",
                      "  2 tryLog.R#49: tryCatchLog(expr = expr, dump.errors.to.file = dump.errors.to.file, error = function(e) {\n",
                      "  3 tryCatchLog.R#135: tryCatch(withCallingHandlers(expr, error = function(e) {"
               )
  )



  expected_FST <- paste(readLines("expected_full_stack_trace.txt"), collapse = "\n")
  # writeLines(log.entry$full.stack.trace, "expected_full_stack_trace.txt")  # to write the expected result after checking it manually
  expect_equal(log.entry$full.stack.trace, expected_FST, "full stack trace")



  log.entry <- tryCatchLog:::build.log.entry(Sys.time(), "ERROR", "msg", "", stack.trace, "", 6)

  expect_equal(log.entry$compact.stack.trace,
               paste0("  1 tryLog(log(\"abc\"))\n",
                      "  2 tryLog.R#49: tryCatchLog(expr = expr, dump.errors.to.file = dump.errors.to.file, error = function(e) {\n",
                      "  3 tryCatchLog.R#135: tryCatch(withCallingHandlers(expr, error = function(e) {"
               )
  )

  log.entry <- tryCatchLog:::build.log.entry(Sys.time(), "ERROR", "msg", "", stack.trace, "", 7)

  expect_equal(log.entry$compact.stack.trace,
               paste0("  1 tryLog(log(\"abc\"))\n",
                      "  2 tryLog.R#49: tryCatchLog(expr = expr, dump.errors.to.file = dump.errors.to.file, error = function(e) {"
               )
  )

})


test_that("invalid execution.context.msg values are recognized", {

  expect_error(tryCatchLog:::build.log.entry(Sys.time(), "ERROR", "msg", 123, NA, "", 0), regexp = "is.character(execution.context.msg)", fixed = T)

  expect_error(tryCatchLog:::build.log.entry(Sys.time(), "ERROR", "msg", NA, NA, "", 0), regexp = "is.character(execution.context.msg)", fixed = T)

  expect_silent(tryCatchLog:::build.log.entry(Sys.time(), "ERROR", "msg", NA_character_, NA, "", 0))

  expect_error(tryCatchLog:::build.log.entry(Sys.time(), "ERROR", "msg", c("ctx1", "ctx2"), NA, "", 0), regexp = "length(execution.context.msg) == 1", fixed = T)

  expect_error(tryCatchLog:::build.log.entry(Sys.time(), "ERROR", "msg", NULL, NA, "", 0), regexp = "length(execution.context.msg) == 1", fixed = T)

})
