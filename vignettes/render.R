library(rmarkdown)
library(revealjs)

file.name <- "introduction"
path.to.file <- "vignettes/"

# , slide_level = 3
# Good hightlights: tango
rmarkdown::render(file.path(path.to.file, paste0(file.name, ".Rmd")),
       revealjs_presentation(theme="white", highlight="tango", slideNumber = TRUE),
       encoding = "UTF-8")

browseURL( file.path(path.to.file, paste0(file.name, ".html")))



