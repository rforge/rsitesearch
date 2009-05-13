unionRSiteSearch <- function(x, y, sort.=NULL) {
##
## 1.  rbind
##
  xy <- rbind(x, y)
##
## 2.  Find and merge duplicates
##
  if(!('Link' %in% names(xy)))
    stop('Neither x nor y contain Link')
  uL <- table(xy$Link)
  dups <- names(uL[uL>1])
  ndups <- length(dups)
  keep <- rep(TRUE, nrow(xy))
  Sc <- xy$Score
  for(i in seq(1, length=ndups)){
    whichi <- which(xy$Link == dups[i])
    if(Sc[whichi[1]]>Sc[whichi[2]])
      keep[whichi[2]] <- FALSE
    else keep[whichi[1]] <- FALSE
  }
  xy. <- xy[keep, ]
##
## 3.  Rebuild summary and resort
##
  xys <- sortRSiteSearch(xy.[,
     c('Package', 'Score', 'Function', 'Date', 'Description', 'Link')])
##
## 4.  Fix attributes
##
  attr(xys, 'hits') <- c(attr(x, 'hits'), attr(y, 'hits'))
  attr(xys, 'string') <- paste(attr(x, 'string'), attr(y, 'string'),
                               sep=' | ')
  attr(xys, 'call') <- call( "(", call( "|", attr(x, "call"), attr(y, "call") ) )
##
## 5.  Done
##
  xys
}
