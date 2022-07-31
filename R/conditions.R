 # Create a custom condition
# Taken from Hadley Wickham: http://adv-r.had.co.nz/beyond-exception-handling.html
# It looks like a slidely improved version of "simpleCondition()" (with the call always injected + the option for more elements).
#
# DON'T CHANGE THE SEMANTICS OF THIS FUNCTION - IT IS USED IN UNIT TESTS !!!
#
condition <- function(class, message = "", ...) {

  call <- sys.call(-1)   # function call that created the condition

  structure(
    class = c(class, "condition"),
    # list(message = as.character(message), call = call, ...)
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


# Internal dev documentation about the class hierarchy of different standard conditions:

# This is the structure of an original interrupt condition.
# Observe: There is no "message" or "call" attribute available (other conditions do have that)!
# ic <- structure(list(), class = c("interrupt", "condition"))

# > c <- simpleError("msg")
# > class(c)
# [1] "simpleError" "error"       "condition"
#
# > c <- simpleWarning("msg")
# > class(c)
# [1] "simpleWarning" "warning"       "condition"
#
# > c <- simpleMessage("msg")
# > class(c)
# [1] "simpleMessage" "message"       "condition"
#
# > c <- simpleCondition("msg")
# > class(c)
# [1] "simpleCondition" "condition"

