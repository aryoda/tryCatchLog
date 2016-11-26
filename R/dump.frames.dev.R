# Taken to test the improved dev branch version of the:
# https://bugs.r-project.org/bugzilla/show_bug.cgi?id=17116
# https://github.com/wch/r-source/blob/trunk/src/library/utils/R/debugger.R
dump.frames.dev <- function(dumpto = "last.dump", to.file = FALSE,
                        include.GlobalEnv = FALSE)
{
  calls <- sys.calls()
  last.dump <- sys.frames()
  names(last.dump) <- limitedLabels(calls)
  if (include.GlobalEnv) {
    ## include a copy of (and not just a reference to) .GlobalEnv in the dump
    ## cp_envir(EE) := as.environment(as.list(EE, all.names=TRUE))
    last.dump <- c(".GlobalEnv" =
                     as.environment(as.list(.GlobalEnv, all.names = TRUE)),
                   last.dump)
  }
  last.dump <- last.dump[-length(last.dump)] # remove this function
  attr(last.dump, "error.message") <- geterrmessage()
  class(last.dump) <- "dump.frames"
  if (dumpto != "last.dump") assign(dumpto, last.dump)
  if (to.file) # compress=TRUE is now the default.
    save(list = dumpto, file = paste(dumpto, "rda", sep = "."))
  else assign(dumpto, last.dump, envir = .GlobalEnv)
  invisible()
}
