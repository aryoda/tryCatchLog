# library(futile.logger)
# library(tryCatchLog)
# library(testthat)



context("is.windows")

# set up test context
options("tryCatchLog.write.error.dump.file" = FALSE)
options("tryCatchLog.silent.warnings"     = FALSE)
options("tryCatchLog.silent.messages"     = FALSE)



# flog.threshold("FATAL")                         # suppress logging of errors and warnings to avoid overly output
# flog.threshold("INFO")



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
  
