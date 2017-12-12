library(futile.logger)
library(tryCatchLog)
library(testthat)

context("silent stacked warnings")

# set up test context
options("tryCatchLog.write.error.dump.file" = FALSE)
options("tryCatchLog.silent.warnings"     = FALSE)
options("tryCatchLog.silent.messages"     = FALSE)



flog.threshold("FATAL")                         # suppress logging of errors and warnings to avoid overly output
# flog.threshold("INFO")



test_that("silent.warnings work with stacked handler", {

  # Test for bug #21 (Bubbled-up warnings should be silenced as promised)
  # https://github.com/aryoda/tryCatchLog/issues/21
  expect_silent(
    tryLog(
      tryLog(warning("my.warning")),
      silent.warnings = TRUE
    )
  )

  log <- last.tryCatchLog.result()

  expect_equal(NROW(log), 1)
  expect_equal(log[1,]$severity, "WARN")



  # Compare: This works as expected
  expect_silent(
    tryLog(
      tryLog(warning("my.warning"), silent.warnings = TRUE),
      silent.warnings = TRUE
    )
  )



  expect_silent(
    tryCatchLog(
      tryCatchLog(warning("my.warning")),
      silent.warnings = TRUE
    )
  )

  log <- last.tryCatchLog.result()

  expect_equal(NROW(log), 1)
  expect_equal(log[1,]$severity, "WARN")



  expect_warning(
    tryLog(
      tryLog(warning("my.warning")),
      silent.warnings = FALSE
    )
  )

  log <- last.tryCatchLog.result()

  expect_equal(NROW(log), 1)
  expect_equal(log[1,]$severity, "WARN")



  expect_warning(
    tryCatchLog(
      tryCatchLog(warning("my.warning")),
      silent.warnings = FALSE
    )
  )

  log <- last.tryCatchLog.result()

  expect_equal(NROW(log), 1)
  expect_equal(log[1,]$severity, "WARN")

})
