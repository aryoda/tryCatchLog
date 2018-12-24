library(testthat)



context("test_is_windows.R")



source("init_unit_test.R")



test_that("conflict in Windows OS recognition throws a warning", {

  # qualified func names are required otherwise R CMD CHECK will fail in testthat
  # (not finding the functions)
  with_mock(
      `tryCatchLog:::get.sys.name`         = function() return("windows"),
      `tryCatchLog:::get.platform.OS.type` = function() return("Clever OS"),
      expect_warning(tryCatchLog:::is.windows(),
                     "could not be recognized for sure", fixed = TRUE)
  )

})
  
