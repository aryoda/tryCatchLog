# Some testing hints


## To skip a test on CRAN:

```R
test_that("Test does not run on CRAN", {
  testthat::skip_on_cran()
  ...
```


## To skip a test based on a precondition

```R
test_that("does only work fridays", {
  if (is.friday(today())) skip("Not today.")
```



## How to separate testthat unit tests for manual-only execution

If you put your manual test files into another directory within the tests folder,
you can still test them manually with test_dir(),
but they won't be running with test() or R CMD check.

Source: https://stackoverflow.com/questions/25595487/testthat-pattern-for-long-running-tests

