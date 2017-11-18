<!--
For the conventions for files NEWS and ChangeLog in the GNU project see
https://www.gnu.org/prep/standards/standards.html#Documentation
-->

# tryCatchLog package: Change history

This file describes the major changes of bug fixes in the package "tryCatchLog"

--------------------------------------------------------------------------------

## upcoming (planned to be released in the next version)

* TODO: SEMANTICAL CHANGES: Changed error handler semantics in tryCatchLog to be as close to tryCatch as possible
* TODO: CHANGE OF SIGNATURE: Default value for error handler in tryCatchLog removed
* TODO: Debugging error handler problem if used in RStudio (tryCatchLog(log("a"))

--------------------------------------------------------------------------------


## Version 0.9.5 (Nov. 18, 2017)

* Added: Function `last.tryCatchLog.log` to retrieve the log output of the call of `tryLog` or `tryCatchLog`
* Fixed bug #17: tryCatchLog throws: Error in value[[3L]](cond) : unused argument (cond)
* NULL as value for error argument throws an explicit error (instead of an implicit deep down in R)
* Improved: Documentation


## Version 0.9.4 (Nov. 28, 2016)

* Added: Parameter `silent.messages` to `tryCatchLog` and `tryLog`
* License: Added the copyright header to each R file to clarify the legal side


## Version 0.9.3 (Nov. 28, 2016)

* Added: Parameter `silent.warnings` to  `tryCatchLog` and `tryLog`


## Version 0.9.2 (Nov. 27, 2016)

* Added: First working version of the `tryLog` function


## Version 0.9.1 (Nov. 20, 2016)

* First stable version with the `tryCatchLog` function as "working horse"
