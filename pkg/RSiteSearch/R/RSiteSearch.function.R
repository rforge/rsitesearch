RSiteSearch.function <- function(string, maxPages = 10, sort.=NULL,
                                 quiet = FALSE, ...) {
  AnSort <- findFn(string, maxPages, sortby=sort., verbose=2*!quiet)
# hopefully, this will fix a problem with this function
# under R 2.10.1
  class(AnSort) <- c("RSiteSearch", "data.frame")
  AnSort
}
