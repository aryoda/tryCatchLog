library(testthat)
# library(tryCatchLog)  # do NOT load the library otherwise the test coverage is reported wrongly (not counted)


context("test_is_duplicated_log_entry.R")



source("init_unit_test.R")

tryCatchLog:::reset.last.tryCatchLog.result()   # internal function!


test_that("NULL value as log.entry argument is working", {

  tryCatchLog:::reset.last.tryCatchLog.result()   # internal function!

  # print(paste("last.tryCatchLog.result: ", str(last.tryCatchLog.result())))

  expect_equal(last.tryCatchLog.result(), data.frame())



  expect_true(tryCatchLog:::is.duplicated.log.entry(NULL))

  expect_error(tryCatchLog:::is.duplicated.log.entry("argument has invalid class"),
               "%in% class(log.entry) is not TRUE", fixed = TRUE)


})
