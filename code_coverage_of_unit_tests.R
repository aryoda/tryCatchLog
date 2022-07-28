library(covr)

res <- covr::package_coverage() # working dir must be in the project root folder of the package
res                             # code coverage as text
report(res)                     # code coverage as interactive report

covr::zero_coverage(res)        # show a list of lines without unit test coverage
