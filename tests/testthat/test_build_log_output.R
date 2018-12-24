library(tryCatchLog)
library(testthat)



context("test_build_log_output.R")



source("init_unit_test.R")



options("width" = 129)  # default value in R is 129



# suppress logging of errors and warnings to avoid overly output
source("disable_logging_output.R")



test_that("log output is correct", {

  # The example stack trace was produced and saved with:
  # tryLog(log("abc")) # with breakpoint in the function "tryCatchLog" to save the internal variable "call.stack"
  # save(stack.trace, file = "stack_trace.RData")
  # load("tests/testthat/stack_trace.RData")
  load("stack_trace.RData")  # creates variable "stack.trace"

  log.entry <- tryCatchLog:::build.log.entry(Sys.time(), "ERROR", "msg", stack.trace, "", 0)

  out1 <- tryCatchLog::build.log.output(log.entry, include.full.call.stack = FALSE)
  # Due to a OSX bug R emits a warning in versions below 3.4.3 here:
  #   In as.POSIXlt.POSIXct(x, tz) : unknown timezone 'default/Europe/Berlin'
  # The reason is that the default timezone cannot be recognized by R anymore due to an OSX update.
  # Symptom:   Sys.timezone()  # returns NA instead of a timezone string
  # See https://stackoverflow.com/questions/47709061/sys-date-showing-the-wrong-date

  # cat(out1)   # how it looks like
  expected1 <- "[ERROR] msg\n\nCompact call stack:\n  1 tryLog(log(\"abc\"))\n  2 tryLog.R#49: tryCatchLog(expr = expr, dump.errors.to.file = dump.errors.to.file, error = function(e) {\n  3 tryCatchLog.R#135: tryCatch(withCallingHandlers(expr, error = function(e) {\n\n"

  expect_equal(out1, expected1, info = "include.full.call.stack = FALSE")



  out2 <- tryCatchLog::build.log.output(log.entry, include.full.call.stack = TRUE)
  # expected2 <- paste(readLines("tests/testthat/build_log_output_test_data_2.txt"), collapse = "\n")
  expected2 <- paste(readLines("build_log_output_test_data_2.txt"), collapse = "\n")
  # writeLines(out2, "build_log_output_test_data_2.txt")  # to write the expected result after checking it manually

  expect_equal(out2, expected2, info = "include.full.call.stack = TRUE")



  out3 <- tryCatchLog::build.log.output(log.entry)  # default is include.full.call.stack = TRUE
  expect_equal(out3, expected2, info = "default value of include.full.call.stack")  # same expected result as before



  log.entry$dump.file.name = "my.dump.file123.rda"
  out4 <- tryCatchLog::build.log.output(log.entry)
  expect_match(out4, "Created dump file: my.dump.file123.rda", fixed = TRUE, info = "dump file name is in output")



  expect_equal(tryCatchLog::build.log.output(data.frame()), "", info = "empty log -> empty output")



  expect_error(tryCatchLog::build.log.output(""), "\"data.frame\" %in% class(log.results) is not TRUE", fixed = TRUE)

})




test_that("multiple log entry rows work", {

  expect_error(expect_warning(tryCatchLog({log(-1); log("abc")})))

  log.entries <- last.tryCatchLog.result()

  expect_equal(NROW(log.entries), 2)

  out1 <- build.log.output(log.entries)
  # out1a <- build.log.output(log.entries, include.full.call.stack = FALSE)

  expect_match(out1, ".*\\[WARN\\] NaNs produced.*\\[ERROR\\] non-numeric argument to mathematical function.*")


})



test_that("include args do work", {

  timestamp <- as.POSIXct("12/31/2010 9:00", format = "%m/%d/%Y %H:%M")
  log.entry <- tryCatchLog:::build.log.entry(timestamp, "ERROR", "MESSAGE", NULL, "dump_123.rda", 0)

  out <- build.log.output(log.entry, include.severity = TRUE, include.timestamp = TRUE)
  expect_equal(out, "2010-12-31 09:00:00 [ERROR] MESSAGE\n\nCreated dump file: dump_123.rda\n\nCompact call stack:\n\n\nFull call stack:\n\n\n")

  out <- build.log.output(log.entry, include.severity = FALSE, include.timestamp = TRUE)
  expect_equal(out, "2010-12-31 09:00:00 MESSAGE\n\nCreated dump file: dump_123.rda\n\nCompact call stack:\n\n\nFull call stack:\n\n\n")


  out <- build.log.output(log.entry)
  expect_equal(out, "[ERROR] MESSAGE\n\nCreated dump file: dump_123.rda\n\nCompact call stack:\n\n\nFull call stack:\n\n\n")

  out <- build.log.output(log.entry, include.severity = FALSE)
  expect_false(grepl("ERROR", out, fixed = TRUE))

  out <- build.log.output(log.entry, include.timestamp = TRUE)
  expect_true(grepl("2010-12-31 09:00:00", out, fixed = TRUE))

})



test_that("platform-specific newline works", {

  log.entry <- tryCatchLog:::build.log.entry(Sys.time(), "ERROR", "MESSAGE", "stack.trace", "dump.file.name", 0)
  out <- build.log.output(log.entry)

  expect_true(grepl("\n", out, fixed = TRUE))



  with_mock(
    platform.NewLine = function() return("<platform_newline>"),
    # print(tryCatchLog::platform.NewLine()),
    out <- build.log.output(log.entry, use.platform.newline = TRUE),
    # print(out),
    expect_false(grepl("\n", out, fixed = TRUE)),
    expect_true(grepl("<platform_newline>", out, fixed = TRUE))
  )

})
