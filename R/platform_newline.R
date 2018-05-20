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



#' Gets the operating system specific new line character(s)
#'
#' CR + LF on Windows, else only LF...
#'
#' The newline character(s) are determined once at package loading time.
#'
#' @return the new line character(s) for the current operating system
#'
#' @export
#'
#' @examples
#' platform.NewLine()
platform.NewLine <- function() {

  return(.tryCatchLog.env$newline)

}



#' Determines the operating system specific new line character(s)
#'
#' CR + LF on Windows, else only LF...
#'
#' This function is pendant to Microsoft's .Net "Environment.NewLine".
#'
#' @return the new line character(s) for the current operating system
#'
#' @references \url{https://stackoverflow.com/questions/47478498/build-string-with-os-specific-newline-characters-crlf-lf-cr-to-write-it-into}
#'
#' @note         THIS IS A PACKAGE INTERNAL FUNCTION AND THEREFORE NOT EXPORTED.
#'
determine.platform.NewLine <- function() {

  if (is.windows()) {
    newline <- "\r\n"
  } else {
    newline <- "\n"
  }

  return(newline)
}




# Just a wrapper function to support mocking of the base function in testthat unit tests via "with_mock"
# (see ?with_mock)
get.sys.name <- function() {
  return(Sys.info()["sysname"])
}



# Just a wrapper function to support mocking of the base function in testthat unit tests via "with_mock"
# (see ?with_mock)
get.platform.OS.type <- function() {
  return(.Platform$OS.type) 
}



#' Determines if R is running on a Windows operating system
#'
#' Throws a warning if an indication for Windows OS were found but the Windows OS cannot be recognized for sure
#' (via a second different check).
#'
#' @return \code{TRUE} of running on a Windows OS else \code{FALSE}
#'
#' @export
#'
#' @examples
#' is.windows()
is.windows <- function() {

  is.windows.1st.opinion <- grepl(tolower(get.platform.OS.type()), "windows", fixed = TRUE)

  sys.name <- get.sys.name()
  is.windows.2nd.opinion <- grepl(tolower(sys.name), "windows", fixed = TRUE)

  if (is.windows.1st.opinion != is.windows.2nd.opinion)
    warning("R seems to run on Windows OS but this could not be recognized for sure")

  return(is.windows.1st.opinion)

}
