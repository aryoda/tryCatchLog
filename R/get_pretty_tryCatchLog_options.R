#' Gets the current option values of all options supported by the `tryCatchLog` package
#'
#' This is a convenience function whose result can be used e. g. to log the current settings.
#'
#' If an option is not set the string "(not set)" is shown as value.
#'
#' The data type is also indicated if an option is set (since a wrong data type may cause problems).
#'
#' @return The current option settings as string (one per line as key/value pair), e. g.
#' \preformatted{
#' Option tryCatchLog.write.error.dump.file = FALSE (logical)
#' Option tryCatchLog.write.error.folder = . (character)
#' Option tryCatchLog.silent.warnings = FALSE (logical)
#' Option tryCatchLog.silent.messages = (not set)
#' }
#'
#' @examples
#' cat(get.pretty.tryCatchLog.options())  # "cat" does apply new line escape characters
#'
#' @export
get.pretty.tryCatchLog.options <- function() {

  option.names <- c(
    "tryCatchLog.write.error.dump.file",
    "tryCatchLog.write.error.folder",
    "tryCatchLog.silent.warnings",
    "tryCatchLog.silent.messages"
  )

  res <- paste(lapply(option.names, get.pretty.option.value), collapse = tryCatchLog::platform.NewLine())



  return(res)
}




#' gets the current value of an option as key/value string
#'
#' The data type is also indicated if an option is set (since a wrong data type may cause problems).
#' If an option is not set "(not set)" is shown as value.
#'
#' THIS IS AN INTERNAL PRIVATE FUNCTION OF THE PACKAGE.
#'
#' @param option.name Name of the option (as character)
#'
#' @return The option as key/value string in one line
#'
#' @seealso \code{\link{get.pretty.tryCatchLog.options}}
#'
#' @examples
#' \dontrun{
#' tryCatchLog:::get.pretty.option.value("warn")
#' # [1] "Option warn = 0 (double)" }
get.pretty.option.value <- function(option.name) {

    # Check preconditions
  stopifnot(is.character(option.name))
  stopifnot(length(option.name) == 1)



  option.value <- getOption(option.name)

  if (is.null(option.value)) {
    option.value <- "(not set)"
    option.type  <- ""
  } else {
    option.type  <- paste0("(", typeof(option.value), ")")
  }

  log.msg <- paste("Option", option.name, "=", option.value, option.type)



  return(log.msg)
}
