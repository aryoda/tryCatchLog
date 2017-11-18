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



#' Internal helper function to build a log message
#'
#' @description  Combines a log message with a compact and a detailled stack trace with the option
#'               to ignore the last x stack trace items (normally created due to internal error handling
#'               and therefore irrelevant for the user).
#'
#' @param log.message      a text message
#' @param call.stack       a call stack created by \code{\link{sys.calls}}
#' @param omit.last.items  number of stack trace items to ignore (= last x items)
#'
#' @return       A ready to use log message with a pretty printed compact and detailled stack trace
#'               (as \code{character})
#'
#' @note         THIS IS A PACKAGE INTERNAL FUNCTION AND THEREFORE NOT EXPORTED.
buildLogMessage <- function(log.message, call.stack, omit.last.items = 0) {
  paste(log.message,
        "Compact call stack:",
        get.pretty.call.stack(call.stack, omit.last.items, compact = TRUE),
        "Full call stack:",
        get.pretty.call.stack(call.stack, omit.last.items),   # ignore 2 stacked functions here
        sep = "\n")
}
