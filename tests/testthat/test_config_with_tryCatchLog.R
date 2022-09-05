library(testthat)
library(tryCatchLog)



# Basic tests -----------------------------------------------------------------------------------------------------

context("test_config_with_tryCatchLog.R")



source("init_unit_test.R")



# suppress logging of errors and warnings to avoid overly output
source("disable_logging_output.R")



config <- config.create()
# > config
#   cond.class silent write.to.log log.as.severity include.full.call.stack include.compact.call.stack
# 1      error  FALSE         TRUE           ERROR                    TRUE                       TRUE
# 2    warning  FALSE         TRUE            WARN                    TRUE                       TRUE
# 3    message  FALSE         TRUE            INFO                   FALSE                       TRUE
# 4  condition   TRUE        FALSE           DEBUG                   FALSE                       TRUE
# 5  interrupt  FALSE         TRUE           FATAL                    TRUE                       TRUE



# https://stackoverflow.com/questions/22003306/is-there-something-in-testthat-like-expect-no-warnings/33638939#33638939



test_that("tryCatchLog is silent for correct expressions", {
  expect_silent(tryCatchLog(1 + 1, config = config))
})

test_that("tryCatchLog did throw a warning", {
  expect_warning(tryCatchLog(log(-1), config = config))
  expect_equal(NROW(last.tryCatchLog.result()), 1)
})

test_that("tryCatchLog did throw an error", {
  expect_error(tryCatchLog(log("abc"), config = config))
  expect_equal(NROW(last.tryCatchLog.result()), 1)
})



config[2, ]$silent = TRUE

test_that("tryCatchLog silences a warning", {
  expect_silent(tryCatchLog(log(-1), config = config))
  expect_equal(NROW(last.tryCatchLog.result()), 1)
})

test_that("tryCatchLog did throw an error", {
  expect_error(tryCatchLog(log("abc"), config = config))
  expect_equal(NROW(last.tryCatchLog.result()), 1)
})



config <- config.create()
config[1,]$write.to.log <- FALSE

test_that("tryCatchLog did throw a warning and logged it", {
  expect_warning(tryCatchLog(log(-1), config = config))
  expect_equal(NROW(last.tryCatchLog.result()), 1)
})


test_that("tryCatchLog did throw an error but did not log it", {
  expect_error(tryCatchLog(log("abc"), config = config))
  expect_equal(NROW(last.tryCatchLog.result()), 0)
})



config <- config.create()
config[2,]$log.as.severity <- Severity.Levels$INFO

test_that("tryCatchLog did throw a warning and logged it as INFO", {
  expect_warning(tryCatchLog(log(-1), config = config))
  expect_equal(NROW(last.tryCatchLog.result()), 1)
  expect_equal(last.tryCatchLog.result()[1,]$severity, "INFO")
})


test_that("tryCatchLog did throw an error and logged it as ERROR", {
  expect_error(tryCatchLog(log("abc"), config = config))
  expect_equal(NROW(last.tryCatchLog.result()), 1)
  expect_equal(last.tryCatchLog.result()[1,]$severity, "ERROR")
})



config <- config.create()
config[2, ]$include.compact.call.stack = FALSE  # so that output begins with the expected text!
# set.logging.package("tryCatchLog") # enable output again

test_that("contains only included call stacks", {

  # Note: RegExps are not very strong to recognize "not contained".
  #       This is achieved by using
  #           ^((?!searchword)(.|\n|\r))*$
  #       where "searchword" is the text expression that shall not be included.
  #       It works using a look-ahead of the unwanted searchword and matches only
  #       if the searchword is not found.
  #           (?!searchword)  =  look ahead to be sure the searchword is not found...
  #       The new line (\n) and carriage return (\r) must also be consumed as a character
  #       to match the complete end of string with $


  # Simple "does not contain" example
  # expect_output(cat("hello world"), "^((?!bye).)*$", perl = TRUE)

  expect_warning(
    tryLog(log(-1), config = config)
    , "^((?!Compact call stack)(.|\\n|\\r))*$", perl = TRUE)

  config[2, ]$include.compact.call.stack = TRUE  # so that output begins with the expected text!
  config[2, ]$include.full.call.stack = FALSE  # so that output begins with the expected text!

  expect_warning(
    tryLog(log(-1), config = config)
    , "^((?!Full call stack)(.|\\n|\\r))*$", perl = TRUE)

})



config <- config.create()
config[4, ]$write.to.log <- TRUE

my.cond <- tryCatchLog:::condition("myClass", "custom condition")

test_that("tryCatchLog logs a custom condition (= inheritance works)", {
  expect_condition(tryCatchLog(signalCondition(my.cond), config = config))
  expect_equal(NROW(last.tryCatchLog.result()), 1)
  expect_equal(last.tryCatchLog.result()[1,]$severity, "DEBUG")
})

