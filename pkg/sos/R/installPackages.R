installPackages <- function(x, minCount, ...){
  UseMethod('installPackages')
}

installPackages.findFn <- function(x, minCount, ...){
##
## 1.  minCount
##
  if(missing(minCount)) 
    minCount <- sqrt(x[1, 'Count'])
##
## 2.  get PackageSummary from x
##
  pkgsum <- attr(x, 'PackageSummary')
  xName <- substring(deparse(substitute(x)), 1, 25)
  if (is.null(pkgsum))
    stop('not a findFn object;  does not have ',
         'attribute PackageSummary:  ', xName)
##
## 3.  installPackages.packageSum
##
  installPackages.packageSum(pkgsum, minCount, ...)
} 

installPackages.packageSum <- function(x, minCount, 
                                       ...){
##
## 1.  minCount
##
  if(missing(minCount)) 
    minCount <- sqrt(x[1, 'Count'])
  xName <- substring(deparse(substitute(x)), 1, 25)
##
## 2.  Confirm columns Count and Package 
##  
  if (!all(c('Count', 'Package') %in% names(x)))
      stop('Must have columns Count & Package:  ', xName)
##  
## 3.  select Count>=minCount  
##  
  sel <- (x$Count >= minCount)
  toget <- x$Package[sel]
##
## 4.  installPackages.character
##
  installPackages(toget, 1, ...)
}

installPackages.character <- function(x, minCount, 
                                      ...){
##
## 1.  select
##
  nx <- length(x)
  if(missing(minCount))
    minCount <- sqrt(nx)
  sel <- seq(1, length=
               min(nx, trunc(minCount)))
  toget <- x[sel]
##
## 2.  Installed pkgs?
##
  instPkgs <- .packages(TRUE)
  notInst <- toget[!(toget %in% instPkgs)]
##
## 5.  get packages not already installed
##
  if (length(notInst) > 0)
    utils::install.packages(notInst)
}

