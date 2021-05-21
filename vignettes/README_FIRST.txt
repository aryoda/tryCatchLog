Child Rmd files are currently not supported as vignettes in R and knitr
but I needed them to create the vignette and training slides by reusing the same
content in Rmd files.

As a workaround I had to
1. rename the file endings of child Rmd files from "Rmd" to "Rmd_child"
2. add the child Rmd files to the ".install_extras" file in the "vignettes"" folder
   that has a pattern to match all child file names
   (this file is NOT shown in RStudio since it starts with a dot - any workaround for that?)
3. added empty dummy files to the "inst/doc" folder for each child Rmd file.
   Update May 21, 2021: I cannot find an inst folder in git. Is this step deprecated due to the use of .install_extras?

This avoids
1. failures to build the vignette due to missing child Rmd files
2. missing child Rmd files in the built source package file
3. child vignettes shown as stand-alone vignettes in "browseVignettes()"
4. wrong warnings in "R CMD check" due to missing vignette header tags in child Rmd files.

This is a workaround until the gap is solved and released in R and knitr.

How to build the vignette in RStudio:
  "Build > Install and Restart" does not work (no HTML file generated).
  See:
  https://stackoverflow.com/questions/33614660/knitr-rmd-vignettes-do-not-appear-with-vignette/33617870#33617870
  "Currently there is no way to build vignettes using devtools if you just use the RStudio button Build & Reload.
   You have to Build Source Package, and run R CMD INSTALL on the tarball.
   Or run devtools::install(build_vignettes = TRUE) in the R console."
   => devtools::install(build_vignettes = TRUE)



Open questions:

- Is it possible to support all R versions (with and without the fixed version) with one single vignette code?

TODOs:

See:
https://github.com/yihui/knitr/issues/1540
https://bugs.r-project.org/bugzilla3/show_bug.cgi?id=17416
