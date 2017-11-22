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



# Do not use this to import packages since it makes all functions of these packages available
# (even those who are not used by this package!)
# @import utils
# @import futile.logger
# NULL   # only required if no code follows later



# Better import only the required functions to reduce the dependencies and make them explicit:
# Note: This is an optional step if you qualify all your external function calls with the package name and "::"
#       together with declaring the required packaged in the "Imports" section of the DESCRIPTION file.
#       Source: https://cran.r-project.org/doc/manuals/R-exts.html#Specifying-imports-and-exports

#' @importFrom futile.logger flog.error flog.warn flog.info
#' @importFrom utils         dump.frames
# NULL



# Namespace hook functions called by namespace events
# For details see: http://r-pkgs.had.co.nz/r.html


# Package-global variables are stored in a package-internal environment.
# This is a work-around to keep a package-internal state between differnt
# calls of package functions.
.tryCatchLog.env <- new.env(parent = emptyenv())   # hidden variable (from whom?)



# Say "hello" when loading the package
#
# To suppress the startup and all messages from dependent packages use:
#     suppressMessages(library(tryCatchLog))
# Source: http://stackoverflow.com/a/8681811/4468078
.onAttach <- function(libname, pkgname) {
  # Disabled Nov. 12, 2017 (silly annoying messages)
  # packageStartupMessage(paste(pkgname, "is an R package to improve error handling compared to the standard tryCatch function."))
  # packageStartupMessage("To get an overview over the package enter: help(package = 'tryCatchLog')")
  # packageStartupMessage(paste("Library path (libname):", libname))

}



# Package "constructor" hook
.onLoad <- function(libname, pkgname) {

  # init package-global variables
  .tryCatchLog.env$last.log = data.frame()


  # Create and initialize package options if they do not already exist before loading the package.
  # To avoid conflicts with other packages the option names use the name as prefix.
  op <- options()
  op.devtools <- list(
    tryCatchLog.dump.errors.to.file = FALSE,
    tryCatchLog.silent.warnings     = FALSE,
    tryCatchLog.silent.messages     = FALSE
  )

  toset <- !(names(op.devtools) %in% names(op))  # TRUE for each option that does not yet exist

  if (any(toset)) options(op.devtools[toset])

  invisible()
}
