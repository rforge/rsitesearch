PackageSummary <- function(x){
  Count <- tapply(rep(1,nrow(x)), x$Package, length)
  x$Score <- as.numeric(as.character(x$Score))
  maxSc <- with(x, tapply(Score, Package, max))
  totSc <- with(x, tapply(Score, Package, sum))
  cbind(Count, MaxScore=maxSc, TotalScore=totSc)
}
