# library(futile.logger)
# library(tryCatchLog)
# library(testthat)



context("is.duplicated.log.entry")

# set up test context
options("tryCatchLog.write.error.dump.file" = FALSE)
options("tryCatchLog.silent.warnings"     = FALSE)
options("tryCatchLog.silent.messages"     = FALSE)



# flog.threshold("FATAL")                         # suppress logging of errors and warnings to avoid overly output
# flog.threshold("INFO")



test_that("NULL value as log.entry argument is working", {
  
  tryCatchLog:::reset.last.tryCatchLog.result()   # internal function!
  
  expect_equal(last.tryCatchLog.result(), data.frame())

  
  expect_true(tryCatchLog:::is.duplicated.log.entry(NULL))
  
  expect_error(tryCatchLog:::is.duplicated.log.entry("argument has invalid class"),
               "%in% class(log.entry) is not TRUE", fixed = TRUE)
  

})
