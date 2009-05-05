oops <- function(x,
      fields=c("Version", "Author", "Maintainer", "Packaged"),
                        lib.loc=NULL){
##
## 1.  Add blank columns to x
##
  nf <- length(fields)
  nx <- nrow(x)
  xout <- x
  for(ic in seq(1, length=nf))xout[[fields[ic]]] <- rep('', nx)
##
## 2.  installed packages?
##
  instPkgs <- .packages(TRUE)
  xP <- as.character(x$Package)
##
## 3.  Get packageDescription for each package
##
  for(ip in seq(1, length=nx)){
    if(xP[ip] %in% instPkgs){
      pkgDesci <- packageDescription(x$Package[ip], lib.loc=lib.loc)
      for(ic in 1:nf){
        if(fields[ic] %in% names(pkgDesci)){
          if(fields[ic] == "Packaged"){
            xout$Packaged[ic] <- {
              if(is.null(pkgDesci$Packaged))
                (strsplit(pkgDesci$Built, ';')[[1]][3])
              else
                (strsplit(pkgDesci$Packaged, ';')[[1]][1])
            }
          }
          else
            xout[ip, ic] <- pkgDesci[[fields[ic]]]
        }
      }
    }
  }
##
## 3.  Done
##
  xout
}
