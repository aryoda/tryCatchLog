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
#' @param expr                  expression to be evaluated
#' @param ...                   condition handler functions (as in \code{\link{tryCatch}}).
#'                              Usual condition names are
#'                              \code{error}, \code{warning}, \code{message} and \code{interrupt}.
#'                              All condition handlers are passed to \code{\link{tryCatch}} as is
#'                              (no filtering, wrapping or changing of semantics).
#' @param pid                   a process id or other text identifier that will be added to msg.text
#' @param finally               expression to be evaluated at the end
#' @param write.error.dump.file \code{TRUE}: Saves a dump of the workspace and the call stack named
#'                              \code{dump_<YYYYMMDD>_at_<HHMMSS.sss>_PID_<process id>.rda}.
#'                              This dump file name pattern shall ensure unique file names in parallel processing scenarios.
#' @param write.error.dump.folder    \code{path}: Saves the dump of the workspace in a specific folder instead of the working directory
#' @param silent.warnings       \code{TRUE}: Warnings are logged only, but not propagated to the caller.\cr
#'                              \code{FALSE}: Warnings are logged and treated according to the global
#'                              setting in \code{\link{getOption}("warn")}. See also \code{\link{warning}}.
#' @param silent.messages       \code{TRUE}: Messages are logged, but not propagated to the caller.\cr
#'                              \code{FALSE}: Messages are logged and propagated to the caller.
#' @param include.full.call.stack  Flag of type \code{\link{logical}}:
#'                     Shall the full call stack be included in the log output? Since the full
#'                     call stack may be very long and the compact call stack has enough details
#'                     normally the full call stack can be omitted by passing \code{FALSE}.
#'                     The default value can be changed globally by setting the option \code{tryCatchLog.include.full.call.stack}.
#' @param include.compact.call.stack Flag of type \code{\link{logical}}:
#'                     Shall the compact call stack (including only calls with source code references)
#'                     be included in the log output? Note: If you ommit both the full and compact
#'                     call stacks the message text will be output without call stacks.
#'                     The default value can be changed globally by setting the option \code{tryCatchLog.include.compact.call.stack}.
#' @return                     the value of the expression passed in as parameter "expr"
#'
#' @details This function shall overcome some drawbacks of the standard \code{\link{tryCatch}} function.\cr
#'          For more details see \url{https://github.com/aryoda/tryCatchLog}.
#'
#'          If the package \pkg{futile.logger} is installed it will be used for writing logging output,
#'          otherwise an internal basic logging output function is used.
#'
#'          Before you call \code{tryCatchLog} for the first time you should initialize
#'          the logging framework you are using (e. g.\pkg{futile.logger} to control
#'          the log output (log to console or file etc.):
#'
#'          \preformatted{  library(futile.logger)
#'   flog.appender(appender.file("my_app.log"))
#'   flog.threshold(INFO)    # TRACE, DEBUG, INFO, WARN, ERROR, FATAL}
#'
#'          If you are using the \pkg{futile.logger} package \code{tryCatchLog} calls
#'          these log functions for the different R conditions to log them:
#'
#'          \enumerate{
#'          \item error   -> \code{\link[futile.logger]{flog.error}}
#'          \item warning -> \code{\link[futile.logger]{flog.warn}}
#'          \item message -> \code{\link[futile.logger]{flog.info}}
#'          }
#'
#'          \strong{`tryCatchLog` does only log the above conditions, other (user-defined)
#'          conditions are currently not not logged but can be catched of course
#'          by passing additional handler functions via the \code{...} argument.}
#'
#'          The log contains the call stack with the file names and line numbers (if available).
#'
#'          R does track source code references of scripts only if you set the option \code{keep.source} to TRUE via
#'          \code{options(keep.source = TRUE)}. Without this option this function cannot enrich source code references.
#'
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
#'          Setting the parameter \code{tryCatchLog.write.error.dump.file} to TRUE allows a post-mortem analysis of the program state
#'          that led to the error. The dump contains the workspace and in the variable "last.dump"
#'          the call stack (\code{\link{sys.frames}}). This feature is very helpful for non-interactive R scripts ("batches").
#'
#'          Setting the parameter \code{tryCatchLog.write.error.dump.folder} to a specific path allows to save the dump in a specific folder.
#           If the path does not exist, the folder will be created using the recursive \code{dir.create()} function.
#'          If not set, the dump will be saved in the working directory.
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
#'          To \bold{avoid that too many dump files filling your disk space} you should omit the \code{write.error.dump.file}
#'          parameter and instead set its default value using the option \code{tryCatchLog.write.error.dump.file} in your
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
#'          \code{\link{getOption}}, \code{\link{last.tryCatchLog.result}},
#'          \code{\link{set.logging.functions}}
#'
#' @references
#'          \url{http://adv-r.had.co.nz/beyond-exception-handling.html}\cr
#'          \url{https://stackoverflow.com/questions/39964040/r-catch-errors-and-continue-execution-after-logging-the-stacktrace-no-tracebac}
#' @examples
#' tryCatchLog(log(-1))   # logs a warning
#' @export
tryCatchLog <- function(expr,
                        # error = function(e) {if (!is.null(getOption("error", stop))) eval(getOption("error", stop)) }, # getOption("error", default = stop),
                        ...,
                        pid = NULL,
                        finally = NULL,
                        write.error.dump.file      = getOption("tryCatchLog.write.error.dump.file", FALSE),
                        write.error.dump.folder    = getOption("tryCatchLog.write.error.dump.folder", "."),
                        silent.warnings            = getOption("tryCatchLog.silent.warnings", FALSE),
                        silent.messages            = getOption("tryCatchLog.silent.messages", FALSE),
                        include.full.call.stack    = getOption("tryCatchLog.include.full.call.stack", TRUE),
                        include.compact.call.stack = getOption("tryCatchLog.include.compact.call.stack", TRUE)
                        ) {


  # closure ---------------------------------------------------------------------------------------------------------
  cond.handler <- function(c) {

    call.stack     <- sys.calls()          # "sys.calls" within "withCallingHandlers" is like a traceback!
    log.message    <- c$message            # TODO: Should we use conditionMessage instead?
    timestamp      <- Sys.time()
    dump.file.name <- ""

    # stack.trace <<- call.stack     # helper code for updating the "test_build_log_entry" unit test

    severity <-       if (inherits(c, "error"))   "ERROR"
                 else if (inherits(c, "warning")) "WARN"
                 else if (inherits(c, "message")) "INFO"
                 else stop(sprintf("Unsupported condition class %s!", class(c)))



    # Save dump to allow post mortem debugging?
    if (write.error.dump.file == TRUE & severity == "ERROR") {

      # See"?dump.frames" on how to load and debug the dump in a later interactive R session!
      # See https://stackoverflow.com/questions/40421552/r-how-make-dump-frames-include-all-variables-for-later-post-mortem-debugging/40431711#40431711
      # why you should avoid dump.frames(to.file = TRUE)...
      # https://bugs.r-project.org/bugzilla/show_bug.cgi?id=17116
      # An enhanced version of "dump.frames" was released in spring 2017 but does still not fulfill the requirements of tryCatchLog:
      # dump.frames(dumpto = dump.file.name, to.file = TRUE, include.GlobalEnv = TRUE)  # test it yourself!
      # See ?strptime for the available formatting codes...
      #
      # Creates a (hopefully) unique dump file name even in case of multiple parallel processes
      # or multiple sequential errors in the same R process.
      # Fixes issue #39 by appending fractional seconds (milliseconds) and the process id (PID)
      # https://github.com/aryoda/tryCatchLog/issues/39
      # Example dump file name: dump_2019-03-13_at_15-39-33.086_PID_15270.rda
      dump.file.name  <- paste0(format(timestamp, format = "dump_%Y-%m-%d_at_%H-%M-%OS3"), "_PID_", Sys.getpid(), ".rda")  # %OS3 (= seconds incl. milliseconds)
      dir.create(path = write.error.dump.folder, recursive = T, showWarnings = F)
      utils::dump.frames()
      save.image(file = file.path(write.error.dump.folder, dump.file.name))  # an existing file would be overwritten silently :-()
    }



    log.entry <- build.log.entry(timestamp, severity, log.message, pid, call.stack, dump.file.name, omit.call.stack.items = 1)

    if (!is.duplicated.log.entry(log.entry)) {

      log.msg <- build.log.output(log.entry,
                                  include.full.call.stack = include.full.call.stack,
                                  include.compact.call.stack = include.compact.call.stack)

      switch(severity,
             ERROR = .tryCatchLog.env$error.log.func(log.msg),  # e. g. futile.logger::flog.error(log.msg),
             WARN  = .tryCatchLog.env$warn.log.func(log.msg),   # e. g. futile.logger::flog.warn(log.msg),
             INFO  = .tryCatchLog.env$info.log.func(log.msg)    # e. g. futile.logger::flog.info(log.msg)
      )



      append.to.last.tryCatchLog.result(log.entry)

    }  # end of "is duplicated log entry"



    # in any case (duplicated condition or not)...



    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # Having handled a condition (calling a handler function) in withCallingHandlers does NOT stop it
    # from propagating to other handlers up the call stack ("bubble up").
    # This requires to call a "restart" (e. g. a predefined "muffle" [suppress] restart function).
    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!



    # Suppresses the warning (logs it only)?
    if (silent.warnings & severity == "WARN") {
      # flog.info("invoked restart")
      invokeRestart("muffleWarning")           # the warning will NOT bubble up now!
    } else {
      # The warning bubbles up and the execution resumes only if no warning handler is established
      # higher in the call stack via try or tryCatch
    }



    if (silent.messages & severity == "INFO") {
      invokeRestart("muffleMessage")            # the message will not bubble up now (logs it only)
    } else {
      # Just to make it clear here: The message bubbles up now
    }

  }



  # function logic --------------------------------------------------------------------------------------------------

  reset.last.tryCatchLog.result()



  tryCatch(
    withCallingHandlers(expr,
                        error   = cond.handler,
                        warning = cond.handler,
                        message = cond.handler
    ),       # end of withCallingHandlers
    # pass error handler argument of tryCatchLog to tryCatch
    # error = err.handler, # error,
    ...,
    finally = finally
  )
}
