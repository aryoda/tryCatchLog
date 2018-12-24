library(testthat)
library(tryCatchLog)



# Error in value[[3L]](cond) : unused argument (cond)
# https://github.com/aryoda/tryCatchLog/issues/17
context("test_issue_0017_value_3L_unused_arg.R")




source("init_unit_test.R")




# suppress logging of errors and warnings to avoid overly output
source("disable_logging_output.R")


test_that("error handler with one parameter works", {

  expect_output(
    tryCatchLog(
      stop("an error occured"),
      error = function(e) {
        print("no luck today")
      }
    ),
    "no luck today", fixed = TRUE)

})



test_that("error handler without any parameter throws an error", {

  # tryCatch throws an error so tryCatchLog must also throw an error in the error handler function has zero arguments
  expect_error(
    expect_output(
      tryCatchLog(
        stop("an error occured"),
        error = function() {
          print("no luck today")
        }
      ),
      "no luck today", fixed = TRUE),
    "unused argument (cond)", fixed = TRUE)

})



test_that("error handler with two parameters works", {

  expect_output(
    tryCatchLog(
      stop("an error occured"),
      error = function(e1, e2) {
        print("no luck today")
      }
    ),
    "no luck today", fixed = TRUE)

})



test_that("error handler with unwrapped 1-param R function does work", {

  y <- ""

  # tryCatch(stop("an error occured"), error = print)
  # <simpleError in doTryCatch(return(expr), name, parentenv, handler): an error occured>

  expect_output(
    y <- tryCatchLog(
      stop("an error occured"),
      error = print
    ),
    "<simpleError in", fixed = TRUE)

  expect_equal(y$message, "an error occured")
  expect_true("simpleError" %in% class(y))

})



# tryCatch throws an error so tryCatchLog must also throw an error in the error handler function has zero arguments
test_that("error handler with unwrapped 0-param R function does throw an error", {

  expect_error(
    tryCatchLog(
      stop("an error occured"),
      error = geterrmessage    # has no parameter (at least in R version 3.4.2 :-)
    ),
  "unused argument (cond)", fixed = TRUE)    # Error in value[[3L]](cond) : unused argument (cond)

})



test_that("NULL error handler is recognized as invalid parameter", {

  # tryCatch(stop("an error occured", error = NULL))
  # Error in tryCatchList(expr, classes, parentenv, handlers) :
  #   an error occured
  # tryCatchLog(stop("an error occured"), error = function(e) {invisible(TRUE)})
  # tryCatchLog(stop("an error occured"), error = stop)

  # changed semantics since 0.9.6: tryCatchLog does not recognize NULL but leaves this to tryCatch
  expect_error(
    tryCatchLog(
      stop("an error occured"),
      error = NULL
    ),
    "attempt to apply non-function",
    fixed = TRUE
  )

})



test_that("stop as wrapped error handler stops in tryCatch", {

  # tryCatch(stop("an error occured"), error = function(e) stop("Another error")) # Error in value[[3L]](cond) : Another error

  expect_error(
    tryCatchLog(
      stop("an error occured"),
      error = function(e) stop("Another error")
    ),
    "Another error", fixed = TRUE
  )

})




# # TODO Debug this using RStudio which shows different behaviour caused by the injected error handler...
# tryCatchLog(log("a"))
# tryCatchLog(log("a"), error = NULL)
# tryCatchLog(log("a"), error = print("error"), finally = print("end"))
# tryCatchLog(stop("error"))
# tryCatchLog(stop("error"), error = stop)
# tryCatch(stop("a"), error = function() print("error found"))
#
# tryCatch(stop(e), finally = print("Hello"))
# tryCatch(1, finally = print("Hello"))
# tryCatch(stop(e), error = print("error"), finally = print("Hello"))
#
# # Error in value[[3L]](cond) : attempt to apply non-function
# # Error during wrapup:
