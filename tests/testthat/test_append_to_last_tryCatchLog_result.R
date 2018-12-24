# library(tryCatchLog)
# library(testthat)



context("test_append_to_last_tryCatchLog_result.R")



source("init_unit_test.R")



test_that("only data.frames can be appended", {
  
  tryCatchLog:::reset.last.tryCatchLog.result()   # internal function!
  
  expect_equal(last.tryCatchLog.result(), data.frame())
  
  expect_error(tryCatchLog:::append.to.last.tryCatchLog.result("this is not a data.frame"),
                "The actual value of the parameter 'new.log.entry' must be an object of the class 'data.frame'")
  
})
