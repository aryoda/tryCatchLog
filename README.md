# tryCatchLog

## R code for better error handling than `tryCatch`

This repository provides an advanced `tryCatch` function for R called `tryCatchLog`.

The main advantages over `tryCatch` are

* easy **logging** of errors, warnings and messages into a file or console
* identifying the root of errors and warnings by logging a **stack trace with a reference to the source file name and line number**
* optionally allows **post-mortem analysis after errors by creating a dump file** with all variables of the global environment (workspace) and each function called (`dump.frames`)

This code was created to answer the stackoverflow question

[R: Catch errors and continue execution while logging the stacktrace (no traceback available with tryCatch)](https://stackoverflow.com/questions/39964040/r-catch-errors-and-continue-execution-while-logging-the-stacktrace-no-tracebac)



## Installation

### Clone the github repository:

Open the [RStudio IDE](https://www.rstudio.com/products/rstudio/) and select the menu items

File > New Project... > Version Control > Git

Then enter
```
https://github.com/aryoda/tryCatchLog.git
```
into the text field "Repository URL".
    

### Compile and install `tryCatchLog`

**Install `tryCatchLog` as a package**

Compile a package:

* Open the included *tryCatchLog.Rproj* project file with the [RStudio IDE](https://www.rstudio.com/products/rstudio/)

* Select the menu item *Build > Build source package*

Install the generated package with

```R
install.packages("../tryCatchLog_0.0.0.9000.tar.gz", repos = NULL, type = "source")  # adjust the file name!
```

**Alternative: Source the code instead of installing a package**

Simply add the following line to your code:

```R
source("R/tryCatchLog.R")   # adjust the relative path accordingly!
```


## Demo

If you have installed `tryCatchLog` as a package:

```R
demo(package = "tryCatchLog")                               # see a list of all demos
demo(package = "tryCatchLog", topic = "tryCatchLog_demo")   # start a demo
```

If you want to go through the demo source code open the file in the demo sub folder of the source code
```
demo/tryCatchLog_demo.R
```
with the [RStudio IDE](https://www.rstudio.com/products/rstudio/) and run it.



## License

*This code is released under the [GNU GENERAL PUBLIC LICENSE Version 3](LICENSE)*
