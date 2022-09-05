library(tryCatchLog)


# test helper script to disable the package-internal logging output
# (as futile.logger's "flog.threshold("FATAL")" does)

# Note: Always use the FQN for this function in unit tests since
#       otherwise strange side effects may occur (logging is still
#       enabled or disabled - perhaps due to stacked testthat environments).
tryCatchLog::set.logging.functions(
    error.log.func = function(msg) invisible()
  , warn.log.func  = function(msg) invisible()
  , info.log.func  = function(msg) invisible()
  , debug.log.func = function(msg) invisible()
  , trace.log.func = function(msg) invisible()
  , fatal.log.func = function(msg) invisible()
)

