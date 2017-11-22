# Basic tests of tryCatchLog

# Tests are run within the folder "tryCatchLog/tests/testthat".
# Clean it up at the beginning of a test!

library(futile.logger)



# Basic tests -----------------------------------------------------------------------------------------------------

context("tryCatchLog basics")



# set up test context
options("tryCatchLog.dump.errors.to.file" = FALSE)    # global default setting for all tryCatchLog call params "dump.errors.to.file"
options("tryCatchLog.silent.warnings" = FALSE)
options("tryCatchLog.silent.messages" = FALSE)



flog.threshold("FATAL")                               # suppress logging of errors and warnings to avoid overly output



test_that("log(-1) did throw a warning", {
  expect_warning(log(-1))
})

test_that("log('abc') did throw an error", {
  expect_error(log("abc"))
})

# https://stackoverflow.com/questions/22003306/is-there-something-in-testthat-like-expect-no-warnings/33638939#33638939

test_that("tryCatchLog creates no warning", {
  expect_silent(tryCatchLog(log(1)))
})

test_that("tryCatchLog did throw a warning", {
  expect_warning(tryCatchLog(log(-1)))
})

test_that("tryCatchLog did throw an error", {
  expect_error(tryCatchLog(log("abc"), error = stop))
})


test_that("tryCatchLog did call the error handler", {
  expect_equal(2, tryCatchLog({
    flag <- 1
    log("abc")
    flag <- 3
  },
  error = function(e) {
    flag <<- 2
  }))
})



test_that("tryCatchLog with warning continues", {
  withCallingHandlers(
    tryCatchLog({
      did.warn <- FALSE
      flag <- 1
      log(-1)
      flag <- 2
    })
    ,
    warning = function(w) {
      did.warn <<-
        TRUE
      invokeRestart("muffleWarning")
    }
  )    # restart = continue without a warning

  expect_equal(2, flag)
  expect_true(did.warn)
})




test_that("tryCatchLog with message continues", {
  withCallingHandlers(
    tryCatchLog({
      msg.sent <- FALSE
      did.continue <- FALSE
      throw.msg <- function()
        message("read this message!")
      throw.msg()
      did.continue <- TRUE
    })
    ,
    message = function(w) {
      msg.sent <<-
        TRUE
      invokeRestart("muffleMessage")
    }
  )   # restart = continue without a message

  expect_true(did.continue)
  expect_true(msg.sent)
})



# https://stackoverflow.com/questions/36332845/how-to-test-for-a-message-and-an-error-message-simultaneously-in-r-testthat
# How to catch error and check output?
test_that("tryCatchLog stops with an error and called the outer error function", {
  # options(error = stop)
  tryCatch(
    tryCatchLog({
        did.raise.err <- FALSE
        canceled <- TRUE
        log("a")
        canceled <- FALSE  # should never run (error shall cancel)
      },
      error = stop),
    error = function(e) {
      did.raise.err <<- TRUE
    }
  )

  expect_true(canceled)
  expect_true(did.raise.err)
})
