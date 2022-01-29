
#' Creates a \code{data.frame} with a configuration to control the behaviour of \code{tryCatchLogExt()}
#'
#' This configuration can be much more detailed eg. by specifying the \code{tryCatchLog} behaviour
#' per condition class (even for custom condition classes).
#'
#' The configuration can also be saved into and loaded from a CSV file for reusability
#' and to allow "external" configurations (without changing code).
#'
#' The arguments pass the column values of the configuration and therefore must be vectors of the same length.
#'
#' Each row of the configuration specifies the behaviour for one condition class
#'
#' The default values create a simple configuration that can be used as example
#' or to be extended (eg. by saving it as CSV file that can be edited then).
#'
#' @param cond.class                 The class name of the condition as character (eg. "error")
#' @param silent
#' @param do.not.log
#' @param log.as.severity
#' @param include.full.call.stack
#' @param include.compact.call.stack
#'
#' @return A \code{data.frame} with the configuration
#'
#' @export
#'
#' @examples
#' config <- tryCatchLog::config.create()
#' config.save(config, "my_tryCatchLog_config.csv")
#'
config.create <- function(  cond.class                  = c("error", "warning", "message", "condition", "interrupt")
                          , silent                      = c(FALSE, FALSE, FALSE, TRUE, FALSE)
                          , do.not.log                  = c(FALSE, FALSE, FALSE, TRUE, FALSE)
                          , log.as.severity             = c(tryCatchLog::Severity.Levels$ERROR,
                                                            tryCatchLog::Severity.Levels$WARN,
                                                            tryCatchLog::Severity.Levels$INFO,
                                                            tryCatchLog::Severity.Levels$DEBUG,
                                                            tryCatchLog::Severity.Levels$FATAL)
                          , include.full.call.stack     = c(TRUE, TRUE, FALSE, FALSE, TRUE)
                          , include.compact.call.stack  = c(TRUE, TRUE, TRUE, TRUE, TRUE))
{


  # TODO Check preconditions (length and data type, unique cond.class names...)

  config <- data.frame(cond.class                 = cond.class,
                       silent                     = silent, # = muffled = logged only (but not propagated to other registered handlers)!
                       # see rlang::cnd_muffle()
                       do.not.log                 = do.not.log,
                       log.as.severity            = log.as.severity, # these values may be logging-framework-specific (= not good since changing the logging framework requires config changes). Better approach, eg. mapping?
                       include.full.call.stack    = include.full.call.stack,
                       include.compact.call.stack = include.compact.call.stack
                       # , rethrow.as = NA              # reserved for future extension: Rethrow the condition as another condition class
                       , row.names = NULL
                       , check.rows = TRUE
                       , stringsAsFactors = FALSE
  )

  # add a class marker to recognize it easier in other functions as valid config
  # TODO The class name should be an internal "global" constant
  class(config) <- append("tryCatchLog.config", class(config))

  return (config)

}
