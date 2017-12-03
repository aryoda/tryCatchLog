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



#' Gets the logging result of the last call to \code{tryCatchLog} or \code{tryLog}
#'
#' The last logging result after calling \code{tryCatchLog} or \code{tryLog} can be retrieved by
#' calling this function.
#'
#' The typical use case is to get and store the log output not only in a log file but
#' also in another place that is not supported by \code{futile.logger}, e. g. in
#' a data base table of your application or displaying it in a GUI (user interface).
#'
#' Another use case is to review the last log output on the console during debugging.
#'
#' @return the logging result of the last call to \code{\link{tryCatchLog}} or \code{\link{tryLog}}
#'         as \code{\link{data.frame}} comprised of one row per logged condition with these columns:
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
#'         If no condition is logged at all an empty \code{data.table} is returned.
#'
#' @seealso \code{\link{tryCatchLog}},
#'          \code{\link{tryLog}}
#'
#' @examples
#' last.tryCatchLog.result()
#'
#' @export
last.tryCatchLog.result <- function() {

  return(.tryCatchLog.env$last.log)

}




#' Resets the stored logging output of the last call to \code{tryCatchLog} or \code{tryLog} to an empty list
#'
#' You can get the last logging output by calling \code{\link{last.tryCatchLog.result}}.
#'
#' @return  invisible: TRUE
#'
#' @seealso \code{\link{last.tryCatchLog.result}},
#'          \code{\link{append.to.last.tryCatchLog.result}},
#'
#' @note         THIS IS A PACKAGE INTERNAL FUNCTION AND THEREFORE NOT EXPORTED.
reset.last.tryCatchLog.result <- function() {

  .tryCatchLog.env$last.log = data.frame()

  invisible(TRUE)

}



#' Appends a new log entry to the stored logging output of the last call to \code{tryCatchLog} or \code{tryLog}
#'
#' You can get the last logging output by calling \code{\link{last.tryCatchLog.result}}.
#'
#' THIS FUNCTION IS USED ONLY PACKAGE INTERNALLY!
#'
#' @param new.log.entry the new log entry (a \code{data.frame} created with \code{link{build.log.entry}})
#'
#' @return the complete logging result of the last call to \code{tryCatchLog} or \code{tryLog} as \code{data.frame}
#'
#' @seealso \code{\link{last.tryCatchLog.result}},
#'          \code{\link{reset.last.tryCatchLog.result}},
#'
#' @note         THIS IS A PACKAGE INTERNAL FUNCTION AND THEREFORE NOT EXPORTED.
append.to.last.tryCatchLog.result <- function(new.log.entry) {

  if (!("data.frame" %in% class(new.log.entry)))
    stop(
      paste(
        "The actual value of the parameter 'new.log.entry' must be an object of the class 'data.frame' but is",
        class(new.log.entry)
      )
    )



  .tryCatchLog.env$last.log <- rbind(.tryCatchLog.env$last.log, new.log.entry)

  return(.tryCatchLog.env$last.log)

}

