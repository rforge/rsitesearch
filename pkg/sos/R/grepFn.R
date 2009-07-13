grepFn <- function(pattern, x, ignore.case=FALSE, extended=TRUE,
       perl=FALSE, value=TRUE, fixed=FALSE, useBytes=FALSE,
       invert=FALSE) {
##
## 1.  grep
##
  g <- grep(pattern, x$Function, ignore.case=ignore.case,
            extended=extended, perl=perl, value=FALSE, fixed=fixed,
            useBytes=useBytes, invert=invert)
##
## 2.  value?
##
  {
    if(value)return(x[g, ]) else return(g)
  }
}
