is.config <- function(config) {

  res <- list(status = TRUE, findings = "")

  # Design decision:
  # Should we allow NULL (or NA) as valid configuration (= no configuration)?
  # Eg. in config.add.row this would allow to start a new configuration by adding a row to NULL as config
  # (but why then do not directly call config.create() instead?
  # -> No, this is counter-intuitive

  if (!is.data.frame(config)) {
    # Also matches NA and NULL as (invalid) config
    res$findings <- "The config is not a data.frame!\n"
    res$status   <- FALSE
    return(res)
  }

  if (!inherits(config, .CONFIG.CLASS.NAME)) {
    res$findings <- paste0("The config does not inherit from the '", .CONFIG.CLASS.NAME , "' class but only from '", class(config), "'!\n")
    res$status   <- FALSE
    return(res)
  }

  return(res)
}


# Implement throw.error to throw an error with all findings at the end (for reuse purposes - otherwise duplicated at the caller side!)
config.validate <- function(config, throw.error.with.findings = TRUE) {

  # res <- list(status = TRUE, findings = "")
  res <- is.config(config)

  if (res$status == FALSE) {
    if (throw.error.with.findings == TRUE) {
      stop(paste("Invalid tryCatchLog configuration:\n", res$findings))
    } else {
      return(res)  # pre-conditions for further validations failed
    }
  }



  expected_col_names <- c("cond.class", "silent", "write.to.log", "log.as.severity", "include.full.call.stack", "include.compact.call.stack")
  if (any(colnames(config) != expected_col_names)) {
    res$findings <- paste0(res$findings, "The config does not have the expected column names and order!\n")
  }

  expected_col_types <- c("character", "logical", "logical", "character", "logical", "logical")
  actual_col_types   <- sapply(config, class)
  if (any(actual_col_types != expected_col_types)) {
    res$findings <- paste0(res$findings, "The config does not have the expected column classes for all columns!\n")
  }

  if (anyNA(config)) {
    res$findings <- paste0(res$findings, "The config has empty cells (NA value)!\n")
  }

  if ("log.as.severity" %in% colnames(config) && !all(config$log.as.severity %in% tryCatchLog::Severity.Levels)) {
    res$findings <- paste0(res$findings, "There are invalid severity level strings in the column 'log.as.severity' (compare to 'tryCatchLog::Severity.Levels')!\n")
  }

  #  Warn as "unsupported" if "silent" is TRUE for other conditions than "warning" and "error" is NOT possible here
  #  since we need the caught condition class hierarchy (may inherit from "warning" or "error"
  #  so that silencing would still work).
  #  -> There is no reliable way to find this out by just parsing the configuration since it does not contain any class hierarchy!

  if ("cond.class" %in% colnames(config) && any(duplicated(config$cond.class))) {
    res$findings <- paste0(res$findings, "There are duplicated condition class names in cond.class (undefined semantics)!\n")
  }

  res$status = (res$findings == "")

  if (res$status == FALSE && throw.error.with.findings == TRUE) {
    stop(paste("Invalid tryCatchLog configuration:\n", res$findings))
  }

  return(res)

}
