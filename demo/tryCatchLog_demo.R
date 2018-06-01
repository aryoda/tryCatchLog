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


# library(futile.logger)   # https://cran.r-project.org/web/packages/futile.logger/index.html

library(tryCatchLog)



# global default setting for all tryCatchLog call params "write.error.dump.file"
options("tryCatchLog.write.error.dump.file" = FALSE)

# Uncomment the code line below to let futile.logger log to a file
# instead of the default target (console).
# But you could also redirect console output into a file in your shell script that runs Rscript
# flog.appender(appender.file("my_app.log"))
# flog.threshold(INFO)    # TRACE, DEBUG, INFO, WARN, ERROR, FATAL

# Some variables to demonstrate what can be done with "dump.frames"
a.string <- "some text"
a.negative.number <- -1

print(getOption("keep.source"))
# options(keep.source = TRUE)
#script.dir <- dirname(sys.frame(1)$ofile) # Note: Causes an error when NOT sourced but called via Rscript:
# Error in sys.frame(1) : not that many frames on the stack

bad.function <- function(value)
{
  print("bad.function started")
  hello = "Hello world!"
  message(simpleMessage(paste("bad.function message:", hello, "\n")))
  log(value)                  # the log function may cause an error or warning depending on the value
  print("bad.function finished")
}

tryCatchLog( {
               bad.function(a.negative.number)
               bad.function(a.string)
             },
             # Handle the error
             error = function(e)
             {
               # ... do here whatever you want here
               print("Error handling starts now...")
             }
             , finally = # no function() !
             {
               print("Finally...")
             }
             # , write.error.dump.file = TRUE    # uncomment this line to test the error dump feature for post mortem analysis using load + debugger
)




# tryLog examples -------------------------------------------------------------------------------------------------

# tryLog is similar to try and does not stop in case of an error but only logs it:

print("Start")
tryLog(log("not a number!"))
print("Errors cannot stop me")

# The same could be done with more code using tryCatchLog:
print("Start")
tryCatchLog(log("not a number!"), error = function(e) {})
print("Errors cannot stop me")



print("Demo has finished...")    # Proof that the error does not stop the program execution




# Collection of helpful links (not yet ordered) -------------------------------------------------------------------


# A dump file can loaded later in another R session, so post-mortem debugging is possible for batch usage of R.
# For details see:
# http://adv-r.had.co.nz/Exceptions-Debugging.html
#
# Steps to start a post mortem analysis:
# load("dump_20161016_164050.rda")
# debugger(dump_20161016_164050)


# The "limitedLabels" function is undocumented but since the source is available
# by entering "limitedLabels" and the required data structure ("srcrefs" attribute) is documented here
# it is acceptable to use this function nevertheless (instead of duplicating this logic).
#
# Background information about the "srcrefs" attribute
# https://journal.r-project.org/archive/2010-2/RJournal_2010-2_Murdoch.pdf


# Get last error message: geterrmessage()
# Get the last (or all) warnings: tail(warnings(), 1)

# z <- tryCatch(for(i in seq_len(1e8))log(exp(i/10)), error=function(e) {print("error"); e}, interrupt=function(e) {print("interrupt"); e})
# class(z)


