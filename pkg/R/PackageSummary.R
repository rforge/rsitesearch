PackageSummary <- function(x){
##
## 1.  Convert Package to character to avoid corruption
##     from any unused levels
  xP <- as.character(x$Package)
##
## 2.  Count, maxSc, totSc
##
  Count <- tapply(rep(1,nrow(x)), xP, length)
  Sc <- as.numeric(as.character(x$Score))
  maxSc <- tapply(Sc, xP, max)
  totSc <- tapply(Sc, xP, sum)
##
## 3.  Find the first occurrance of each Package to get Date,
##     which would be corrupted by tapply
##
  iP <- tapply(seq(1, length=nrow(x)), xP, function(x)x[1])
  Sum <- data.frame(Package=xP[iP], Count=as.numeric(Count),
                    MaxScore=as.numeric(maxSc),
                    TotalScore=as.numeric(totSc), Date=x$Date[iP],
                    stringsAsFactors=FALSE)
}
