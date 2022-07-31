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
config[4, ]$log.as.severity <- Severity.Levels$INFO   # HACK The original value "DEBUG" must work one day !!!
config[4, ]$write.to.log <- TRUE

my.cond <- tryCatchLog:::condition("myClass", "custom condition")

test_that("tryCatchLog logs a custom condition (= inheritance works)", {
  expect_condition(tryCatchLog(signalCondition(my.cond), config = config))
  expect_equal(NROW(last.tryCatchLog.result()), 1)
  expect_equal(last.tryCatchLog.result()[1,]$severity, "INFO")
})

test_that("tryCatchLog logs a custom condition (= inheritance works) even if logged.conditions says NO", {
  expect_condition(tryCatchLog(signalCondition(my.cond), logged.conditions = NULL, config = config))
  expect_equal(NROW(last.tryCatchLog.result()), 1)
  expect_equal(last.tryCatchLog.result()[1,]$severity, "INFO")
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



test_that("NULL as config is ignored (uses standard arguments)", {
  expect_warning(tryCatchLog(log(-1), config = NULL))
  expect_equal(NROW(last.tryCatchLog.result()), 1)
})

test_that("NA as config is ignored (uses standard arguments)", {
  expect_warning(tryCatchLog(log(-1), config = NA))
  expect_equal(NROW(last.tryCatchLog.result()), 1)
})

test_that("error in case of invalid config", {

  skip("TODO implement underlying logic") # <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  expect_warning(tryCatchLog(log(-1), config = data.frame(col1="wrong format")), "invalid config", fixed = TRUE)
  expect_equal(NROW(last.tryCatchLog.result()), 1)
})



# Tests with existing option instead of passing as config argument...



config <- config.create()
config[4, ]$log.as.severity <- Severity.Levels$INFO   # HACK The original value "DEBUG" must work one day !!!
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
  expect_equal(last.tryCatchLog.result()[1,]$severity, "INFO")
})

options("tryCatchLog.global.config" = NULL)
