# ***************************************************************************
# Copyright (C) 2016 Juergen Altfeld (R@altfeld-im.de)
# ---------------------------------------------------------------------------
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
# ***************************************************************************



#' Sets the logging functions that shall be used by \code{tryCatchLog} for the different severity levels
#'
#' The logging functions must have at least one parameter: The logging message (as character)
#' which must be the first argument.
#'
#' The default logging functions are internal functions without any dependencies to other
#' logging packages. They use the same logging output format as \pkg{futile.logger} version 1.4.3.
#'
#' If you want to disable any logging output you should use a decent logging framework
#' which allows to set the logging threshold (e. g. futile.logger's \code{\link[futile.logger]{flog.threshold}}).
#'
#' The package-internal default logging functions are only a minimal implementation
#' and are not meant to replace a decent logging framework.
#'
#' To activate another logging package that is supported by \code{tryCatchLog} use \code{\link{set.logging.package}}.
#'
#' @param error.log.func      The logging function for errors
#' @param warn.log.func       The logging function for warning
#' @param info.log.func       The error function for messages
#' @param logger.package.name The logging package name of the functions (just internally used to print the name).
#'                            For self-made logging functions (not part of a package) should use "custom functions"
#'                            but can use any other name (it has no functionality).
#'
#' @return     Nothing
#' @export
#'
#' @seealso \code{\link{tryCatchLog}}
#'          \code{\link{set.logging.package}}
#'
#' @examples
#' # To disable any logging you could use "empty" functions
#' set.logging.functions( error.log.func = function(msg) invisible(),
#'                        warn.log.func  = function(msg) invisible(),
#'                        info.log.func  = function(msg) invisible())
#'
set.logging.functions <- function(error.log.func   = function(msg) tryCatchLog::log2console("ERROR", msg)
                                  , warn.log.func  = function(msg) tryCatchLog::log2console("WARN",  msg)
                                  , info.log.func  = function(msg) tryCatchLog::log2console("INFO",  msg)
                                  , logger.package.name = "tryCatchLog"
) {

  stopifnot(is.function(error.log.func))
  stopifnot(is.function(warn.log.func))
  stopifnot(is.function(info.log.func))



  # remember the active logging functions in the package-internal environment
  .tryCatchLog.env$error.log.func <- error.log.func
  .tryCatchLog.env$warn.log.func  <- warn.log.func
  .tryCatchLog.env$info.log.func  <- info.log.func



  .tryCatchLog.env$active.logging.package <- logger.package.name

  invisible()
}
