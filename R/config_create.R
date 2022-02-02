# Private constants ---------------------------------------------------------------------

# Marker class name constant to recognize instances of config.create() as valid config
.CONFIG.CLASS.NAME <- "tryCatchLog.config"



# Public constants ----------------------------------------------------------------------

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
#' Each row of the configuration specifies the behavior for one condition class
#'
#' The default values create a simple configuration that can be used as example
#' or to be extended (eg. by saving it as CSV file that can be edited then).
#'
#' @param cond.class                 The class name of the condition as character (eg. "error")
#' @param silent                     \code{\link{logical}}: \code{TRUE} = do not propagated to other registered handlers (= "muffle" in R speak). May stil be logged
#' @param do.not.log                 \code{\link{logical}}: \code{TRUE} = the caught condition is not logged (not passed to the logger)
#' @param log.as.severity            Severity level for the \code{cond.class} (use the constants from \code{\link{Severity.Levels}} or the equivalent character strings)
#' @param include.full.call.stack    Flag of type \code{\link{logical}}:
#'                                   Shall the full call stack be included in the log output? Since the full
#'                                   call stack may be very long and the compact call stack has enough details
#'                                   normally the full call stack can be omitted by passing \code{FALSE}.
#'                                   The default value can be changed globally by setting the option \code{tryCatchLog.include.full.call.stack}.
#'                                   The full call stack can always be found via \code{\link{last.tryCatchLog.result}}.
#' @param include.compact.call.stack Flag of type \code{\link{logical}}:
#'                                   Shall the compact call stack (including only calls with source code references)
#'                                   be included in the log output? Note: If you omit both the full and compact
#'                                   call stacks the message text will be output without call stacks.
#'                                   The default value can be changed globally by setting the option \code{tryCatchLog.include.compact.call.stack}.
#'                                    The compact call stack can always be found via \code{\link{last.tryCatchLog.result}}.
#'
#' @return A \code{data.frame} with the created configuration (marked with the class \code{tryCatchLog.config})
#'
#' @export
#'
#' @examples
#' config <- tryCatchLog::config.create()
#' config.save(config, "my_tryCatchLog_config.csv")
#' # Severity levels are defined as strings in a package variable, eg:
#' print(tryCatchLog::Severity.Levels$INFO)
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
  class(config) <- append(.CONFIG.CLASS.NAME, class(config))

  return (config)

}