# References
#
# 1. Printing stack trace and continuing after error occurs in R
#    https://stackoverflow.com/questions/1975110/printing-stack-trace-and-continuing-after-error-occurs-in-r
#    -> uncovered the undocumented "limitedLabels" function to format the stack trace (call stack) with file names and line numbers
#    -> how to get the stack trace (call stack) of the current error using "sys.calls" within "withCallingHandlers"
#    ->  the traceback() function only provides information about uncaught exceptions
# 2. How to continue program execution after an error handling with "withCallingHandlers()"
#   https://stackoverflow.com/questions/16680623/how-to-continue-function-when-error-is-thrown-in-withcallinghandlers-in-r
#   -> "withCallingHandlers" does not change the program flow it just calls the handler functions
#   -> Solution: Sourround "withCallingHandlers" with "tryCatch" (or "try")
#
# 3. Post mortem analysis with "dump.frames"
#    Because the dump can be looked at later or even in another R session, post-mortem debugging is possible even for batch usage of R.
#      http://adv-r.had.co.nz/Exceptions-Debugging.html
#    Intro
#      http://www.hep.by/gnu/r-patched/r-exts/R-exts_84.html
#    get stack trace on tryCatch'ed error in R:
#      https://stackoverflow.com/questions/15282471/get-stack-trace-on-trycatched-error-in-r
#      -> file naming pattern for dump files
#      https://stackoverflow.com/questions/1975110/printing-stack-trace-and-continuing-after-error-occurs-in-r
#      -> Links to documentation around post mortem analysis
#
# !!! Beyond Exception Handling: Conditions and Restarts
#   http://adv-r.had.co.nz/beyond-exception-handling.html
#   -> explains the ideas behind conditions and restarts and why it should be better than simple exception handling
#
# Note: The script still stops in case of an error when using withCallingHandlers alone (without try or tryCatch):
# !!! https://stackoverflow.com/questions/32167959/in-r-why-does-withcallinghandlers-still-stops-execution
# -> wrapping withCallingHandlers with tryCatch resolves the problem
# -> limitedLabels = formatting of the dump with source/line numbers
#
# Others:
# Can you make R print more detailed error messages?
#   https://stackoverflow.com/questions/7485514/can-you-make-r-print-more-detailed-error-messages
#   -> Describes quite well the error hunting requirements within batch jobsr
# How can I access the name of the function generating an error or warning?
#   https://stackoverflow.com/questions/3984862/how-can-i-access-the-name-of-the-function-generating-an-error-or-warning
#   -> the $call variable of the error object contains the function name where the error occured (NOT the full stack trace!)
# How do I save warnings and errors as output from a function?
#   https://stackoverflow.com/questions/4948361/how-do-i-save-warnings-and-errors-as-output-from-a-function/4952908#4952908
#   -> !!! Sample wrapper function for tryCatch
#
# https://stackoverflow.com/questions/21618796/optionserror-dump-frames-vs-optionserror-utilsrecover
# https://stackoverflow.com/questions/4442518/general-suggestions-for-debugging-in-r

# http://blog.obeautifulcode.com/R/A-Warning-About-Warning/

# https://stackoverflow.com/questions/35785142/suppress-warnings-using-trycatch-in-r
#
# See ?withCallingHandlers for the difference with tryCatch.
# The former remembers the call stack down to the point where the condition was signaled,
# so execution can resume where it left off. tryCatch unwinds the call stack to the point
# where tryCatch was established, so execution can't resume.
# You can use an error handler with withCallingHandlers, or a warning handler with tryCatch,
# but neither use makes sense: an error means that the code can't continue, and a warning doesn't mean you have to stop.


# https://stackoverflow.com/questions/18023252/saving-workspace-in-a-particular-frame-for-post-mortem-debugging-in-r?rq=1
# save(list=ls(), file="mylocals.Rda")
# save(list = ls(all = TRUE), file = ".RData")."
# ls() was only returning the local objects in the browsing environment and that those would be different than the objects resident in .GlobalEnv
# save has an parameter "eval.promises"!


# !!!
# https://stackoverflow.com/questions/40421552/r-how-make-dump-frames-include-all-variables-for-later-post-mortem-debugging/40431711#40431711

# srcref
# https://stackoverflow.com/questions/24546356/r-logging-display-name-of-the-script


# !!! bind a logging functions for warnings and errors to the try catch and always continue after warnings
# and also be able to perform multiple attempts at try catch.
# Also supports supressing identical warnings that are thrown in a sequence
# https://stackoverflow.com/questions/19433848/handling-errors-before-warnings-in-trycatch?rq=1
