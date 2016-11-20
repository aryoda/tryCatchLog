# tryCatchLog

An R package to improve error handling compared to the standard tryCatch function



## Table of contents

* [Overview](#overview)
* [Installation](#installation)
* [Examples](#examples)
* [Demo](#demo)
* [FAQ](#faq)
* [License](#license)



## Overview

This repository provides the source code of an advanced `tryCatch` function for the programming language [R](https://www.r-project.org/) called `tryCatchLog`.

The main advantages over `tryCatch` are

* easy **logging** of errors, warnings and messages into a file or console
* warnings do **not** stop the program execution (`tryCatch` stops the execution if you pass a warning handler function)
* identifies the source of errors and warnings by logging a **stack trace with a reference to the source file name and line number**
  (since `traceback` does not contain the full stack trace)
* allows **post-mortem analysis after errors by creating a dump file** with all variables of the global environment (workspace) and each function called (`dump.frames`)

This code was created as an answer to the stackoverflow question

[R: Catch errors and continue execution while logging the stacktrace (no traceback available with tryCatch)](https://stackoverflow.com/questions/39964040/r-catch-errors-and-continue-execution-while-logging-the-stacktrace-no-tracebac)



## Installation

### Dependencies

The source code of `tryCatchLog` uses the package [`futile.logger`](https://cran.r-project.org/web/packages/futile.logger/index.html)
to write logging messages in a nice and structured format to a file or console.

Note: To use your own logging function you just have to change the logging functions calls in the file `R/tryCatchLog.R`
      and `source` the file or rebuild the package (see [Installation](#installation)).



### Clone the github repository:

Open the [RStudio IDE](https://www.rstudio.com/products/rstudio/) and select the menu items

File > New Project... > Version Control > Git

Then enter
```
https://github.com/aryoda/tryCatchLog.git
```
into the text field "Repository URL".
    

### Build and install `tryCatchLog`

#### Option 1: Install `tryCatchLog` as a package

Build a package:

* Open the included *tryCatchLog.Rproj* project file with the [RStudio IDE](https://www.rstudio.com/products/rstudio/)

* Select the menu item *Build > Build source package*

Install the generated package with

```R
install.packages("../tryCatchLog_0.9.1.tar.gz", repos = NULL, type = "source")  # adjust the file name!
```

**Note: A prebuild package file is currently not available but planned (e. g. via a separate github release project).**



#### Option 2: `source` the code instead of installing a package

Simply add the following line to your code:

```R
source("R/tryCatchLog.R")   # adjust the relative path accordingly!
```

## Examples

```R
library(tryCatchLog)
tryCatchLog(log("abc"))
```
results in a log entry that shows the function call hierarchy with the last call (number 5 in the compact call stack)
showing the R code line causing the error:
```
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


## Demo

To learn how `tryCatchLog` works you should open the demo source file that includes many
explanatory comments and run it.

To run the demo source code open the file in the demo sub folder of the source code
```
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

A prebuild package file is currently not available but planned (e. g. via a separate github release project).



## License

*This code is released under the [GNU GENERAL PUBLIC LICENSE Version 3](LICENSE)*

To get a quick overview over this license you can read [A Quick Guide to GPLv3](https://www.gnu.org/licenses/quick-guide-gplv3.html)
