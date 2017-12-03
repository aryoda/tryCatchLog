# Tests to verify unchanged semantics of base R's tryCatch error handler logic
# which is mimicked by tryCatchLog

library(testthat)
library(tryCatchLog)
library(futile.logger)



# inits -----------------------------------------------------------------------------------------------------------

context("tryCatch semantics")



# do restore changed error option at the end
saved.options <- getOption("error")
on.exit(options(error = saved.options))



# set up test context
options("tryCatchLog.dump.errors.to.file" = FALSE)    # global default setting for all tryCatchLog call params "dump.errors.to.file"
options("tryCatchLog.silent.warnings" = FALSE)
options("tryCatchLog.silent.messages" = FALSE)



flog.threshold("FATAL")                               # suppress logging of errors and warnings to avoid overly output



# tests -----------------------------------------------------------------------------------------------------------

options(error = NULL)

test_that("error option NULL is consistent", {

  expect_error(
    stop("stop now"),
    "stop now",
    fixed = TRUE
  )

  expect_equal(
    geterrmessage(),
    "stop now",
    fixed = TRUE
  )

})



options(error = quote(print("option error called")))

test_that("quoted function as handler in error option is consistent", {

  expect_error(
    stop("stop now"),
    "stop now",
    fixed = TRUE,
    info = "changed error option may not change this behaviour"
  )

  expect_equal(
    geterrmessage(),
    "stop now",
    fixed = TRUE
  )


  # Must throw an error and print output via option error handler
  expect_error(
    expect_output(
      stop("stop now"),
      "option error called",
      fixed = TRUE
    ),
    "stop now",
    fixed = TRUE
  )

})



test_that("tryCatch and tryCatchLog have same error handler semantics", {

  # Must still throw an error
  expect_error(
    tryCatch(stop("stop now")),
    "stop now",
    fixed = TRUE
  )

  # Must throw an error and print output via option error handler
  expect_error(
    expect_output(
      tryCatch(stop("stop now")),
      "option error called",
      fixed = TRUE
    ),
    "stop now",
    fixed = TRUE
  )

  # Must throw an error and print output via option error handler
  expect_error(
    expect_output(
      tryCatchLog(stop("stop now")),
      "option error called",
      fixed = TRUE
    ),
    "stop now",
    fixed = TRUE
  )

  # Must throw an error (sub test of above for debugging purposes)
  expect_error(
    tryCatchLog(stop("stop now")),
    "stop now",
    fixed = TRUE
  )



  # Must throw: # Error in value[[3L]](cond) : attempt to apply non-function
  expect_error(
   tryCatch(stop("stop now"), error = NULL),
   "attempt to apply non-function",
   fixed = TRUE
  )

  # Must throw: # Error in value[[3L]](cond) : attempt to apply non-function
  expect_error(
    tryCatchLog(stop("stop now"), error = NULL),
    "attempt to apply non-function",
    fixed = TRUE
  )

})



test_that("stack tryCatch calls work unchanged", {

  # the first warning handler "swallows" the warning and stops it to bubble up further
  expect_output(
    tryCatch(tryCatch(log(-1)),
             warning = function(w) print(paste("outer warning: ", w))
    ),
    # [1] "outer warning:  simpleWarning in log(-1): NaNs produced\n"
    "outer warning:",
    fixed = TRUE
  )

  # Compare: The first warning handler "swallows" the warning and stops it to bubble up further
  expect_output(
    tryCatch(tryCatch(log(-1),
                      warning = function(w) print(paste("inner warning: ", w))),
             warning = function(w) print(paste("outer warning: ", w))
    ),
    # [1] "inner warning:  simpleWarning in log(-1): NaNs produced\n"
    "inner warning:",
    fixed = TRUE
  )

  # But: Without any warning handler the warning appears only once:
  expect_warning({
    tryCatch(tryCatch(log(-1)))
  },
    # Warning message:
    # In log(-1) : NaNs produced
    "NaNs produced",
    fixed = TRUE
  )

  # TODO How to check that exactly one warning has been thrown?
  # w <- warnings()
  # expect_equal(length(w), 1, info = "not exactly one warning thrown")

})



# tear down unit test ---------------------------------------------------------------------------------------------

options(error = saved.options)





# my personal thoughts --------------------------------------------------------------------------------------------

# Error: stop now
# [1] "option error called"



#   options(error = quote(print("option error called")))

#
#   tryCatch(stop("stop now"))
#   # Error in tryCatchList(expr, classes, parentenv, handlers) : stop now
#   # [1] "option error called"
#
#   tryCatch(stop("stop now"), finally = print("finally"))
#   # Error in tryCatchList(expr, classes, parentenv, handlers) : stop now
#   # [1] "option error called"
#   # [1] "finally"
#
#   # tryCatchLog does call the finally handler only if it was passed as argument:
#   # if (!missing(finally))
#   #   on.exit(finally)
#
# end -------------------------------------------------------------------------------------------------------------
#
# # works, but does not test the output of error handler
# expect_error(
#   stop("stop now"),
#   "stop now",
#   fixed = TRUE
# )
#
# # does not work:
# # Error: error$message does not match "option error called".
# # Actual value: "stop now"
# expect_error(
#   stop("stop now"),
#   "option error called",
#   fixed = TRUE
# )
#
# # does not work:
# # Error: expect_error(stop("stop now"), "stop now", fixed = TRUE) produced no output
# # [1] "option error called"
# expect_output(
#   expect_error(
#     stop("stop now"),
#     "stop now",
#     fixed = TRUE
#   ),
#   "option error called",
#   fixed = TRUE
# )
#
