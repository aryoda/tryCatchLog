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
#'         as \code{\link{list}} comprised of one element per logged condition
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
#' @seealso \code{\link{last.tryCatchLog.result},
#'          \code{\link{append.to.last.tryCatchLog.result}},
#'
#' @note         THIS IS A PACKAGE INTERNAL FUNCTION AND THEREFORE NOT EXPORTED.
reset.last.tryCatchLog.result <- function() {

  .tryCatchLog.env$last.log = list()

  invisible(TRUE)

}



#' Appends a new log entry to the stored logging output of the last call to \code{tryCatchLog} or \code{tryLog}
#'
#' You can get the last logging output by calling \code{\link{last.tryCatchLog.result}}.
#'
#' THIS FUNCTION IS USED ONLY PACKAGE INTERNALLY!
#'
#' @param new.log.entry the new log entry (normally as \code{character} string)
#'
#' @return the extended logging result of the last call to \code{tryCatchLog} or \code{tryLog} as \code{list}
#'
#' @seealso \code{\link{last.tryCatchLog.result},
#'          \code{\link{reset.last.tryCatchLog.result}},
#'
#' @note         THIS IS A PACKAGE INTERNAL FUNCTION AND THEREFORE NOT EXPORTED.
append.to.last.tryCatchLog.result <- function(new.log.entry) {

  # TODO Support condition type marker ("was this entry an error?"), e. g. by using the name of the string as condition type?

  if (typeof(new.log.entry) != "character")
    stop(
      paste(
        "The actual value of the parameter 'new.log.entry' is not of the type 'character' but",
        typeof(new.log.entry)
      )
    )



  .tryCatchLog.env$last.log <- c(.tryCatchLog.env$last.log, new.log.entry)

  return(.tryCatchLog.env$last.log)

}

