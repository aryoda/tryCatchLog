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



#' Creates a single string suited as logging output
#'
#' @param log.results  A \code{data.frame} and member of the class \code{tryCatchLog.log.entry}
#'                     with log entry rows as returned by \code{\link{last.tryCatchLog.result}}
#'                     containing the logging information to be prepared for the logging output.
#' @param include.full.call.stack  Flag of type \code{\link{logical}}:
#'                     Shall the full call stack be included in the log output? Since the full
#'                     call stack may be very long it can be omitted by passing \code{FALSE}.
#'
#' @return       A ready to use logging output with stack trace
#'               (as \code{character})
#'
#' @export
#'
#' @seealso      \code{\link{last.tryCatchLog.result}}
#'               \code{\link{build.log.entry}}
#'
#' @note         Supports also a single row created by the package internal function \code{\link{build.log.entry}}
#'               as \code{log.results} argument.
build.log.output <- function(log.results, include.full.call.stack = TRUE) {

  stopifnot("data.frame" %in% class(log.results))



  # append every row of the log result to the output
  res <- ""
  i = 1
  while (i <= NROW(log.results)) {

    res <- paste0(res,
                 "[", log.results$severity[i], "] ", log.results$msg.text[i],
                 "\n\n",
                 "Compact call stack:",
                 "\n",
                 log.results$compact.stack.trace[i],
                 "\n\n",
                 if (include.full.call.stack) {paste0("Full call stack:",
                                               "\n",
                                               log.results$full.stack.trace[i],
                                               "\n\n")
                                              } else ""
           )

    i <- i + 1
  }

  return(res)

}
