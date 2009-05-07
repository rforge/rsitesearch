summary.RSiteSearch <- function(object, threshold = 1, ...) {
  Sum <- attr(object, 'PackageSummary')
  sel <- (Sum[, 'Count'] >= threshold)
  sumTh <- Sum[sel,, drop=FALSE]
  structure(list(PackageSummary = sumTh,
                 threshold = threshold,
                 hits = attr(object, "hits"),
                 nrow = nrow(object),
                 string = attr(object, 'string'),
                 call = attr(object, "call")),
            class = c("summary.RSiteSearch", "list"))
}

print.summary.RSiteSearch <- function(x, ...) {
  cat("\nCall:\n")
  cat(paste(deparse(x$call), sep = "\n", collapse = "\n"), "\n\n", sep = "")
  cat("Total number of hits: ", x$hits, "\n", sep = "")
  cat("Number of links downloaded: ", x$nrow, "\n\n", sep = "")
  string <- x$string
  cat("Packages with at least ", x$threshold, " hit",
      if(x$threshold == 1) "" else "s",
      " using search pattern '", string, "':\n", sep = "")
  print(x$PackageSummary)
  invisible()
}
