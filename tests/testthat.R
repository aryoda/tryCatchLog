library(testthat)
library(futile.logger)
library(tryCatchLog)



# Set to something like [1] "en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/de_DE.UTF-8"
# to ensure english error messages
# DISABLED - DOES NOT WORK (AT LEAST NOT ON OSX)!
# Sys.setlocale("LC_ALL", "en_US.UTF-8")



test_check("tryCatchLog")
