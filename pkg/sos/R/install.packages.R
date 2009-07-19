install.packages <- function(x, ...){
  UseMethod('install.packages')
}

install.packages.default <- function(x, ...){
  utils:::install.packages(x, ...)
}

install.packages.findFn <- function(x, minCount=sqrt(x[['Count']][1]),
                                    ...){
  pkgsum <- attr(x, 'PackageSummary')
  sel <- (pkgsum$Count > minCount)
  toget <- pkgsum$Package
  install.packages(toget)
}

