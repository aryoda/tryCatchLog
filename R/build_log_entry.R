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



#' Creates a log entry row containing all relevant logging information in columns
#'
#' The serverity level should correspond to the condition class.
#'
#' @param severity        severity level of the log entry ((ERROR, WARNING, MESSAGE etc.)
#' @param msg.text        the message text of the thrown condition
#' @param call.stack      a call stack created by \code{\link{sys.calls}}
#' @param omit.last.items the number of stack trace items to ignore (= last x calls) in
#'                        the passed \code{call.stack} since they are caused by using \code{tryCatchLog}
#'
#' @return A \code{\link{data.frame}} with one and the following columns:
#'         \enumerate{
#'         \item{severity    - the serverity level of the log entry (ERROR, WARNING, MESSAGE)}
#'         \item{log.message - the message text of the log entry}
#'         \item{compact.stack.trace - the short stack trace containing only entries with source code
#'                                     references down to line of code that has thrown the condition}
#'         \item{full.stack.trace    - the full stack trace with all calls down to the line of code that
#'                                     has thrown the condition (including calls to R internal functions
#'                                     and other functions even when the source code in not available).}
#'         }
#'
#' @note         THIS IS A PACKAGE INTERNAL FUNCTION AND THEREFORE NOT EXPORTED.
build.log.entry <- function(severity, log.message, call.stack, omit.last.items = 0) {

  log.entry <- data.frame(severity            = severity,
                          msg.text            = log.message,
                          compact.stack.trace = get.pretty.call.stack(call.stack, omit.last.items, compact = TRUE),
                          full.stack.trace    = get.pretty.call.stack(call.stack, omit.last.items),
                          stringsAsFactors    = FALSE
                         )

  return(log.entry)
}
