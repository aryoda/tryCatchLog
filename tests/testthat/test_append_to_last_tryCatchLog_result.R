# library(futile.logger)
# library(tryCatchLog)
# library(testthat)



context("append.to.last.tryCatchLog.result")

# set up test context
options("tryCatchLog.write.error.dump.file" = FALSE)
options("tryCatchLog.silent.warnings"     = FALSE)
options("tryCatchLog.silent.messages"     = FALSE)



# flog.threshold("FATAL")                         # suppress logging of errors and warnings to avoid overly output
# flog.threshold("INFO")




test_that("only data.frames can be appended", {
  
  tryCatchLog:::reset.last.tryCatchLog.result()   # internal function!
  
  expect_equal(last.tryCatchLog.result(), data.frame())
  
  expect_error(tryCatchLog:::append.to.last.tryCatchLog.result("this is not a data.frame"),
                "The actual value of the parameter 'new.log.entry' must be an object of the class 'data.frame'")
  
})
