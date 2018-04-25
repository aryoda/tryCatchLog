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



#' Try an expression with condition logging and error recovery
#'
#' \code{tryLog} is a wrapper function around \code{\link{tryCatchLog}}
#' that traps any errors that occur during the evaluation of an expression without stopping the execution
#' of the script (similar to \code{\link{try}}). Errors, warnings and messages are logged.
#' In contrast to \code{\link{tryCatchLog}} it returns but does not stop in case of an error and therefore does
#' not have the \code{error} and \code{finally} parameters to pass in custom handler functions.
#'
#' @inheritParams tryCatchLog
#'
#' @details \code{tryLog} is implemented using \code{\link{tryCatchLog}}. If you need need more flexibility for
#'          catching and handling errors use the latter.
#'          Error messages are never printed to the \code{\link{stderr}} connection but logged only.
#'
#' @return The value of the expression (if \code{expr} is evaluated without an error.\cr
#'         In case of an error: An invisible object of the class \code{"try-error"} containing the error message
#'         and error condition as the \code{"condition"} attribute.
#'
#' @seealso \code{\link{tryCatchLog}},
#'          \code{\link{last.tryCatchLog.result}}
#' @examples
#' tryLog(log(-1))   # logs a warning
#' tryLog(log("a"))  # logs an error
#' @export
tryLog <- function(expr,
                   write.error.dump.file = getOption("tryCatchLog.write.error.dump.file", FALSE),
                   silent.warnings = getOption("tryCatchLog.silent.warnings", FALSE),
                   silent.messages = getOption("tryCatchLog.silent.messages", FALSE))
{
  tryCatchLog(expr = expr,
              write.error.dump.file = write.error.dump.file,
              error = function(e) {
                msg <- conditionMessage(e)
                invisible(structure(msg, class = "try-error", condition = e))
              },
              silent.warnings = silent.warnings,
              silent.messages = silent.messages)
}
