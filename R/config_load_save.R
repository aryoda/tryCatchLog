# Design decision:
# Prefer a config data file of a config R script file for better "early syntax parsing"


config.save <- function(config, file = "tryCatchLog_config.csv") {

  # TODO check preconditions, eg.:
  stopifnot(inherits(config, "tryCatchLog.config"))

  write.csv2(config, file)

}



config.load <- function(config, file = "tryCatchLog_config.csv") {

  config <- read.csv2(file)

  # TODO validate config (maybe reuse precond checks from config.create)

  # add a class marker to recognize it easier in other functions as valid config
  # TODO The class name should be an internal "global" constant
  class(config) <- append("tryCatchLog.config", class(config))

  return (config)

}



