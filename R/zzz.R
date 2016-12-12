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


# Namespace hook functions called by namespace events
# For details see: http://r-pkgs.had.co.nz/r.html


# Say "hello" when loading the package
#
# To suppress the startup and all messages from dependent packages use:
#     suppressMessages(library(tryCatchLog))
# Source: http://stackoverflow.com/a/8681811/4468078
.onAttach <- function(libname, pkgname) {
  packageStartupMessage(paste(pkgname, "is an R package to improve error handling compared to the standard tryCatch function."))
  packageStartupMessage("To get an overview over the package enter: help(package = 'tryCatchLog')")
  packageStartupMessage(paste("Library path (libname):", libname))

}




# Initialize package options if they do not already exist.
# To avoid conflicts with other packages the option names use the name as prefix.
.onLoad <- function(libname, pkgname) {
  op <- options()
  op.devtools <- list(
    tryCatchLog.dump.errors.to.file = FALSE
  )

  toset <- !(names(op.devtools) %in% names(op))

  if (any(toset)) options(op.devtools[toset])

  invisible()
}
