library(testthat)



context("test_is_duplicated_log_entry.R")



source("init_unit_test.R")



test_that("NULL value as log.entry argument is working", {
  
  tryCatchLog:::reset.last.tryCatchLog.result()   # internal function!
  
  expect_equal(last.tryCatchLog.result(), data.frame())

  
  expect_true(tryCatchLog:::is.duplicated.log.entry(NULL))
  
  expect_error(tryCatchLog:::is.duplicated.log.entry("argument has invalid class"),
               "%in% class(log.entry) is not TRUE", fixed = TRUE)
  

})
