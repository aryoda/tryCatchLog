Child Rmd files are currently not supported as vignettes in R and knitr
but I needed them to create the vignette and training slides from the same
content in Rmd files.

As a workaround I had to
1. rename the file endings of child Rmd files from "Rmd" to "Rmd_child"
2. add the child Rmd files to the ".install_extras" file
3. added empty dummy files to the "inst/doc" folder for each child Rmd file.

This avoids
1. failures to build the vignette due to missing child Rmd files
2. missing child Rmd files the built source package file
3. child vignettes shown as stand-alone vignettes in "browseVignettes()"
4. Wrong warnings in "R CMD check" due to missing vignette header tags in child Rmd files.

This is a workaround until the gap is solved and released in R and knitr.

Open question: Is it possible to support all R versions (with and without
the fixed version) with one single vingnette code?



See:
https://github.com/yihui/knitr/issues/1540
https://bugs.r-project.org/bugzilla3/show_bug.cgi?id=17416
