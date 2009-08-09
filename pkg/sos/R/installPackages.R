installPackages <- function(x, minCount=sqrt(x[['Count']][1]),
                                    ...){
##
## 1.  pkgs needed
##
  pkgsum <- attr(x, 'PackageSummary')
  sel <- (pkgsum$Count >= minCount)
  toget <- pkgsum$Package[sel]
##
## 2.  Installed pkgs?
##
  instPkgs <- .packages(TRUE)
  notInst <- toget[!(toget %in% instPkgs)]
##
## 3.  get not installed
##
  if(length(notInst)>0) install.packages(notInst)
}

