library(testthat)
library(tryCatchLog)



context("test_get_pretty_tryCatchLog_options.R")



source("init_unit_test.R")




test_that("internal function get.pretty.option.value() works", {
  
  res <- tryCatchLog:::get.pretty.option.value("warn")
  
  # Should be: "Option warn = 0 (double)"
  expect_match(res, "Option warn = -?[0123456789]+ \\(double\\)")
  
  
  
  res2 <- tryCatchLog:::get.pretty.option.value("this.option does not exist for sure")
  
  expect_match(res2, "Option this.option does not exist for sure = (not set)", fixed = TRUE)
  
})



test_that("get.pretty.tryCatchLog.options() works", {
  
  res <- get.pretty.tryCatchLog.options()

  expected <- paste("Option tryCatchLog.write.error.dump.file = FALSE (logical)",
                    "Option tryCatchLog.write.error.folder = . (character)",
                    "Option tryCatchLog.silent.warnings = FALSE (logical)",
                    "Option tryCatchLog.silent.messages = FALSE (logical)",
                    sep = tryCatchLog::platform.NewLine())

  expect_equal(res, expected)

})
