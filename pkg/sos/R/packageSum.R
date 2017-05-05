packageSum <- function(x,
    fields=c("Title", "Version", "Author",
       "Maintainer", "Packaged", 'helpPages',
       'vignette', 'URL'), 
    lib.loc=NULL, ...){
  UseMethod('packageSum')
}

packageSum.findFn <- function(x,
    fields=c("Title", "Version", "Author",
        "Maintainer", "Packaged", 'helpPages',
        'vignette', 'URL'), 
    lib.loc=NULL, ...){
  packageSum(attr(x, 'PackageSummary'), 
             fields, lib.loc, ...)
}

packageSum.list <- function(x,
    fields=c("Title", "Version", "Author",
        "Maintainer", "Packaged", 'helpPages',
        'vignette', 'URL'), 
    lib.loc=NULL, ...){
  packageSum(x$PackageSummary, fields, 
             lib.loc, ...)
}

packageSum.data.frame <- function(x,
    fields=c("Title", "Version", "Author", 
      "Maintainer", "Packaged", 'helpPages',
      'vignette', 'URL'), 
    lib.loc=NULL, ...){
##
## 1.  PackageSum2
##
  ps2 <- PackageSum2(x, fields=fields, 
                     lib.loc=NULL, ...)
##
## 2.  assign class 
##
  class(ps2) <- c("packageSum", "data.frame")
  ps2
}
