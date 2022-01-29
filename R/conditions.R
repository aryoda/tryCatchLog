# create a custom condition
# Taken from Hadley Wickham: http://adv-r.had.co.nz/beyond-exception-handling.html
condition <- function(class, message = "", ...) {

  call <- sys.call(-1)   # function call that created the condition

  structure(
    class = c(class, "condition"),
    list(message = message, call = call, ...)
  )

}



# create a custom error condition.
# This is an internal function for now (eg. for test cases).
# It may become public one day under a different name once
# the API of similar functions in other packages like rlang is stable
# to keep a semantically equal function without function name shadowing...
# class = used for sub classing errors for more exact error handling
#         (the "error" class is always added).
#         Use "NULL" if you don't want to sub class the error
error <- function(class = NULL, message = "", ...) {

  return (condition(c(class, "error"), message, ...))

}
