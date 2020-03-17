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



#' Creates a log entry as a single \code{data.frame} row containing all relevant logging information in columns
#'
#' The serverity level should correspond to the condition class.
#'
#' @param timestamp       logging timestamp as \code{\link{POSIXct}} (normally by calling \code{\link{Sys.time}})
#' @param severity        severity level of the log entry ((ERROR, WARN, INFO etc.)
#' @param msg.text        Logging message (e. g. error message)
#' @param pid             a process id or other text identifier that will be added to msg.text
#' @param call.stack      a call stack created by \code{\link{sys.calls}}
#' @param dump.file.name  name of the created dump file (leave empty if the \code{\link{tryCatchLog}}
#'                        argument \code{write.error.dump.file} is \code{FALSE}
#' @param omit.call.stack.items  the number of stack trace items to ignore (= last x calls) in
#'                               the passed \code{call.stack} since they are caused by using \code{tryCatchLog}
#'
#' @return An object of class \code{tryCatchLog.log.entry} and \code{\link{data.frame}} with one and the following columns:
#'         \enumerate{
#'         \item{timestamp   - creation date and time of the logging entry}
#'         \item{severity    - the serverity level of the log entry (ERROR, WARN, INFO etc.)}
#'         \item{msg.text    - the message text of the log entry}
#'         \item{compact.stack.trace - the short stack trace containing only entries with source code
#'                                     references down to line of code that has thrown the condition}
#'         \item{full.stack.trace    - the full stack trace with all calls down to the line of code that
#'                                     has thrown the condition (including calls to R internal functions
#'                                     and other functions even when the source code in not available).}
#'         \item{dump.file.name      - name of the created dump file (if any)}
#'         }
#'
#' @seealso      \code{\link{last.tryCatchLog.result}}
#'               \code{\link{build.log.output}}
#'
#' @note         THIS IS A PACKAGE INTERNAL FUNCTION AND THEREFORE NOT EXPORTED.
build.log.entry <- function(timestamp, severity, msg.text, pid, call.stack, dump.file.name, omit.call.stack.items = 0) {

  stopifnot(inherits(timestamp, "POSIXct"))



  log.entry <- data.frame(timestamp           = timestamp,
                          severity            = severity,
                          msg.text            = msg.text,
                          pid                 = ifelse(is.null(pid), NA, pid),
                          compact.stack.trace = get.pretty.call.stack(call.stack, omit.call.stack.items, compact = TRUE),
                          full.stack.trace    = get.pretty.call.stack(call.stack, omit.call.stack.items),
                          dump.file.name      = dump.file.name,
                          stringsAsFactors    = FALSE
                         )

  class(log.entry) <- c(class(log.entry), "tryCatchLog.log.entry")

  return(log.entry)
}
