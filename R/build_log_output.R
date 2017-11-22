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



#' Internal helper function to build a decent log output for logging
#'
#' @description  Combines a log message with a compact and a detailled stack trace
#'
#' @param log.entry  A \code{data.frame} with one row (created by \code{\link{build.log.entry}}
#'                   containing the logging information to be prepared for the logging output
#'
#' @return       A ready to use log message with a pretty printed compact and detailled stack trace
#'               (as \code{character})
#'
#' @note         THIS IS A PACKAGE INTERNAL FUNCTION AND THEREFORE NOT EXPORTED.
build.log.output <- function(log.entry) {

  stopifnot("data.frame" %in% class(log.entry), NROW(log.entry) == 1)

  res <- paste0("[", log.entry$severity, "] ", log.entry$msg.text,
               "\n\n",
               "Compact call stack:",
               "\n",
               log.entry$compact.stack.trace,
               "\n\n",
               "Full call stack:",
               "\n",
               log.entry$full.stack.trace
         )

  return(res)
}
