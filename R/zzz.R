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

# Imports DISABLED since there is longer an "Imports" dependency on futile.logger (since version 1.1.0):
# @importFrom futile.logger flog.error flog.warn flog.info
# @importFrom utils         dump.frames
# NULL



# Namespace hook functions called by namespace events
# For details see: http://r-pkgs.had.co.nz/r.html


# Package-global variables are stored in a package-internal environment.
# This is a work-around to keep a package-internal state between differnet
# calls of package functions.
.tryCatchLog.env <- new.env(parent = emptyenv())   # hidden variable (from whom?)



# Say "hello" when loading the package
#
# To suppress the startup and all messages from dependent packages use:
#     suppressMessages(library(tryCatchLog))
# Source: https://stackoverflow.com/a/8681811/4468078
.onAttach <- function(libname, pkgname) {

  # # Indicate which logging package is used
  # if (.tryCatchLog.env$found.futile.logger == TRUE) {             # is.package.available("futile.logger")) {
  #   packageStartupMessage("Using futile.logger for logging...")
  # } else if (.tryCatchLog.env$found.lgr == TRUE) {             # is.package.available("futile.logger")) {
  #   packageStartupMessage("Using lgr for logging...")
  # } else {
  #   packageStartupMessage("futile.logger not found. Using tryCatchLog-internal functions for logging...")
  # }

  packageStartupMessage("Using ", .tryCatchLog.env$active.logging.package, " for logging...")

}



# Package "constructor" hook
# See section ‘Good practice’ in '?.onAttach', eg.:
# Loading a namespace should where possible be silent, with startup messages given by .onAttach.
.onLoad <- function(libname, pkgname) {


  # print(paste("libname =", libname, "pkgname =", pkgname))  # for debugging only
  # libname = /home/xxx/R/x86_64-pc-linux-gnu-library/3.4 pkgname = tryCatchLog"



  # init package-global variables
  .tryCatchLog.env$last.log <- data.frame()


  # Create and initialize package options if they do not already exist before loading the package.
  # To avoid conflicts with other packages coincidentally having the same option names
  # the option names use the package name as prefix.
  active.options  <- options()
  default.options <- list(
    tryCatchLog.write.error.dump.file = FALSE,
    tryCatchLog.write.error.folder    = ".",
    tryCatchLog.silent.warnings       = FALSE,
    tryCatchLog.silent.messages       = FALSE
  )

  to.set <- !(names(default.options) %in% names(active.options))  # TRUE for each option name that is not set

  if (any(to.set)) options(default.options[to.set])



  # Identify the correct new line character(s) for the current platform
  .tryCatchLog.env$newline <- determine.platform.NewLine()



  # Decide which logging package to use (and enables it)
  set.logging.package()



  invisible()
}
