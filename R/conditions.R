# create a custom condition
# Taken from Hadley Wickham: http://adv-r.had.co.nz/beyond-exception-handling.html
condition <- function(class, message = "", ...) {

  call <- sys.call(-1)   # function call that created the condition

  structure(
    class = c(class, "condition"),
    list(message = message, call = call, ...)
  )

}
