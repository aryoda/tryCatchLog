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



#' Pretty formatted call stack enriched with the source file names and row numbers
#'
#' @description Enriches the current call stack with the source file names and row numbers
#'              to track the location of thrown conditions and generates a prettily formatted list
#'              of strings
#'
#' @param call.stack       Call stack object created by \code{\link{sys.calls}}
#' @param omit.last.items  Number of call stack items to drop from the end of the full stack trace
#' @param compact          TRUE will return only call stack items that have a source code reference (FALSE all)
#'
#' @return  The call stack (\code{\link{sys.calls}}) without the last number of function calls (given by "omit.last.items")
#'          to remove irrelevant calls caused e. g. by exception handler (\code{\link{withCallingHandlers}})
#'          or restarts (of warnings).
#'
#' @details How to read the call stack:
#'          \enumerate{
#'          \item Call stack items consist of:\cr
#'             \code{<call stack item number> [<file name>#<row number>:] <expression executed by this code line>}
#'          \item The last call stack items with a file name and row number points to the source code line causing the error.
#'          \item Ignore all call stack items that do not start with a file name and row number (R internal calls only)
#'          }
#'          You should only call this function from within \code{\link{withCallingHandlers}}, NOT from within \code{\link{tryCatch}}
#'          since tryCatch unwinds the call stack to the tryCatch position and the source of the condition cannot be identified anymore.
#' @seealso \code{\link{tryCatchLog}}, \code{\link{tryLog}}, \code{\link{limitedLabelsCompact}}
#' @export
get.pretty.call.stack <- function(call.stack, omit.last.items = 0, compact = FALSE) {
  if (is.null(call.stack))
    return("")

  # remove the last calls that shall be omitted
  if (length(call.stack) > omit.last.items)
    call.stack <- call.stack[1:(length(call.stack)
                                - omit.last.items)]

  pretty.call.stack <- limitedLabelsCompact(call.stack, compact)
  call.stack.formatted <- paste(" ", seq_along(pretty.call.stack), pretty.call.stack, collapse = "\n")

  return(call.stack.formatted)
}
