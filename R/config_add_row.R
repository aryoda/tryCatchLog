
#' Add a new entry (row) to an existing configuration
#'
#' You could also add multiple rows in one call by passing vectors of the same length for each argument
#' (except for the \code{config} argument of course).
#'
#' The config passed in as argument is NOT modified, you have to reassign the return value for this (see examples).
#'
#' For a detailed description of the argument semantics see the related function \code{\link{config.create}}.
#'
#' @param config                     an existing configuration
#' @param cond.class                 the class name of the condition as character (eg. "error")
#' @param silent                     \code{\link{logical}}: \code{TRUE} = do not propagate the condition to other registered handlers (= "muffle" in R speak).
#' @param write.to.log               \code{\link{logical}}: \code{TRUE} = Call the logging function for the caught condition
#' @param log.as.severity            Severity level for the \code{cond.class} (use the constants from \code{\link{Severity.Levels}} or the equivalent character strings)
#' @param include.full.call.stack    \code{\link{logical}}: Shall the full call stack be included in the log output?
#' @param include.compact.call.stack \code{\link{logical}}: Shall the compact call stack (including only calls with source code references)
#'                                   be included in the log output?
#'
#' @return The new config that includes the new row(s)
#' @export
#'
#' @examples
#' config <- config.create()
#' config <- config.add.row(config, "myInfo")
#' config <- config.add.row(config, "myError", FALSE, TRUE, Severity.Levels$FATAL, TRUE, TRUE)
#' options("tryCatchLog.global.config" = config)
config.add.row <- function(   config
                            , cond.class
                            , silent                      = FALSE
                            , write.to.log                = TRUE
                            , log.as.severity             = tryCatchLog::Severity.Levels$INFO
                            , include.full.call.stack     = FALSE
                            , include.compact.call.stack  = TRUE)
{

  config.validate(config, throw.error.with.findings = TRUE)

  new.config.row <- config.create(cond.class, silent, write.to.log, log.as.severity, include.full.call.stack, include.compact.call.stack)

  new.config <- rbind(config, new.config.row, stringsAsFactors = FALSE)

  config.validate(config, throw.error.with.findings = TRUE)

  return(new.config)
}