test_that("tryCatchLog logs a custom condition (= inheritance works) even if logged.conditions says NO", {
  expect_condition(tryCatchLog(signalCondition(my.cond), logged.conditions = NULL, config = config))
  expect_equal(NROW(last.tryCatchLog.result()), 1)
  expect_equal(last.tryCatchLog.result()[1,]$severity, "DEBUG")
})


config[4, ]$write.to.log <- FALSE
test_that("tryCatchLog does not log a custom condition (= inheritance works) even if logged.conditions says ALL", {
  expect_condition(tryCatchLog(signalCondition(my.cond), logged.conditions = NA, config = config))
  expect_equal(NROW(last.tryCatchLog.result()), 0)
})

test_that("tryCatchLog does not log a custom condition (= inheritance works) even if logged.conditions contains the class", {
  expect_condition(tryCatchLog(signalCondition(my.cond), logged.conditions = "myClass", config = config))
  expect_equal(NROW(last.tryCatchLog.result()), 0)
})


config <- config[FALSE, ]   # get a config with zero rows

test_that("missing condition class in config uses arguments instead", {
    expect_warning(tryCatchLog(log(-1), config = config))
    expect_equal(NROW(last.tryCatchLog.result()), 1)
})

test_that("missing condition class in config uses arguments instead", {
  expect_silent(tryCatchLog(log(-1), silent.warnings = TRUE, config = config))
  expect_equal(NROW(last.tryCatchLog.result()), 1)
})



config <- config.create()
config$cond.class    <- "message"
config$silent        <- TRUE
config$write.to.log  <- TRUE
config[1, ]$silent   <- FALSE

test_that("duplicated condition class entry in config uses the first entry as fall-back", {
  # config.validate() does recognize duplicated condition class names but a "clever user" may
  # manipulate this without validation
  expect_message(tryCatchLog(message("beep"), config = config), "beep", fixed = TRUE)
  expect_equal(NROW(last.tryCatchLog.result()), 1)
  expect_match(last.tryCatchLog.result()$msg.text, "beep", fixed = TRUE)
})


test_that("NULL as config is ignored (uses standard arguments)", {
  expect_warning(tryCatchLog(log(-1), config = NULL))
  expect_equal(NROW(last.tryCatchLog.result()), 1)
})

test_that("NA as config is ignored (uses standard arguments)", {
  expect_warning(tryCatchLog(log(-1), config = NA))
  expect_equal(NROW(last.tryCatchLog.result()), 1)
})

test_that("invalid config throws a warning (but only if a condition was caught)", {

  expect_silent(tryCatchLog(1 + 1, config = data.frame(col1="wrong format")))

  expect_warning(tryCatchLog(log(-1), config = data.frame(col1="wrong format")), "config is invalid", fixed = TRUE)
  expect_equal(NROW(last.tryCatchLog.result()), 1)

  expect_warning(tryCatchLog(log(-1), silent.warnings = TRUE, config = data.frame(col1="wrong format")), "config is invalid", fixed = TRUE)
  expect_equal(NROW(last.tryCatchLog.result()), 1)

})


config <- config.create()
config[1, ]$silent = TRUE # silent error ;-)

test_that("a condition configured as silent but that cannot be silenced produces a log output", {
  expect_error(
    expect_output(tryCatchLog(stop("silent error"), config = config),
                  "Caught condition configured as silent but does not inherit from c('warning', 'message')", fixed = TRUE)
  )
  expect_equal(NROW(last.tryCatchLog.result()), 1)
})



# ===== Tests with existing option instead of passing as config argument... ===================

config <- config.create()
config[4, ]$write.to.log <- TRUE

options("tryCatchLog.global.config" = NULL)

test_that("tryCatchLog ignores custom condition without a config", {
    # without config: Not logged
  expect_silent(tryCatchLog(signalCondition(my.cond)))
  expect_equal(NROW(last.tryCatchLog.result()), 0)
})

test_that("tryCatchLog applies a config from the options", {
  # with config from option: logged
  options("tryCatchLog.global.config" = config)
  expect_condition(tryCatchLog(signalCondition(my.cond)))
  expect_equal(NROW(last.tryCatchLog.result()), 1)
  expect_equal(last.tryCatchLog.result()[1,]$severity, "DEBUG")
})

options("tryCatchLog.global.config" = NULL)



# Test for TRACE logging level (for 100 % code coverage ;-) ---------------

set.logging.functions()

config <- config.create("message", TRUE, TRUE, Severity.Levels$TRACE, FALSE, FALSE)

test_that("Severity Level TRACE works", {
  expect_output(tryCatchLog(message("trace me please"), config = config)
  , regexp = "^TRACE.*trace me please"
  )

})


