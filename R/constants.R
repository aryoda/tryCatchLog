#' Log (severity) levels
#'
#' These logging levels are supported to characterize the severity of an event in the log output.
#'
#' The levels comply with the standard Apache log4j log level names (except \code{ALL} to log all events
#' which is the same as \code{FATAL}).
#'
#' Additional custom levels may be added in the future (eg. \code{SUCCESS}).
#'
#' The levels have an implicit order (by severity) from the most to the least severe level:
#'
#' \enumerate{
#'   \item \code{FATAL} A severe (mostly non-recoverable) error that will prevent the application from continuing
#'   \item \code{ERROR} An error in the application (normally recoverable to continue the application execution)
#'   \item \code{WARN}  An event that might possibly lead to an error
#'   \item \code{INFO}  Indicates an event for informational purposes
#'   \item \code{DEBUG} A debugging event
#'   \item \code{TRACE} A fine-grained debug message to capture the execution flow through the application
#'   \item \code{}
#' }
#'
#' @note In contrast to log4j log levels the log lovels of this package do just use names
#'       but no internal integer log value to order the log levels by severity
#'       since filtering the log output by severity is the responsibility of the used logging framework
#'       (not the \code{tryCatchLog} package).
#'
#' @references \url{https://logging.apache.org/log4j/2.0/log4j-api/apidocs/org/apache/logging/log4j/Level.html},
#'             \url{https://logging.apache.org/log4j/2.x/manual/customloglevels.html}
#'
#'
#' @seealso
#' \code{set.logging.functions()} to assign a logging function to the log levels
#' \code{config.create()} to customize the \code{tryCatchLog} behaviour for each thrown \code{condition}
#'
#' @export
Severity.Levels <- list(
  # TODO Decide on best name: Severity.Levels, Log.Levels, Log.Severity.Levels, singular or plural...?
  FATAL = "FATAL",
  ERROR = "ERROR",
  WARN  = "WARN",
  # SUCCESS = "SUCCESS", eg. supported by logger
  INFO  = "INFO",
  DEBUG = "DEBUG",
  TRACE = "TRACE"
)
