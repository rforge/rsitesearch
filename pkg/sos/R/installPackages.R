installPackages <- function(x, minCount=sqrt(x[['Count']][1]),
                                    ...){
  pkgsum <- attr(x, 'PackageSummary')
  sel <- (pkgsum$Count > minCount)
  toget <- pkgsum$Package
  install.packages(toget)
}

