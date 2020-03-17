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
#' To view the formatted output print the logging output in a console use \code{\link{cat}}
#' (instead of printing the output with \code{\link{print}} which shows the newline escape codes).
#'
#' @param log.results  A \code{data.frame} and member of the class \code{tryCatchLog.log.entry}
#'                     with log entry rows as returned by \code{\link{last.tryCatchLog.result}}
#'                     containing the logging information to be prepared for the logging output.
#' @param include.full.call.stack  Flag of type \code{\link{logical}}:
#'                     Shall the full call stack be included in the log output? Since the full
#'                     call stack may be very long and the compact call stack has enough details
#'                     normally the full call stack can be omitted by passing \code{FALSE}.
#' @param include.compact.call.stack Flag of type \code{\link{logical}}:
#'                     Shall the compact call stack (including only calls with source code references)
#'                     be included in the log output? Note: If you ommit both the full and compact
#'                     call stacks the message text will be output without call stacks.
#' @param include.severity   \code{logical} switch if the severity level (e. g. ERROR) shall be
#'                           included in the output
#' @param include.timestamp  \code{logical} switch if the timestamp of the catched condition shall be
#'                           included in the output
#' @param use.platform.newline \code{logical}: If \code{TRUE} the line breaks ("newline") will be
#'                             inserted according to the current operationg system (Windows: CR+LF,
#'                             else: CR). If \code{FALSE} R's usual \code{\\n} esacpe character will be inserted
#'                             and it is left to the client to convert this later into the operation-system-specific
#'                             characters. This argument is rarely required (except e. g. if you want to
#'                             write the return value into a database table column).
#'
#' @return       A ready to use logging output with stack trace
#'               (as \code{character})
#'
#' @export
#'
#' @seealso      \code{\link{last.tryCatchLog.result}}
#'               \code{\link{build.log.entry}}
#'
#' @note         The logged call stack details (compact, full or both) can be configured globally
#'               using the options \code{tryCatchLog.include.full.call.stack}
#'               and \code{tryCatchLog.include.compact.call.stack}.
#'
#'               The result of the package internal function \code{\link{build.log.entry}}
#'               can be passed as \code{log.results} argument.
build.log.output <- function(log.results,
                             include.full.call.stack    = getOption("tryCatchLog.include.full.call.stack", TRUE),
                             include.compact.call.stack = getOption("tryCatchLog.include.compact.call.stack", TRUE),
                             include.severity           = TRUE,
                             include.timestamp          = FALSE,
                             use.platform.newline       = FALSE) {

  # TODO Add arguments for incl.timestamp + incl.severity later (redundant output if a logging framework is used!)

  stopifnot("data.frame" %in% class(log.results))



  # append every row of the log result to the output
  res <- ""
  i <- 1
  while (i <= NROW(log.results)) {

    res <- paste0(res,
                  if (include.timestamp)
                    format(log.results$timestamp[i], "%Y-%m-%d %H:%M:%S "),
                  if (include.severity)
                    paste0("[", log.results$severity[i], "] "),
                  log.results$msg.text[i],
                  if (!is.na(log.results$pid[i]))
                    " ", log.results$pid[i], # No condition required, won't show if NULL
                  "\n\n",
                  if (nchar(log.results$dump.file.name[i]) > 0)
                    paste0("Created dump file: ", log.results$dump.file.name[i], "\n\n"),
                  if (include.compact.call.stack) {
                    paste0("Compact call stack:",
                           "\n",
                           log.results$compact.stack.trace[i],
                           "\n\n")
                  },
                  if (include.full.call.stack) {
                    paste0("Full call stack:",
                           "\n",
                           log.results$full.stack.trace[i],
                           "\n\n")
                  }
           )

    i <- i + 1
  }



  if (use.platform.newline)
    res <- gsub("\n", platform.NewLine(), res, fixed = TRUE)



  return(res)

}
