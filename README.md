# tryCatchLog

An R package to improve error handling compared to the standard tryCatch function

Current version: 0.9.7 (Nov. 22, 2017). See the [NEWS](NEWS.md) for most recent changes.



## Table of contents

* [Overview](#overview)
* [Installation](#installation)
* [Examples](#examples)
* [Demo](#demo)
* [FAQ](#faq)
* [Build the package from source using RStudio](#build-the-trycatchlog-package-from-source-code-using-rstudio)
* [How can I contribute?](#how-can-i-contribute)
* [Links](#links)
* [License](#license)



## Overview

This repository provides the source code of an advanced `tryCatch` function for the programming language [R](https://www.r-project.org/) called `tryCatchLog`.

The main advantages of the `tryCatchLog` function over `tryCatch` are

* easy **logging** of errors, warnings and messages into a file or console
* warnings do **not** stop the program execution (`tryCatch` stops the execution if you pass a warning handler function)
* identifies the source of errors and warnings by logging a **stack trace with a reference to the source file name and line number**
  (since `traceback` does not contain the full stack trace)
* allows **[post-mortem analysis](#how-do-i-perform-a-post-mortem-analysis-of-my-crashed-r-script) after errors by creating a dump file** with all variables of the global environment (workspace) and each function called (via `dump.frames`) - very helpful for batch jobs that you cannot debug on the server directly to reproduce the error!

This code was created as an answer to the stackoverflow question

[R: Catch errors and continue execution while logging the stacktrace (no traceback available with tryCatch)](https://stackoverflow.com/questions/39964040/r-catch-errors-and-continue-execution-while-logging-the-stacktrace-no-tracebac)



## Installation

### Dependencies

The source code of `tryCatchLog` uses the package [`futile.logger`](https://cran.r-project.org/web/packages/futile.logger/index.html)
to write logging messages in a nice and structured format to a file or console.

You can find the source code of `futile.logger` is hosted here: https://github.com/zatonovo/futile.logger

Note: To use your own logging function you just have to change the logging function calls in the file `R/tryCatchLog.R`
      and [`source` the file](#option-2-source-the-code-instead-of-installing-a-package) or
      [rebuild the package from source using RStudio](#build-the-trycatchlog-package-from-source-code-using-rstudio).
      There is also an open [feature request to allow injection of your own logging functions](https://github.com/aryoda/tryCatchLog/issues/10).



### Option 1: Install the `tryCatchLog` package from github using `devtools`

**This is the recommended installation procedure!**

To install the package using the source code at github you can use the package `devtools`:

```R
# install.packages("devtools")
library(devtools)
install_github("aryoda/tryCatchLog")
```


### Option 2: `source` the code instead of installing a package

Simply add the following line to your code:

```R
library(futile.logger)
source("R/tryCatchLog.R")   # adjust the relative path accordingly!
```

## Examples

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
        if (dump.errors.to.file == TRUE) {
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
  2 tryCatchLog.R#319: tryCatchLog(expr = expr, dump.errors.to.file = dump.errors.to.file, error = function(e) {
  3 tryCatchLog.R#247: tryCatch(withCallingHandlers(expr, error = function(e) {
Full call stack:
  1 tryLog(log("not a number!"))
  2 tryCatchLog.R#319: tryCatchLog(expr = expr, dump.errors.to.file = dump.errors.to.file, error = function(e) {
<... omitted ...>
> print("Errors cannot stop me")
[1] "Errors cannot stop me"
>
```

Observe that the error did **not** stop the execution of the script so that the next line has been executed too.

You could have achived the same (but with more code) using

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

### Can I install the package via CRAN or from another repository

A prebuilt package file is currently not available but planned (e. g. via a separate github release project).

The package shall be published on [CRAN](https://cran.r-project.org/) only if there is enough demand for that.



### How do I find bug reports, feature requests and other issues?

You can browse and add your own issues at https://github.com/aryoda/tryCatchLog/issues



### What's the problem with `tryCatch`?

`tryCatch` unwinds the call stack to the call of `tryCatch` in case of an error, warning other catched conditions.
This means

* you cannot use `traceback` to identify source code line that cause the problem
* you cannot resume the execution of the expression passed to `tryCatch`
* if you catch warnings (e. g. to write them to a log file) the execution of the expression is stopped (canceled)
  but normally you do **not** want to stop after warnings
  
To overcome the drawbacks of `tryCatch` you must use a combination of an outer `tryCatch` call that executes
the expression within and `withCallingHandlers` function call then. This is a lot of boilerplate code
that is used again and again. You could encapsulte this boilerplate code in your own `myTryCatch` function
and this is exactly what `tryCatchLog` does.



### How can I log into a file instead of the console?

```R
library(futile.logger)

# log to a file (not the console  which is the default target of futile.logger).
# You could also redirect console output into a file if start your R script with a shell script using Rscript!
flog.appender(appender.file("my_app.log"))
```


### How can I reduce the amount of logged conditions?

Set the threshold of the `futile.logger` accordingly:

```R
library(futile.logger)

# Log only errors (not warnings or info messages)
flog.threshold(ERROR)    # TRACE, DEBUG, INFO, WARN, ERROR, FATAL
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


### How do I perform a post-mortem analysis of my crashed R script?

**"Post-mortem analyis"** means to examine the variables and functions calls ("call stack") that led
to a "crash" (= stop of R script execution due to an error) after the R script has stopped.

This is **most helpful in production environments with batch jobs** where you cannot debug interactively
to step through your R code to reproduce and fix the error.

`tryCatchLog` therefore has the feature to create a "memory" dump file that contains the workspace
and in the variable "last.dump" the call stack produced by the R function "sys.frames".

Note: `tryCatchLog` does also allow you to write a memory dump for every catched error that did not stop the execution
(to allow you to analyse the error later after the R script has finished).

**Steps**

1. Wrap your R code with calls to `tryCatchLog` (or `tryLog`).
   If your R code does not yet use `tryCatchLog` it would be enough to add a single `tryCatchLog` call
   at the main level as long as you did not use any `try` or `tryCatch` calls that would catch and handle
   errors (so that `tryCatchLog` does not see your errors).

2. Set the parameter `dump.errors.to.file` to TRUE (or change the default value of this parameter globally
   via `options("tryCatchLog.dump.errors.to.file" = TRUE)`)
   to enable a "memory" dump into a file if your R script throws an error that is catched by `tryCatchLog`.
   
3. Run your code that produces an error

4. Start a new R session on your local computer

5. Load the dump file

    ```R
    load("dump_20161016_164050.rda"  # replace the file name before! The file is contained in the log file in the logged error message!
    ```

    You can see now all the objects in the global workspace that existed when the error occured.
    You furthermore see a variable `last.dump` that was injected by `tryCatchLog` that contains
    the call stack and the variables visible within each function call.

6. Start the debugger

    ```R
    debugger(last.dump)
    ```

    **Note:** The debugger does only allow you to examine the visible variables within the different call stack levels.
    You cannot step through the source code interactively.
    
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
        if (dump.errors.to.file == TRUE) {
         
    11: .handleSimpleError(function (e) 
    {
        call.stack <- sys.calls()
        log.message <- e$message
        if (dump.errors.to.file == TRUE) {
            dump.file.
    12: h(simpleError(msg, call))
    
    Enter an environment number, or 0 to exit  
    Selection: <Cursor is waiting for your input here>
    ```

7.  Walk through the call stack and examine the variable values

    You can now enter the number a number (and press <ENTER>) to switch into the environment
    of a function call to see the visible variables in RStudio or by entering `ls()` in the console.
    By entering the variable name into the console you can see the current value.
    
    To go back to the call stack menu type "f" (= "finish") into the console at the `Browse[1]>` prompt
    and choose a new call stack environment.
    
    To learn more about the concept of an R `environment` you can read the excellent tutorial
    of Suraj Gupta:
    http://blog.obeautifulcode.com/R/How-R-Searches-And-Finds-Stuff/
    
8.  Identify reason for the error

    Since the call stack printed by `debugger` contains the source code file name and line number
    (if you enabled the `keep.source` option) you can narrow down the reason for the error and fix it.



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
  
  

