library(tryCatchLog)


# test helper script to disable the package-internal logging output
# (as futile.logger's "flog.threshold("FATAL")" does)

tryCatchLog:::set.logging.functions(
    error.log.func = function(msg) invisible()
  , warn.log.func  = function(msg) invisible()
  , info.log.func  =  function(msg) invisible()
)
