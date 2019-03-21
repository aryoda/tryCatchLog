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



#' Checks if a package is installed and can be loaded
#'
#' Use this function to check for optional package dependencies
#' within this package.
#'
#' This is a package-internal function!
#'
#' See section ‘Good practice’ in '?.onAttach'.
#'
#' @param package.name   Name of the package (as string)
#'
#' @return \code{TRUE} if the packages is installed, otherwise \code{FALSE}
#' 
#' http://r-pkgs.had.co.nz/description.html
#'
#' @examples
#' tryCatchLog:::is.package.available("tryCatchLog")  # must be TRUE :-)
#' 
is.package.available <- function(package.name) {
  
  return(requireNamespace(package.name, quietly = TRUE))
  
}
