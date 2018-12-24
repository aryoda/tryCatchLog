library(tryCatchLog)
library(testthat)



context("test_is_package_available.R")



source("init_unit_test.R")



test_that("is.package.available() works", {
  
  expect_true( tryCatchLog:::is.package.available("tryCatchLog"))
  expect_false(tryCatchLog:::is.package.available("e14d8635-4643-477f-9a79-1d9b05af1665"))
  
})
  
