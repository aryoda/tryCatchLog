is.config <- function(config) {

  res <- list(status = TRUE, findings = "")

  if (!is.data.frame(config)) {
    # Also catches NA and NULL as config
    res$findings <- "Error: The config is not a data.frame!\n"
    res$status   <- FALSE
    return(res)
  }

  if (!inherits(config, tryCatchLog:::.CONFIG.CLASS.NAME)) {
    res$findings <- paste0("Error: The config does not inherit from the '",tryCatchLog:::.CONFIG.CLASS.NAME , "' class but '", class(config), "'!\n")
    res$status   <- FALSE
    return(res)
  }

  return(res)
}



config.validate <- function(config) {

  # res <- list(status = TRUE, findings = "")
  res <- is.config(config)

  if (res$status == FALSE) return(res)  # pre-conditions for further validations failed



  expected_col_names <- c("cond.class", "silent", "write.to.log", "log.as.severity", "include.full.call.stack", "include.compact.call.stack")
  if (any(colnames(config) != expected_col_names)) {
    res$findings <- paste0(res$findings, "Error: The config does not have the expected column names and order!\n")
  }

  expected_col_types <- c("character", "logical", "logical", "character", "logical", "logical")
  actual_col_types   <- sapply(config, class)
  if (any(actual_col_types != expected_col_types)) {
    res$findings <- paste0(res$findings, "Error: The config does not have the expected column classes for all columns!\n")
  }

  if (anyNA(config)) {
    res$findings <- paste0(res$findings, "Error: The config has empty cells (NA value)!\n")
  }

  if (!all(config$log.as.severity %in% tryCatchLog::Severity.Levels)) {
    res$findings <- paste0(res$findings, "Error: There are invalid severity level strings in the column 'log.as.severity' (compare to 'tryCatchLog::Severity.Levels')!\n")
  }

  # TODO:
  # - Warn as "unsupported" if "silent" is TRUE for other "warning" and "error"
  #   -> This is not perfect since any condition class in the config may inherit from error or warning
  #      so silencing would still work (but there is no reliable ways to find this out by just parsing the configuration
  #      since it does not contain the class hierarchy!).

  res$status = (res$findings == "")

  return(res)

}
