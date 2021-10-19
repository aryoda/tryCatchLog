# tryCatchLog

An R package to improve the error handling of the standard `tryCatch` and `try` function

**Current version:** See the [NEWS](NEWS.md) for the most recent changes.

[![Build Status](https://app.travis-ci.com/aryoda/tryCatchLog.svg?branch=master)](https://app.travis-ci.com/aryoda/tryCatchLog)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/aryoda/tryCatchLog?branch=master&svg=true)](https://ci.appveyor.com/project/aryoda/tryCatchLog)
[![codecoverage statistics](https://codecov.io/gh/aryoda/tryCatchLog/branch/master/graph/badge.svg)](https://codecov.io/gh/aryoda/tryCatchLog)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version-ago/tryCatchLog)](https://cran.r-project.org/package=tryCatchLog)
[![CRAN total downloads](http://cranlogs.r-pkg.org/badges/grand-total/tryCatchLog)](https://cran.r-project.org/package=tryCatchLog)



## Table of contents

* [Overview](#overview)
* [Tutorial slides](#tutorial-slides-for-condition-handling-with-standard-r-and-trycatchlog)
* [Installation](#installation)
* [Usage](#usage)
* [Demo](#demo)
* [FAQ](#faq)
* [Build the package from source using RStudio](#build-the-trycatchlog-package-from-source-code-using-rstudio)
* [How can I contribute?](#how-can-i-contribute)
* [Links](#links)
* [License](#license)



## Overview

This repository provides the source code of an advanced `tryCatch` function for the programming language [R](https://www.r-project.org/) called `tryCatchLog`.

The main advantages of the `tryCatchLog` function over `tryCatch` are

* **Easy logging** of errors, warnings and messages into a file or console
* supports code with **[parallel execution logic](#does-trycatchlog-work-in-parallelized-processing-scenarios)**
* **Complete stack trace with references to the source file names and line numbers**
  to identify the source of errors and warnings
  (R's `traceback` does not contain the full stack trace if you catch errors and warnings!)
* allows **[post-mortem analysis](#how-do-i-perform-a-post-mortem-analysis-of-my-crashed-r-script) after errors by creating a dump file** with all variables of the global environment (workspace) and each function called (via `dump.frames`) - very helpful for batch jobs that you cannot debug on the server directly to reproduce the error!
* **Logs warnings** (and other non-error conditions)
  **without stopping the execution** of the evaluated expression
  (unlike `tryCatch` does if you pass a warning handler function, see [this example](#whats-the-problem-with-trycatch))

This package was initially created as an answer to the stackoverflow question.

[R: Catch errors and continue execution while logging the stacktrace (no traceback available with tryCatch)](https://stackoverflow.com/questions/39964040/r-catch-errors-and-continue-execution-while-logging-the-stacktrace-no-tracebac)



## Tutorial slides for condition handling with standard R and `tryCatchLog`

You can find a tutorial slide deck here:

https://aryoda.github.io/tutorials/tryCatchLog/tryCatchLog-intro-slides.html

It is a single self-contained HTML file (made with revealjs, see https://revealjs.com)
so you can save it locally to read it offline.

If you have installed the vignette of the package on your local computer
you can also read the tutorial offline via

```R
# devtools::install(build_vignettes = TRUE)   # workaround to install the vignette if you build via RStudio
browseVignettes("tryCatchLog")
```

**Important:**

- The vignette is only installed automatically if you install `tryCatchLog` from CRAN.

- RStudio does currently **not** install the vignette HTML file if you "build and install".

  Workaround manually to build and install the vignette in RStudio: 
  `devtools::install(build_vignettes = TRUE)`




## Installation

### Option 1: Install the stable version from CRAN


```R
install.packages("tryCatchLog")
# browseVignettes("tryCatchLog")  # to show the vignette(s)
```


### Option 2: Install a stable version from github

**This is the recommended installation procedure for using (beta) releases that are not
yet published at CRAN but already stable enough (not in active development)!**

1. Pick a (beta) release from the [list of Github releases](https://github.com/aryoda/tryCatchLog/tags) (git tags)
2. Install the version by specifying the tag name, eg.

 ```R
 # install.packages("devtools")
 library(devtools)
 install_github("aryoda/tryCatchLog", ref = "v1.1.7")`
 ```



### Option 3: Install the most recent development version from github

**This is the recommended installation procedure for the up-to-date development version!**

To install the package using the source code at github you can use the package `devtools`:

```R
# install.packages("devtools")
library(devtools)
install_github("aryoda/tryCatchLog")
```

If you want to install the vignette (tutorial) on your local computer
you can build it during the installation
(make sure you have installed the suggested packages of the DESCRIPTION file before):

```R
devtools::install_github("aryoda/tryCatchLog", build_vignettes = TRUE)
# browseVignettes("tryCatchLog")  # to show the vignette(s)
```


### Dependencies

`tryCatchLog` has minimal dependencies: Only base `R` and `utils`.

It optionally (= if installed) uses the package
[`futile.logger`](https://cran.r-project.org/web/packages/futile.logger/index.html)
to write logging messages in a nice and structured format to a file or console.

You can find the source code of `futile.logger` here: https://github.com/zatonovo/futile.logger

Note: To use your own logging functionality you just have to register your logging functions
via `set.logging.functions()`. If the package `futile.logger` is installed it will be used automatically as default, otherwise a very basic internal logging function `log2console()` is used (that does not support any convenience functionality like setting the verbosity level but minimizes the dependencies from any other logging framework).



## Usage

### `tryCatchLog` function

```R
library(tryCatchLog)
library(futile.logger)
tryCatchLog(log("abc"))
```
results in a log entry that shows the function call hierarchy with the last call (number 5 in the compact call stack)
showing the R code line causing the error:
```R
ERROR [2016-11-13 17:53:35] non-numeric argument to mathematical function
Compact call stack:
  1 source("~/dev/R/tryCatchLog/demo/tryCatchLog_demo.R", echo = TRUE)
  2 tryCatchLog_demo.R#46: tryCatchLog({
  3 tryCatchLog.R#228: tryCatch(withCallingHandlers(expr, error = function(e) {
  4 tryCatchLog_demo.R#48: bad.function(a.string)
  5 tryCatchLog_demo.R#42: .handleSimpleError(function (e)
Full call stack:
  1 source("~/dev/R/tryCatchLog/demo/tryCatchLog_demo.R", echo = TRUE)
  2 withVisible(eval(ei, envir))
  3 eval(ei, envir)
  4 eval(expr, envir, enclos)
  5 tryCatchLog_demo.R#46: tryCatchLog({
        bad.function(a.negative.number)
        bad.function(a.string)
    }, error = function(e) {
        print("Error handling starts now...")
    }, finally = {
        print("Finally...")
    })
  6 tryCatchLog.R#228: tryCatch(withCallingHandlers(expr, error = function(e) {
  ...
  <omitted>
  ...
  11 tryCatchLog_demo.R#48: bad.function(a.string)
  12 tryCatchLog_demo.R#42: .handleSimpleError(function (e) 
    {
        call.stack <- sys.calls()
        log.message <- e$message
        if (write.error.dump.file == TRUE) {
            dump.file.name <- format(Sys.time(), format = "dump_%Y%m%d_%H%M%S")
            dump.frames()
            save.image(file = paste0(dump.file.name, ".rda"))
            log.message <- paste0(log.message, "\nEnvironment dumped into file: ", dump.file.name, ".rda")
        }
        flog.error(buildLogMessage(log.message, call.stack, 1))
    }, "non-numeric argument to mathematical function", quote(log(value)))
```


### `tryLog` function

The pendant to `try` in R is the `tryLog` function which evaluates an expression and traps errors without
stopping the script execution:

```R
print("Start")
tryLog(log("not a number!"))
print("Errors cannot stop me")
```

results in

```R
> print("Start")
[1] "Start"
> tryLog(log("not a number!"))
ERROR [2016-11-26 23:32:04] non-numeric argument to mathematical function
Compact call stack:
  1 tryLog(log("not a number!"))
  2 tryCatchLog.R#319: tryCatchLog(expr = expr, write.error.dump.file = write.error.dump.file, error = function(e) {
  3 tryCatchLog.R#247: tryCatch(withCallingHandlers(expr, error = function(e) {
Full call stack:
  1 tryLog(log("not a number!"))
  2 tryCatchLog.R#319: tryCatchLog(expr = expr, write.error.dump.file = write.error.dump.file, error = function(e) {
<... omitted ...>
> print("Errors cannot stop me")
[1] "Errors cannot stop me"
>
```

Observe that the error did **not** stop the execution of the script so that the next line has been executed too.

You could have achived similar behaviour (but with more code and without logging) using

```R
print("Start")
tryCatchLog(log("not a number!"), error = function(e) {})
print("Errors cannot stop me")
```



## Demo

To learn how `tryCatchLog` works you should open the demo source file that includes many
explanatory comments and run it.

To run the demo source code open the file in the demo sub folder of the source code
```R
demo/tryCatchLog_demo.R
```
with the [RStudio IDE](https://www.rstudio.com/products/rstudio/).


If you have installed `tryCatchLog` as a package you could also run a demo with
```R
demo(package = "tryCatchLog")                               # see a list of all demos
demo(package = "tryCatchLog", topic = "tryCatchLog_demo")   # start a demo
```

## FAQ

### How do I find bug reports, feature requests and other issues?

You can browse and add your own issues at https://github.com/aryoda/tryCatchLog/issues



### What's the problem with `tryCatch`?

`tryCatch` unwinds the call stack back to the level of the `tryCatch` call in case of an error, warning or other catched conditions.

This means

* you cannot use `traceback` to identify the source code line that cause the problem
  (see the help `?traceback`: *Errors which are caught via try or tryCatch do not generate a traceback...*)
* if you catch non-error conditions like warnings (e. g. to write them to a log file) the execution
  of the evaluated expression is stopped (canceled)
  but normally you do **not** want to stop after warnings but log the warning only and continue with the
  normal program flow:
  
  ```R
  fw <- function() {
    print("before warning")
    warning("a warning message")
    print("after warning")
  }
  
  fw()
  # [1] "before warning"
  # [1] "after warning"
  # Warning message:
  # In fw() : a warning message
  
  tryCatch(fw(), warning = function(w) print("+ warning catched"))
  # [1] "before warning"
  # [1] "+ warning catched"  

  try(fw())
  # [1] "before warning"
  # [1] "after warning"  
  ```
  
To overcome the drawbacks of `tryCatch` you must use a combination of an outer `tryCatch` call that executes
the expression within and inner `withCallingHandlers` function call. This creates a lot of boilerplate code
that is used again and again. You could **encapsulte and reuse this boilerplate code** in your own `myTryCatch` function
and this is exactly what `tryCatchLog` does!



### How can I write the log output into a file instead of the console?

Please read the documentation of the logging package you are using.

Eg. for `futile.logger` you can redirect the log into a file with this code:

```R
library(futile.logger)

# log to a file (not the console  which is the default target of futile.logger).
# You could also redirect console output into a file if start your R script with a shell script using Rscript!
flog.appender(appender.file("my_app.log"))
```


### How can I reduce the amount of logged conditions?

Please read the documentation of the logging package you are using on how the change the logging level (threshold).

Eg. to set the threshold of the `futile.logger` use:

```R
library(futile.logger)

# Log only errors (not warnings or info messages)
flog.threshold(ERROR)    # TRACE, DEBUG, INFO, WARN, ERROR, FATAL
```



### How can I suppress the full (and even the compact) call stack trace to simplify my log?

Since version 1.1.5 (Oct. 2019) `tryCatchLog` and `tryCatch` have two additional arguments named
`include.full.call.stack` and `include.compact.call.stack` which can also be configured globally
via options.

```R
tryCatchLog(log(-1), include.full.call.stack = FALSE)  # specify per call
tryCatchLog(log(-1), include.full.call.stack = FALSE, include.compact.call.stack = FALSE)  # shows only the message
options(include.full.call.stack = FALSE)               # or configure it globally
tryCatchLog(log(-1))                                   # is the same as the first call above
```


### The stack trace does not contain script file names and line number. How can I enable this?

You have to set the option `keep.source` to `TRUE` in your `.Rprofile` file (or the in the Rscript command
line if you call your R script via command line):

```R
options(keep.source = TRUE)
```

**Important:** If you add this option to your R script file the line numbers will be wrong since R seems to count
the line numbers only after this option has been set to TRUE. It is better to set this option
in the `.Rprofile` file or use a start script the sets this option and sources your R script then.

If this doesn't work you can also play around with the option `show.error.locations` (see `help("options")`).



### The stack trace does not contain R file names and line number for my **packages**. How can I enable this?

To see the file name and line numbers of conditions thrown in your own (or other packages) installed from source
you have

1. to enable the `keep.source.pkgs` option **before** (you install the packages!)

    ```R
    options(keep.source.pkgs = TRUE)
    ```

2. install the packages from a source package (binary packages do not have source code included at all)



### How to show line numbers for conditions (errors) when sourcing an R file?

You have to enable the `keep.source` option and source the R file with the `keep.source` parameter
set to `TRUE` (or more precisely: Take care not to pass `FALSE` - the default value is taken from the option):

```R
options(keep.source = TRUE)
source('demo/tryCatchLog_demo.R', keep.source = TRUE)
```



### How to show file names and line numbers in log messages when using `Rscript` to run my R file?

Enter the following command in a shell console (or via a shell script like `bash` or Windows `.CMD` file):

```R
Rscript -e "options(keep.source = TRUE); source('demo/tryCatchLog_demo.R')"  # source your own script
```


### Does `tryCatchLog` work in parallelized processing scenarios?

Yes. `tryCatchLog` is agnostic of parallel oder multi-threading scenarios.

Since version 1.1.7 (April 2020) the new argument `execution.context.msg` makes it possible
to add runtime information like a thread or process information to the message of catched conditions
(see the help in `?tryCatchLog` and the FAQ entry for `execution.context.msg` for details and an example).

Basically you have to consider these things:

1. Enable the logging of the process ID (PID) to be able to identify the process that caused problems
   (eg. use the process ID in the logging file name or in the log output - see the PID FAQ below for an example)
2. Configure the used logging framework for each parallel process to not overwrite the
   log file of another process (eg. by adding the PID to the logging file name)
3. Be aware that theoretically a dump file could be overwritten by another dump file if
   you have two errors within the same millisecond within the same PID
   This is very very unlikely by could happen!

**Beware:**

You should **not** initiate parallel execution logic with the code expression passed as `expr` argument
to `tryCatchLog` or `tryLog` since this is untested (there are so many different parallel execution packages).
Instead you should start the parallel execution from outside and within the same process you can
use `tryCatchLog` and `tryLog` as usual.



### How can I add the process ID (PID) to the logging output?

This depends on the logging framework you are using (read the documentation of the according package).

Normally you don't need the PID in the logs since R uses a single process only.
If you are using a package that supports parallel processing it makes sense to log the PID too.

For `futile.logger` you can enable the PID logging with this code snippet:

```R
# The CRAN version of futile.logger is quite old (v1.4.3 from 2016-07-10 as of today/March 17, 2020):
# The github version has quite more features. To install it use:
# devtools::install_github("zatonovo/futile.logger")  # installs version 1.4.4
library(futile.logger)
library(tryCatchLog)
flog.layout(layout.simple.parallel)     # Use a default format with a process id
flog.info(paste0("PID=", Sys.getpid())) # The logged PID should be the R PID
tryCatchLog(warning("Something is strange..."), include.full.call.stack = FALSE, include.compact.call.stack = FALSE)
```

A typical logging entry does now show the PID after the timestamp:

```R
> flog.info(paste0("PID=", Sys.getpid()))
INFO [2020-03-17 21:33:11 30423] PID=30423
> tryCatchLog(warning("Something is strange..."))
WARN [2020-03-17 21:33:11 30423] [WARN] Something is strange...
...
Warning message:
In withCallingHandlers(expr, error = cond.handler, warning = cond.handler,  :
  Something is strange...
...
```


### How can I use the argument `execution.context.msg` for better debugging of loops or parallel execution?

The `tryCatchLog` package helps to catch and log condition messages and the code lines causing the condition.

What is missing is the program state during execution as context to narrow down the context that caused an error.

A typical example are loops:

```R
library(tryCatchLog)
library(foreach)  # support parallel execution (if you provice an parallel execution engine too)
options(tryCatchLog.include.full.call.stack = FALSE) # reduce the ouput for demo purposes
res <- foreach(i = 1:12) %dopar% {
         tryCatchLog(log(10 - i), execution.context.msg = as.character(i))   # try to find the bug (logarithm of a negative number is not allowed)!
}
```

which shows the "loop number" then in the condition message which helps you to narrow down
the problem during debugging:

```R
WARN [2020-04-06 22:40:36] [WARN] NaNs produced {execution.context.msg: 11}

Compact call stack:
  1 foreach(i = 1:12) %dopar% {
  2 #2: tryCatchLog(log(10 - i), execution.context.msg = as.character(i))
...

WARN [2020-04-06 22:40:36] [WARN] NaNs produced {execution.context.msg: 12}
...
```

Without the loop number debugging would be more time consuming to find the execution state
that causes the problem.



### How do I perform a post-mortem analysis of my crashed R script?

**"Post-mortem analyis"** means to examine the variables and functions calls ("call stack") that led
to a "crash" (= stop of R script execution due to an error) after the R script has stopped.

This is **most helpful in production environments with batch jobs** where you cannot debug interactively
to step through your R code to reproduce and fix the error.

`tryCatchLog` therefore has the feature to create a "memory" dump file that contains the workspace
and the object values along the call stack
(stored in the variable "last.dump" which is created by calling the R function "sys.frames").

Note: `tryCatchLog` does also allow you to write a memory dump for every catched error that did not stop the execution
(to allow you to analyse the error later after the R script has finished).

**Steps**

1. Wrap your R code with calls to `tryCatchLog` (or `tryLog`).
   If your R code does not yet use `tryCatchLog` it would be enough to add a single `tryCatchLog` call
   at the main level as long as you did not use any `try` or `tryCatch` calls that would catch and handle
   errors (so that `tryCatchLog` does not see your errors).

2. Set the parameter `write.error.dump.file` to TRUE (or change the default value of this parameter globally
   via `options("tryCatchLog.write.error.dump.file" = TRUE)`)
   to enable a "memory" dump into a file if your R script throws an error that is catched by `tryCatchLog`.
   
3. Run your code that produces an error

4. Start a new R session on your local computer

5. Load the dump file (or click on the `.rda` file in RStudio)

    ```R
    load("dump_20161016_164050.rda"  # insert your .rda file name which is contained in the log file in the logged error message!
    ```

    You can see now all the objects in the global workspace that existed when the error occured.
    You also see a variable `last.dump` that was injected by `tryCatchLog` and contains
    the call stack and the variables visible within each function call.

6. Start the debugger

    ```R
    debugger(last.dump)
    ```

    **Note:** The debugger does only allow you to examine the visible variables within the different call stack levels.
    You cannot step through the source code interactively as the word "debugger" does imply.
    
    You will now see the error message and the full stack trace (list of function calls up to the point
    the error occured in your R script), e. g.:
    
    ```
    Message:  non-numeric argument to mathematical functionAvailable environments had calls:
    1: source("~/tryCatchLog/demo/tryCatchLog_demo.R", echo = TRUE)
    2: withVisible(eval(ei, envir))
    3: eval(ei, envir)
    4: eval(expr, envir, enclos)
    5: tryCatchLog_demo.R#76: tryCatchLog(log("not a number!"), error = function(e) {
    })
    6: tryCatchLog.R#250: tryCatch(withCallingHandlers(expr, error = function(e) {
        call.stack <- sys.calls()
        log.message <- e$message
        if (dump.err
    7: tryCatchList(expr, classes, parentenv, handlers)
    8: tryCatchOne(expr, names, parentenv, handlers[[1]])
    9: doTryCatch(return(expr), name, parentenv, handler)
    10: withCallingHandlers(expr, error = function(e) {
        call.stack <- sys.calls()
        log.message <- e$message
        if (write.error.dump.file == TRUE) {
         
    11: .handleSimpleError(function (e) 
    {
        call.stack <- sys.calls()
        log.message <- e$message
        if (write.error.dump.file == TRUE) {
            dump.file.
    12: h(simpleError(msg, call))
    
    Enter an environment number, or 0 to exit  
    Selection: <Cursor is waiting for your input here>
    ```

7.  Walk through the call stack and examine the variable values

    You can now enter a number (and press <ENTER>) to switch into the environment
    of a function call to see the visible variables in RStudio or by entering `ls()` in the console.
    By entering the variable name into the console you can see the current value.
    
    To go back to the call stack menu type **"f" (= "finish")** into the console at the `Browse[1]>` prompt
    and choose a new call stack environment.
    
    To learn more about the concept of an R `environment` you can read the excellent tutorial
    of Suraj Gupta:
    http://blog.obeautifulcode.com/R/How-R-Searches-And-Finds-Stuff/
    
8.  Identify reason for the error

    Since the call stack printed by `debugger` contains the source code file name and line number
    (if you enabled the `keep.source` and `keep.source.pkgs` options)
    you can narrow down the reason for the error and fix it.



## Build the `tryCatchLog` package from source code using RStudio

If you want to inspect or modify the source code you should clone the project
using [RStudio IDE](https://www.rstudio.com/products/rstudio/).



### Clone the github repository:

Open the [RStudio IDE](https://www.rstudio.com/products/rstudio/) and select the menu items

File > New Project... > Version Control > Git

Then enter
```
https://github.com/aryoda/tryCatchLog.git
```
into the text field "Repository URL".

    

### Build the `tryCatchLog` package

* Open the included *tryCatchLog.Rproj* project file with the [RStudio IDE](https://www.rstudio.com/products/rstudio/)

* Increment the package's version number in the file `DESCRIPTION` (Attribute `Version`).

* Choose *Build > Test package* and then *Build < Check package*
  and fix any error that occur.

* Select the menu item *Build > Build source package*

The package installation file is now available in the parent folder of the project root folder.



### Install the generated package on other computers

Copy the package file generated in the parent folder of the project on the target computer,
start R and enter:

```R
install.packages("../tryCatchLog_0.9.1.tar.gz", repos = NULL, type = "source")  # adjust the file name!
```


## How can I contribute?

Everyone can help:

* [Write an issue](https://github.com/aryoda/tryCatchLog/issues) to report bugs, suggest improvements and request new features
* improves the [unit tests](https://github.com/aryoda/tryCatchLog/tree/master/tests/testthat) (implemented with `testthat`)
* helps programming (eg. send pull requests)
* ...


To contribute code changes and extensions:

* Fork this project (https://github.com/aryoda/tryCatchLog/fork).
  A fork is a copy of a repository that allows you to experiment with changes without affecting the original repository.
* Create your feature branch (git checkout -b my-new-feature)
* Commit your changes (git commit -am 'Add some feature')
* Push to the branch (git push origin my-new-feature)
* Create a new Pull Request in github



## Links

### Background on R condition handling

* Talk of Lionel Henry (RStudio) at eRum 2018: How to improve error handling
  https://www.youtube.com/watch?v=-v1tp41kizk&t=0s&list=PLUBl0DoLa5SAo_XRnkQA5GtEORg9K7kMh&index=12

* Beyond Exception Handling: Conditions and Restarts (Hadley Wickham):
  http://adv-r.had.co.nz/beyond-exception-handling.html

* Source [Code] References in R (Duncan Murdoch, 2010):
  https://journal.r-project.org/archive/2010-2/RJournal_2010-2_Murdoch.pdf

* Beyond Exception Handling: Conditions and Restarts (Peter Seibel, 2003 - 2005):
  http://www.gigamonkeys.com/book/beyond-exception-handling-conditions-and-restarts.html
  
  

### Logging packages

* https://github.com/zatonovo/futile.logger
* https://github.com/smbache/loggr



## License

*This code is released under the [GNU GENERAL PUBLIC LICENSE Version 3](LICENSE)*

To get a quick overview over this license you can read [A Quick Guide to GPLv3](https://www.gnu.org/licenses/quick-guide-gplv3.html)

Another good overview gives https://tldrlegal.com/license/gnu-general-public-license-v3-(gpl-3)

Further links:

  * [List of GPL-Compatible Free Software Licenses](https://www.gnu.org/licenses/license-list.html#GPLCompatibleLicenses)
  * [License compatibility matrix](https://www.gnu.org/licenses/gpl-faq.html#AllCompatibility)
  
  

## Internal notes

### How to submit a new version to CRAN


* Always check the [CRAN policies](https://cran.r-project.org/web/packages/policies.html) first!
* CI/CD (travis etc. at Github must work without any issue for all R versions, even R-devel!)
* `R CMD check` must run without any finding (not even a note!)
* Increase the version number in the `DESCRIPTION` file and document the CRAN release in the `NEWS.md`
* Build and test on OS X too!
* Build source package and upload the release candiate (*tar.gz file) at win-builder to check for errors.
  (see instructions: https://win-builder.r-project.org/). There is an [upload page](https://win-builder.r-project.org/upload.aspx) for R-release, R-devel and R-oldrelease.
* Finally upload the release candiate file to CRAN via their submission page: https://cran.r-project.org/submit.html
* Re-submission is done in the same way as submission, using the ‘Optional comment’ field on the web form to explain how the feedback on previous submission(s) has been addressed.
* Updates to previously-published packages must have an increased version.
 Increasing the version number at each submission reduces confusion so is preferred even when a previous submission was not accepted. 


### How to build the package using R-devel (development version of R)

To debug problems with the most-recent development version of R you can install R-devel from subversion.

This link provides good instructions on how to do this on Ubuntu Linux with RStudio:

https://www.r-bloggers.com/2015/10/installing-r-devel-on-linux-ubuntu-mint/

(see ~/svn/build-R-devel or into your ~/.profile ;-)

### How to build the package using R-devel (development version of R)

To debug problems with the most-recent development version of R you can install R-devel from subversion.

This link provides good instructions on how to do this on Ubuntu Linux with RStudio:

https://www.r-bloggers.com/2015/10/installing-r-devel-on-linux-ubuntu-mint/

(see ~/svn/build-R-devel or into your ~/.profile ;-)

