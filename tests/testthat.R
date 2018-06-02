library(testthat)
library(tryCatchLog)



# Set to something like [1] "en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/de_DE.UTF-8"
# to ensure english error messages
# DISABLED - DOES NOT WORK (AT LEAST NOT ON OSX)!
# Sys.setlocale("LC_ALL", "en_US.UTF-8")
# Sys.getlocale()

# https://stackoverflow.com/questions/47977951/how-to-ensure-english-error-messages-in-testthat-unit-tests
Sys.setenv("LANGUAGE"="EN")  # work-around to always create english R (error) messages



test_check("tryCatchLog")
