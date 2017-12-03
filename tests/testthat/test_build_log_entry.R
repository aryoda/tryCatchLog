library(futile.logger)
library(tryCatchLog)
library(testthat)



context("build.log.entry")

# set up test context
options("tryCatchLog.dump.errors.to.file" = FALSE)
options("tryCatchLog.silent.warnings"     = FALSE)
options("tryCatchLog.silent.messages"     = FALSE)



flog.threshold("FATAL")                         # suppress logging of errors and warnings to avoid overly output
# flog.threshold("INFO")



test_that("basics", {

  stack.trace <- sys.calls()

  log.entry <- tryCatchLog:::build.log.entry(Sys.time(), "ERROR", "Message in a bottle", stack.trace, "", 0)

  expect_s3_class(log.entry, "data.frame")
  expect_s3_class(log.entry, "tryCatchLog.log.entry")

  expect_equal(log.entry$severity, "ERROR")
  expect_equal(log.entry$msg.text, "Message in a bottle")

})



test_that("stack trace is correct", {

  # The example stack trace was saved with:
  # save(stack.trace, file = "stack_trace.RData")
  load("stack_trace.RData")

  timestamp <- Sys.time()

  log.entry <- tryCatchLog:::build.log.entry(timestamp, "ERROR", "msg", stack.trace, "", 0)

  expect_equal(log.entry$timestamp, timestamp)
  expect_equal(log.entry$severity, "ERROR")
  expect_equal(log.entry$msg.text, "msg")

  expect_equal(log.entry$compact.stack.trace,
               paste0("  1 tryLog(log(\"abc\"))\n",
                      "  2 tryLog.R#49: tryCatchLog(expr = expr, dump.errors.to.file = dump.errors.to.file, error = function(e) {\n",
                      "  3 tryCatchLog.R#135: tryCatch(withCallingHandlers(expr, error = function(e) {"
               )
  )

  # TODO  Also load the expected result from a text file using readLines (to much text here...)
  expect_equal(log.entry$full.stack.trace,
               paste0("  1 tryLog(log(\"abc\"))\n",
                      "  2 tryLog.R#49: tryCatchLog(expr = expr, dump.errors.to.file = dump.errors.to.file, error = function(e) {\n",
                      "        msg <- conditionMessage(e)\n",
                      "        invisible(structure(msg, class = \"try-error\", condition = e))\n",
                      "    }, silent.warnings = silent.warnings, silent.messages = silent.messages)\n",
                      "  3 tryCatchLog.R#135: tryCatch(withCallingHandlers(expr, error = function(e) {\n",
                      "        call.stack <- sys.calls()\n",
                      "        {\n",
                      "            .doTrace(browser())\n",
                      "            log.message <- e$message\n",
                      "        }\n",
                      "        if (dump.errors.to.file == TRUE) {\n",
                      "            dump.file.name <- format(Sys.time(), format = \"dump_%Y%m%d_%H%M%S\")\n",
                      "            utils::dump.frames()\n",
                      "            save.image(file = paste0(dump.file.name, \".rda\"))\n",
                      "            log.message <- paste0(log.message, \"\\n",
                      "Call stack environments dumped into file: \", dump.file.name, \".rda\")\n",
                      "        }\n",
                      "        log.entry <- build.log.entry(names(futile.logger::ERROR), log.message, call.stack, 1)\n",
                      "        log.msg <- buildLogMessage(log.message, call.stack, 1)\n",
                      "        append.to.last.tryCatchLog.result(log.entry)\n",
                      "        futile.logger::flog.error(log.msg)\n",
                      "    }, warning = function(w) {\n",
                      "        call.stack <- sys.calls()\n",
                      "        log.entry <- build.log.entry(names(futile.logger::WARN), w$message, call.stack, 1)\n",
                      "        log.msg <- buildLogMessage(w$message, call.stack, 1)\n",
                      "        append.to.last.tryCatchLog.result(log.entry)\n",
                      "        futile.logger::flog.warn(log.msg)\n",
                      "        if (silent.warnings) {\n",
                      "            invokeRestart(\"muffleWarning\")\n",
                      "        }\n",
                      "        else {\n",
                      "        }\n",
                      "    }, message = function(m) {\n",
                      "        call.stack <- sys.calls()\n",
                      "        log.entry <- build.log.entry(names(futile.logger::INFO), m$message, call.stack, 1)\n",
                      "        log.msg <- buildLogMessage(m$message, call.stack, 1)\n",
                      "        append.to.last.tryCatchLog.result(log.entry)\n",
                      "        futile.logger::flog.info(log.msg)\n",
                      "        if (silent.messages) {\n",
                      "            invokeRestart(\"muffleMessage\")\n",
                      "        }\n",
                      "        else {\n",
                      "        }\n",
                      "    }), ..., finally = finally)\n",
                      "  4 tryCatchList(expr, classes, parentenv, handlers)\n",
                      "  5 tryCatchOne(expr, names, parentenv, handlers[[1]])\n",
                      "  6 doTryCatch(return(expr), name, parentenv, handler)\n",
                      "  7 withCallingHandlers(expr, error = function(e) {\n",
                      "        call.stack <- sys.calls()\n",
                      "        {\n",
                      "            .doTrace(browser())\n",
                      "            log.message <- e$message\n",
                      "        }\n",
                      "        if (dump.errors.to.file == TRUE) {\n",
                      "            dump.file.name <- format(Sys.time(), format = \"dump_%Y%m%d_%H%M%S\")\n",
                      "            utils::dump.frames()\n",
                      "            save.image(file = paste0(dump.file.name, \".rda\"))\n",
                      "            log.message <- paste0(log.message, \"\\n",
                      "Call stack environments dumped into file: \", dump.file.name, \".rda\")\n",
                      "        }\n",
                      "        log.entry <- build.log.entry(names(futile.logger::ERROR), log.message, call.stack, 1)\n",
                      "        log.msg <- buildLogMessage(log.message, call.stack, 1)\n",
                      "        append.to.last.tryCatchLog.result(log.entry)\n",
                      "        futile.logger::flog.error(log.msg)\n",
                      "    }, warning = function(w) {\n",
                      "        call.stack <- sys.calls()\n",
                      "        log.entry <- build.log.entry(names(futile.logger::WARN), w$message, call.stack, 1)\n",
                      "        log.msg <- buildLogMessage(w$message, call.stack, 1)\n",
                      "        append.to.last.tryCatchLog.result(log.entry)\n",
                      "        futile.logger::flog.warn(log.msg)\n",
                      "        if (silent.warnings) {\n",
                      "            invokeRestart(\"muffleWarning\")\n",
                      "        }\n",
                      "        else {\n",
                      "        }\n",
                      "    }, message = function(m) {\n",
                      "        call.stack <- sys.calls()\n",
                      "        log.entry <- build.log.entry(names(futile.logger::INFO), m$message, call.stack, 1)\n",
                      "        log.msg <- buildLogMessage(m$message, call.stack, 1)\n",
                      "        append.to.last.tryCatchLog.result(log.entry)\n",
                      "        futile.logger::flog.info(log.msg)\n",
                      "        if (silent.messages) {\n",
                      "            invokeRestart(\"muffleMessage\")\n",
                      "        }\n",
                      "        else {\n",
                      "        }\n",
                      "    })\n",
                      "  8 .handleSimpleError(function (e) \n",
                      "    {\n",
                      "        call.stack <- sys.calls()\n",
                      "        {\n",
                      "            .doTrace(browser())\n",
                      "            log.message <- e$message\n",
                      "        }\n",
                      "        if (dump.errors.to.file == TRUE) {\n",
                      "            dump.file.name <- format(Sys.time(), format = \"dump_%Y%m%d_%H%M%S\")\n",
                      "            utils::dump.frames()\n",
                      "            save.image(file = paste0(dump.file.name, \".rda\"))\n",
                      "            log.message <- paste0(log.message, \"\\n",
                      "Call stack environments dumped into file: \", dump.file.name, \".rda\")\n",
                      "        }\n",
                      "        log.entry <- build.log.entry(names(futile.logger::ERROR), log.message, call.stack, 1)\n",
                      "        log.msg <- buildLogMessage(log.message, call.stack, 1)\n",
                      "        append.to.last.tryCatchLog.result(log.entry)\n",
                      "        futile.logger::flog.error(log.msg)\n",
                      "    }, \"non-numeric argument to mathematical function\", quote(log(\"abc\")))\n",
                      "  9 h(simpleError(msg, call))"
               )
  )


  log.entry <- tryCatchLog:::build.log.entry(Sys.time(), "ERROR", "msg", stack.trace, "", 6)

  expect_equal(log.entry$compact.stack.trace,
               paste0("  1 tryLog(log(\"abc\"))\n",
                      "  2 tryLog.R#49: tryCatchLog(expr = expr, dump.errors.to.file = dump.errors.to.file, error = function(e) {\n",
                      "  3 tryCatchLog.R#135: tryCatch(withCallingHandlers(expr, error = function(e) {"
               )
  )

  log.entry <- tryCatchLog:::build.log.entry(Sys.time(), "ERROR", "msg", stack.trace, "", 7)

  expect_equal(log.entry$compact.stack.trace,
               paste0("  1 tryLog(log(\"abc\"))\n",
                      "  2 tryLog.R#49: tryCatchLog(expr = expr, dump.errors.to.file = dump.errors.to.file, error = function(e) {"
               )
  )



})
