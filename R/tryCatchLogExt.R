tryCatchLogExt <- function( expr,
                            ...,
                            execution.context.msg      = "",
                            finally                    = NULL,
                            write.error.dump.file      = getOption("tryCatchLog.write.error.dump.file", FALSE),
                            write.error.dump.folder    = getOption("tryCatchLog.write.error.dump.folder", "."),
                            config                     = getOption("tryCatchLog.ext.config", NULL)
  ) {


# TODO Refactor the tryCatchLog() work-horse to separate the public interface from the private implementation
#      that also accepts more internal arguments (not meant to be part of the public API)



}
