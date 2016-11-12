library(roxygen2)

# WORKS ========================================================================================

# roxygen2::roxygenise()
#
# To learn the documenation workflow see: https://cran.r-project.org/web/packages/roxygen2/vignettes/rd.html
#
# For learning how to generate Rd files with roxygen see this introduction by Hadley Wickham:
# https://cran.r-project.org/web/packages/roxygen2/vignettes/rd.html
#
# Requires: R files in R folder, man folder must exist,
# DESCRIPTION file must exist (generate with devtools::create_description())
# devtools::create_description()
#
# Generates Rd files and creates or overwrites the NAMESPACE file using the @export tags!
roxygen2::roxygenise()



# # DOES NOT WORK =====================================================================================
# # https://stackoverflow.com/questions/18923405/possible-to-create-rd-help-files-for-objects-not-in-a-package
# # How to create Rd help files for objects not in a package?
# 
# compile2Rd <- function() {
#   
#   mydir <- "."
#   # myfiles <- c("tryCatchLog.R") # dir(pattern = ".R$")  # c("myData.R","otherData.R")
#   myfiles <- c("test.R") # c("tryCatchLog.R") # dir(pattern = ".R$")  # c("myData.R","otherData.R")
#   
#   # get parsed source into roxygen-friendly format
#   env <- new.env(parent = globalenv())
#   rfiles <- sapply(myfiles, function(f) file.path(mydir,f))
#   blocks <- unlist(lapply(rfiles, roxygen2:::parse_file, env=env), recursive=FALSE)
#   parsed <- list(env=env, blocks=blocks)
#   
#   # parse roxygen comments into rd files and output then into the "./man" directory
#   roc <- roxygen2:::rd_roclet()
#   results <- roxygen2:::roc_process(roc, parsed, mydir)
#   roxygen2:::roc_output(roc, results, mydir, options=list(wrap=FALSE), check = FALSE)
#   
#   # Error: Missing name at tryCatchLog
# 
# }
