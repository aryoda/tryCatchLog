#' Enables one of the supported logging package used by tryCatchLog to write log output
#'
#' If this optional argument is omitted, either the package name
#' from the option \code{tryCatchLog.preferred.logging.package} is enabled
#' or all supported logging packages (see the vector of default values) are probed in this order
#' and the first existing (= installed) logging package is enabled.
#'
#' If the passed logging framework(s) is/are not installed the internal logging functions of
#' \code{tryCatchLog} will be enabled as fall-back.
#'
#' To enable a non-supported logging framework you can call \code{\link{set.logging.functions}} instead.
#'
#' To configure a standard logging package when \code{tryCatchLog} is loaded and \code{set.logging.package}
#' is called without an argument
#' you can use the option \code{tryCatchLog.preferred.logging.package}.
#' You could also set a vector of packages to "probe" (the first installed package of the list is taken,
#' in none is installed \code{tryCatchLog}-internal logging is used.
#'
#' @param logging.package.name The name of the logging package (character) that shall be enabled.
#'
#' @return The name of the enabled logging framework
#' @export
#'
#' @examples
#' tryCatchLog:::set.logging.package("futile.logger")
#' tryCatchLog:::set.logging.package("lgr")
#' tryCatchLog:::set.logging.package("tryCatchLog")
#'
#' # takes the first installed logging package from the list of supported packages
#' tryCatchLog:::set.logging.package()
#'
#' # only considered when tryCatchLog is loaded or set.logging.package() is called!
#' # takes the logging package fromt the configured option (if installed, else tryCatchLog)
#' options(tryCatchLog.preferred.logging.package = "futile.logger")
#' tryCatchLog:::set.logging.package()
set.logging.package <- function(logging.package.name = getOption("tryCatchLog.preferred.logging.package", c("futile.logger", "lgr", "tryCatchLog"))) {

  # Decide which logging functions to use

  match.arg(logging.package.name, several.ok = TRUE)  # verify that only names from the default values vector are passed



  # ------ Search for the first supported and installed logging framework -------------------------

  .tryCatchLog.env$active.logging.package = "tryCatchLog"   # default: use internal logging functions

  for (candidate.package in logging.package.name) {

      if (is.package.available(candidate.package)) {

        # packageStartupMessage("Using futile.logger for logging...")  # be silent in .onLoad (best practice)
        .tryCatchLog.env$active.logging.package <- candidate.package
        break

      }

  }  # for loop



  # ------ activate selected logging framework ------------------------------------------------
  # Development note: New logging frameworks need to be added only here and to the default values vector of the first argument)

  if (.tryCatchLog.env$active.logging.package == "futile.logger") {
    # packageStartupMessage("Using futile.logger for logging...")  # be silent in .onLoad (best practice)
    set.logging.functions(futile.logger::flog.error, futile.logger::flog.warn, futile.logger::flog.info, .tryCatchLog.env$active.logging.package)

  } else if (.tryCatchLog.env$active.logging.package == "lgr") {
    # if( ! exists("lg", envir = parent.env(environment()))){
    #   assign(
    #     "lg",
    #     lgr::get_logger(name = "tryCatchLog"),
    #     envir = parent.env(environment())
    #   )
    # }
    # Design decision:
    # Use the default root logger (not a tryCatchLog-specific instance since the logged conditions concern the caller!)
    lgr <- lgr::lgr
    set.logging.functions(lgr$error, lgr$warn, lgr$info, .tryCatchLog.env$active.logging.package)

  } else {
    # packageStartupMessage("futile.logger not found. Using tryCatchLog-internal functions for logging...")  # be silent in .onLoad (best practice)
    set.logging.functions()    # Default: Activate the package-internal minimal logging functions
  } # if

  return (.tryCatchLog.env$active.logging.package)

}
