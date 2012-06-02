back2forwardslash <- function(nmax=1, pattern='\\', replacement='/'){
  x <- scan(what=character(), quote=pattern, nmax=nmax)
#
  x. <- gsub(pattern, replacement, x, fixed=TRUE)
  paste(x., collapse=' ')
}
