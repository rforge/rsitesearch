summary.findFn <- function(object, threshold = 1, ...) {
  Sum <- attr(object, 'PackageSummary')
  sel <- (Sum[, 'Count'] >= threshold)
  sumTh <- Sum[sel,, drop=FALSE]
  structure(list(PackageSummary = sumTh,
                 threshold = threshold,
                 matches = attr(object, "matches"),
                 nrow = nrow(object),
                 nPackages = length(sel),
                 string = attr(object, 'string'),
                 call = attr(object, "call")),
            class = c("summary.findFn", "list"))
}

print.summary.findFn <- function(x, ...) {
  cat("\nCall:\n")
  cat(paste(deparse(x$call), sep = "\n", collapse = "\n"),
      "\n\n", sep = "")
  cat("Total number of matches: ", sum( x$matches) , "\n", sep = "")
  cat('Downloaded ', x$nrow, ' links in ', x$nPackages,
      " package", c('.', 's.')[1+(x$nPackages>1)], "\n\n", sep='')
  string <- x$string
  cat("Packages with at least ", x$threshold, " match",
      if(x$threshold == 1) "" else "es",
      " using search pattern '", string, "':\n", sep = "")
  packSum <- x$PackageSummary
  row.names(packSum) <- NULL
  print(packSum)
  invisible()
}
