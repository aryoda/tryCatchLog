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



#' Try an expression with condition logging and error handling
#'
#' This function evaluates an expression passed in the \code{expr} parameter and executes
#' the error handler function passed as parameter \code{error} in case of an error condition.
#'
#' The \code{finally} expression is then always evaluated at the end.
#'
#' Conditions are logged with the function call stack (including file names and line numbers).
#'
#' @param expr                 expression to be evaluated
#' @param ...                  condition handler functions (as in \code{\link{tryCatch}}).
#'                             Usual condition names are
#'                             \code{error}, \code{warning}, \code{message} and \code{interrupt}.
#'                             All condition handlers are passed to \code{\link{tryCatch}} as is
#'                             (no filtering, wrapping or changing of semantics).
#' @param finally              expression to be evaluated at the end
#' @param dump.errors.to.file  \code{TRUE}: Saves a dump of the workspace and the call stack named \code{dump_<YYYYMMDD_HHMMSS>.rda}
#' @param silent.warnings      \code{TRUE}: Warnings are logged, but not propagated to the caller.\cr
#'                             \code{FALSE}: Warnings are logged and treated according to the global
#'                             setting in \code{\link{getOption}("warn")}. See also \code{\link{warning}}.
#' @param silent.messages      \code{TRUE}: Messages are logged, but not propagated to the caller.\cr
#'                             \code{FALSE}: Messages are logged and propagated to the caller.
#'
#' @return                     the value of the expression passed in as parameter "expr"
#'
#' @details This function shall overcome some drawbacks of the standard \code{\link{tryCatch}} function.\cr
#'          For more details see \url{https://github.com/aryoda/tryCatchLog}.
#'
#'          Before you call \code{tryCatchLog} for the first time you should initialize the \pkg{futile.logger} first:
#'
#'          \preformatted{  library(futile.logger)
#'   flog.appender(appender.file("my_app.log"))
#'   flog.threshold(INFO)    # TRACE, DEBUG, INFO, WARN, ERROR, FATAL}
#'
#'          If you don't initialize the \pkg{futile.logger} at all the logging information will be written on the console only.
#'
#'          The following conditions are logged using the \pkg{futile.logger} package:
#'          \enumerate{
#'          \item error   -> \code{\link[futile.logger]{flog.error}}
#'          \item warning -> \code{\link[futile.logger]{flog.warn}}
#'          \item message -> \code{\link[futile.logger]{flog.info}}
#'          }
#'
#'          \strong{`tryCatchLog` does only catch the above conditions, other (user-defined)
#'          conditions are currently not catched and therefore not logged.}
#'
#'          The log contains the call stack with the file names and line numbers (if available).
#'
#'          R does track source code references only if you set the option \code{keep.source} to TRUE via
#'          \code{options(keep.source = TRUE)}. Without this option this function cannot enrich source code references.
#'          If you use \command{Rscript} to start a non-interactive R script as batch job you
#'          have to set this option since it is FALSE by default. You can add this option to your
#'          \link{.Rprofile} file or use a startup R script that sets this option and sources your
#'          actual R script then.
#'
#'          By default, most packages are built without source reference information.
#'          Setting the environment variable \code{R_KEEP_PKG_SOURCE=yes} before installing a source package
#'          will tell R to keep the source references. You can also use \code{options(keep.source.pkgs = TRUE)}
#'          before you install a package.
#'
#'          Setting the parameter \code{tryCatchLog.dump.errors.to.file} to TRUE allows a post-mortem analysis of the program state
#'          that led to the error. The dump contains the workspace and in the variable "last.dump"
#'          the call stack (\code{\link{sys.frames}}). This feature is very helpful for non-interactive R scripts ("batches").
#'
#'          To start a post-mortem analysis after an error open a new R session and enter:
#'             \code{load("dump_20161016_164050.rda")   # replace the dump file name with your real file name
#'             debugger(last.dump)}
#'
#'          Note that the dump does \bold{not} contain the loaded packages when the dump file was created
#'          and a dump loaded into memory does therefore \bold{not} use exactly the same search path.
#'          This means:
#'
#'          \enumerate{
#'          \item{the program state is not exactly reproducible if objects are stored within a package namespace}
#'          \item{you cannot step through your source code in a reproducible way after loading the image
#'                if your source code calls functions of non-default packages}
#'          }
#'
#' @section Best practices:
#'
#'          To \bold{avoid that too many dump files filling your disk space} you should omit the \code{dump.errors.to.file}
#'          parameter and instead set its default value using the option \code{tryCatchLog.dump.errors.to.file} in your
#'          \link{.Rprofile} file instead (or in a startup R script that sources your actual script).
#'          In case of an error (that you can reproduce) you set the option to \code{TRUE} and re-run your script.
#'          Then you are able to examine the program state that led to the error by debugging the saved dump file.
#'
#'          To see the \bold{source code references (source file names and line numbers)} in the stack traces you must
#'          set this option before executing your code:\cr
#'          \code{options(keep.source = TRUE)}
#'
#'          You can \bold{execute your code as batch with \code{\link{Rscript}} using this shell script command}:\cr
#'          \code{Rscript -e "options(keep.source = TRUE); source('my_main_function.R')"}
#'
#' @seealso \code{\link{tryLog}}, \code{\link{limitedLabels}}, \code{\link{get.pretty.call.stack}},
#'          \code{\link{getOption}}, \code{\link{last.tryCatchLog.result}}
#'
#' @references
#'          \url{https://stackoverflow.com/questions/39964040/r-catch-errors-and-continue-execution-after-logging-the-stacktrace-no-tracebac}
#' @examples
#' tryCatchLog(log(-1))   # logs a warning
#' @export
tryCatchLog <- function(expr,
                        # error = function(e) {if (!is.null(getOption("error", stop))) eval(getOption("error", stop)) }, # getOption("error", default = stop),
                        ...,
                        finally = NULL,
                        dump.errors.to.file = getOption("tryCatchLog.dump.errors.to.file", FALSE),
                        silent.warnings = getOption("tryCatchLog.silent.warnings", FALSE),
                        silent.messages = getOption("tryCatchLog.silent.messages", FALSE)
                       )
{

  reset.last.tryCatchLog.result()



  tryCatch(
    withCallingHandlers(expr,
                        error = function(e)
                        {
                          call.stack <- sys.calls()              # "sys.calls" within "withCallingHandlers" is like a traceback!
                          log.message <- e$message               # TODO: Should we use conditionMessage instead?

                          # Save dump to allow post mortem debugging?
                          # See"?dump.frames" on how to load and debug the dump in a later interactive R session!
                          # See https://stackoverflow.com/questions/40421552/r-how-make-dump-frames-include-all-variables-for-later-post-mortem-debugging/40431711#40431711
                          # why you should avoid dump.frames(to.file = TRUE)...
                          if (dump.errors.to.file == TRUE)
                          {
                            dump.file.name <- format(Sys.time(), format = "dump_%Y%m%d_%H%M%S")   # use %OS3 (= seconds incl. milliseconds) for finer precision
                            utils::dump.frames()
                            save.image(file = paste0(dump.file.name, ".rda"))
                            # https://bugs.r-project.org/bugzilla/show_bug.cgi?id=17116
                            # wait for the enhanced version to be released in spring 2017
                            # dump.frames(dumpto = dump.file.name, to.file = TRUE, include.GlobalEnv = TRUE)  # test it now by using "dump.frames.dev()"
                            log.message <- paste0(log.message, "\nCall stack environments dumped into file: ", dump.file.name, ".rda")
                          }
# x <<- sys.calls() # just for internal debugging purposes
                          # TODO the following lines of code are repeated three times. Extract into function
                          #      But: futile.logger does still not support to pass the severity level as parameter.
                          #           Write a FR? How to explain that?
                          log.entry <- build.log.entry(names(futile.logger::ERROR),
                                                       log.message,
                                                       call.stack,
                                                       1)
                          log.msg <- build.log.output(log.entry)
                          futile.logger::flog.error(log.msg)   # ignore  function calls to this this handler

                          append.to.last.tryCatchLog.result(log.entry)
                        },
                        warning = function(w)
                        {

                          call.stack <- sys.calls()                                 # "sys.calls" within "withCallingHandlers" is like a traceback!
                          log.entry <- build.log.entry(names(futile.logger::WARN),
                                                       w$message,
                                                       call.stack,
                                                       1)
                          log.msg <- build.log.output(log.entry)
                          futile.logger::flog.warn(log.msg)      # ignore last function calls to this handler

                          append.to.last.tryCatchLog.result(log.entry)

                          # Suppresses the warning (logs it only)?
                          if (silent.warnings) {
                            invokeRestart("muffleWarning")           # the warning will NOT bubble up now!
                          } else {
                            # The warning bubbles up and the execution resumes only if no warning handler is established
                            # higher in the call stack via try or tryCatch
                          }
                        }
                        , message = function(m)                                     # Remember: You can ignore messages by setting the log level above "info"
                        {

                          call.stack <- sys.calls()                                 # "sys.calls" within "withCallingHandlers" is like a traceback!
                          log.entry <- build.log.entry(names(futile.logger::INFO),
                                                       m$message,
                                                       call.stack,
                                                       1)
                          log.msg <- build.log.output(log.entry)
                          futile.logger::flog.info(log.msg)      # ignore last function calls to this handler

                          append.to.last.tryCatchLog.result(log.entry)

                          if (silent.messages) {
                            invokeRestart("muffleMessage")            # the message will not bubble up now (logs it only)
                          } else {
                            # Just to make it clear here: The message bubbles up now
                          }
                        }
    ),       # end of withCallingHandlers
    # pass error handler argument of tryCatchLog to tryCatch
    # error = err.handler, # error,
    ...,
    finally = finally
  )
}
