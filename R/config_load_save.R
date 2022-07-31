# Design decision:
# Prefer a config data file of a config R script file for better "early syntax parsing"


#' Save a configuration to control the behavior of \code{tryCatchLogExt()} into a config file
#'
#' @param config      A configuration (created via \code{\link{config.create}}
#' @param file.name   A file name for the configuration file
#'
#' @return       \code{file.name} (invisible)
#'
#' @export
#'
#' @seealso \code{\link{config.create}}, \code{\link{config.load}}
#'
#' @examples
#' config.save(config.create())
config.save <- function(config, file.name = "tryCatchLog_config.csv") {

  stopifnot(config.validate(config)$status == TRUE)



  utils::write.csv2(config, file.name, row.names = FALSE)

  invisible(file.name)
}



#' Load a configuration to control the behavior of \code{tryCatchLogExt()} from a config file
#'
#' @param file.name The name of a file that contains a valid configuration
#'
#' @return A configuration
#'
#' @export
#'
#' @seealso \code{\link{config.create}}, \code{\link{config.save}}
#'
#' @examples
#' config.save(config.create())
#' config.load()
config.load <- function(file.name = "tryCatchLog_config.csv") {

  config <- utils::read.csv2(file.name, stringsAsFactors = FALSE)

  # TODO validate config (maybe reuse precond checks from config.create)
  #      I would also add a "do.fast.validation.only" argument for a quick partial check from within
  #      tryCatchLog() where runtime is critical...

  # add a class marker to recognize it easier in other functions as valid config
  # TODO The class name should be an internal "global" constant
  class(config) <- append(.CONFIG.CLASS.NAME, class(config))

  stopifnot(config.validate(config)$status == TRUE)

  return (config)

}



