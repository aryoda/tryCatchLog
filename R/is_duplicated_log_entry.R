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



#' Check if a new log entry would be a duplicate of on an already existing log entry
#'
#' The \code{log.entry} is checked against the existing log entries from
#' \code{\link{last.tryCatchLog.result}} using the following columns:
#'         \enumerate{
#'         \item{msg.text}
#'         \item{full.stack.trace}
#'         }
#'
#' @note  Required function to fix issue # 18
#'        (\url{https://github.com/aryoda/tryCatchLog/issues/18})
#'
#' @param log.entry  A \code{data.frame} with the new log entry (exactly one row)
#'
#' @return  \code{TRUE} if the \code{log.entry} is a duplicate, else \code{FALSE}
#'
#' @seealso \code{\link{last.tryCatchLog.result}},
#'          \code{\link{build.log.entry}}
is.duplicated.log.entry <- function(log.entry) {

  if (is.null(log.entry))
    return(TRUE)    # an empty entry is useless - treat it like a duplicate

  stopifnot("tryCatchLog.log.entry" %in% class(log.entry))



  log <- last.tryCatchLog.result()

  if (NROW(log) < 1)
    res <- FALSE
  else
    res <- any(log$msg.text == log.entry$msg.text & log$full.stack.trace == log.entry$full.stack.trace)

  return(res)

}
