#' Prints a time-stamped log message to the console incl. the severity level
#'
#' This is a package-internal function.
#'
#' @param severity.level  String containing the severity level
#'                        (\code{ERROR}, \code{WARN} or \code{INFO}) of the message
#' @param msg             The message to be printed (as character).
#'
#' @return                The log message as it was printed to the console.
#'                        \code{NA} is printed as empty string.
#'
#' @examples
#' tryCatchLog:::log2console("WARN", "this is my last warning")
#'
log2console <- function(severity.level, msg) {

  if (is.na(msg))
    msg <- ""



  stopifnot(!is.null(severity.level))
  stopifnot(severity.level %in% c("ERROR", "WARN", "INFO"))
  stopifnot(is.character(msg))

  # Design decision:
  # This simple logging function uses the local time
  # (not UTC which would allow to combine different log output with
  #  different time zones more easily).
  log.time <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")

  res <- sprintf("%s [%s] %s\n", severity.level, log.time, msg, "\n")

  cat(res)


  invisible(res)
}
