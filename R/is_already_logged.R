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



#' Check if a condition is already logged in the \code{\link{last.tryCatchLog.result}}
#'
#'
#'
#' @note Introduced as replacement for \code{is.duplicated.log.entry} due to
#'       a required signature change to fix issue #55
#'       (https://github.com/aryoda/tryCatchLog/issues/55).
#'
#' @param msg.text           the condition message as it would be logged
#' @param full.stack.trace   the call stack of the condition
#'
#' @return  \code{TRUE} if the condition is already contained in the current log, else \code{FALSE}
#'
#' @seealso \code{\link{last.tryCatchLog.result}},
#'          \code{\link{build.log.entry}}
is.already.logged <- function(msg.text, full.stack.trace) {

  if (is.null(msg.text) & is.null(full.stack.trace))
    return(TRUE)    # treat missing arguments like a duplicate



  log <- last.tryCatchLog.result()

  if (NROW(log) < 1)
    res <- FALSE
  else
    res <- any(log$msg.text == msg.text & log$full.stack.trace == full.stack.trace)

  return(res)

}
