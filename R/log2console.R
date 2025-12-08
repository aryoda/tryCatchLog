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



#' Prints a time-stamped log message to the console incl. the severity level
#'
#' This is a package-internal function.
#'
#' @param severity.level  String containing the severity level
#'                        (\code{ERROR}, \code{WARN} or \code{INFO}) of the message
#' @param msg             The message to be printed (as character).
#'
#' @return                The log message as it was printed to the console.
#'                        \code{NA} is printed as empty string.
#'
#' @examples
#' tryCatchLog:::log2console("WARN", "this is my last warning")
#'
#' @export
log2console <- function(severity.level, msg) {

  if (is.na(msg))
    msg <- ""



  stopifnot(!is.null(severity.level))
  stopifnot(severity.level %in% c("ERROR", "WARN", "INFO"))
  stopifnot(is.character(msg))

  # Design decision:
  # This simple logging function uses the local time
  # (not UTC which would allow to combine different log output with
  #  different time zones more easily).
  log.time <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")

  res <- sprintf("%s [%s] %s\n", severity.level, log.time, msg)

  cat(res)


  invisible(res)
}
