library(tryCatchLog)
library(testthat)



context("test_log2console.R")



source("init_unit_test.R")



# Woraround:
# R < 3.3.0 does not yet know the functions "startsWith" and "endsWith",
# so we need a workaround here to make the tests run on "older" R versions
endsWith   <- function(x, suffix)
  return(grepl(paste0(suffix, "$"), x))

startsWith <- function(x, prefix)
  return(grepl(paste0("^", prefix), x))



test_that("log2console() works", {

  expect_output(
      log <- tryCatchLog:::log2console("ERROR", "my personal error")
    , "ERROR .[[:digit:]: -]{15,22}. my personal error"
  )
  # to debug the matching result of the regular expression use this code:
  # regexpr("ERROR .[[:digit:]: -]{15,25}. m", "ERROR [2018-06-01 13:14:51] my personal error\n")
  
  expect_silent(log.datetime <- as.POSIXct(substr(log, 8, 33),
                format = "%Y-%m-%d %H:%M:%S"))  # logged datetime can be parsed

  expect_lt(as.numeric(Sys.time() - log.datetime),
                   5,
                   label = "logged time differs to much from the real system time")

  
  
  expect_output(
    log <- tryCatchLog:::log2console("INFO", NA_character_)
  )
  expect_true(endsWith(log, "] \n"), label = "NA is printed as empty string")

  expect_output(
    log <- tryCatchLog:::log2console("INFO", NA)
  )
  expect_true(endsWith(log, "] \n"), label = "NA is printed as empty string")
  
  expect_output(
    log <- tryCatchLog:::log2console("INFO", "")
  )
  expect_true(endsWith(log, "] \n"), label = "empty string is supported")

  
  expect_output(
    expect_true(startsWith(tryCatchLog:::log2console("INFO", ""),  "INFO"),  info = "severity level INFO works")
  )
  
  expect_output(
    expect_true(startsWith(tryCatchLog:::log2console("WARN", ""),  "WARN"),  info = "severity level WARN works")
  )
  
  expect_output(
    expect_true(startsWith(tryCatchLog:::log2console("ERROR", ""), "ERROR"), info = "severity level ERROR works")
  )
  
})



test_that("wrong arguments are recognized by log2console()", {
 
  expect_error(tryCatchLog:::log2console(10, "msg"), "severity.level")
  expect_error(tryCatchLog:::log2console(NA, "msg"), "severity.level")
  expect_error(tryCatchLog:::log2console(NULL, "msg"), "is.null")
  
  expect_error(tryCatchLog:::log2console("INFO", 10), "is.character")

})

