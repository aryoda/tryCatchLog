# Namespace hook functions called by namespace events
# For details see: http://r-pkgs.had.co.nz/r.html


# Say "hello" when loading the package
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

  if(any(toset)) options(op.devtools[toset])

  invisible()
}
