RSiteSearch.function <- function(string, maxPages = 10, sort.=NULL,
                                 quiet = FALSE, ...) {
##
## RSiteSearch(string, 'fun')
##
## returning a data.frame with one row for each hit
## giving package and 'function' / entry name,
## sorted with the most frequently selected package first
##
## with the following attributes
## hits = total number of hits found by the search
## summary = sort(table(ans$Package));
##      summary contains results for only the first maxPages,
##      so sum(summary) may be less than hits.
##
##
## 0.  Set up
##
  parseHTML <- function(url) {
    code <- download.file(url, tmpfile, quiet = quiet)
    if(code != 0) stop("error downloading file")
    html <- scan(tmpfile, what = "", quiet = TRUE, sep = "\n")
    hits <- as.numeric(sub("^.*<!-- HIT -->(.*)<!-- HIT -->.*$", "\\1",
                           html[grep("<!-- HIT -->", html)]))
    links <- html[grep("http://finzi.psych.upenn.edu/R/library.*R:",
                       html)]
    dates <- html[grep("<strong>Date</strong>", html)]
    pattern <-
      "^.*http://finzi.psych.upenn.edu/R/library/(.*)/html/(.*)\\.html.*$"
    pac <- sub(pattern, "\\1", links)
    fun <- sub(pattern, "\\2", links)
    score <- sub("<dt>.*<strong><a href=.*>R:.*\\(score: (.*)\\).*$",
                 "\\1", links)
    date <- sub("^.*<em>(.*)</em>.*$", "\\1", dates)
    lnk <- sub("<dt>.*<strong><a href=\\\"(.*)\\\">R:.*$", "\\1", links)
    desc <- sub("<dt>.*<strong><a href=\\\".*\\\">R:(.*)</a>.*$", "\\1",
                links)
    desc <- gsub("(<strong.*>)|(</strong>)", "", desc)
    ans <- data.frame(Package = pac, Function = fun,
                      Date = strptime(date, "%a, %d %b %Y %T"),
                      Score = score, Description = desc, Link = lnk)
    attr(ans, "hits") <- hits
    ans
  }
# if substring(string, 1,1) != "{":
  if(substr(string, 1, 1) != "{")
    string <- gsub(" ", "+", string)
  tmpfile <- tempfile()
  url <- sprintf(
   "http://search.r-project.org/cgi-bin/namazu.cgi?query=%s&max=20&result=normal&sort=score&idxname=functions",
                 string)
##
## 1.  Query
##
#  1.1.  Set up
  if(!quiet) cat("retrieving page 1\n")
  ans <- parseHTML(url)
  hits <- attr(ans, 'hits')
#  hits <- max(0, attr(ans, 'hits'))
#  If no hits, return
  if(length(hits) < 1) {
    attr(ans, 'hits') <- 0
    pkgSum <- PackageSummary(ans)
    attr(ans, 'PackageSummary') <- pkgSum
    attr(ans, 'string') <- string
    attr(ans, 'call') <- match.call()
    class(ans) <- c("RSiteSearch", "data.frame")
    return(ans)
  }
#  1.2.  Retrieve
  n <- min(ceiling(hits/20), maxPages)
  if(nrow(ans) < attr(ans, "hits")) {
    for(i in 2:n) {
      if(!quiet) cat("retrieving page ", i, " of ", n, "\n", sep = "")
      url.i <- sprintf("%s&whence=%d", url, 20 * (i - 1))
      ans <- rbind(ans, parseHTML(url.i))
    }
  }
##
## 2.  Compute Summary
##
#  Count <- tapply(rep(1,nrow(ans)), ans$Package, length)
  ans$Score <- as.numeric(as.character(ans$Score))
#  maxSc <- with(ans, tapply(Score, Package, max))
#  totSc <- with(ans, tapply(Score, Package, sum))
#  pkgSum <- cbind(Count, MaxScore=maxSc, TotalScore=totSc)
  pkgSum <- PackageSummary(ans)
##
## 3.  Sort order
##
  s0 <-  c('Count', 'MaxScore', 'TotalScore', 'Package',
           'Score', 'Function', 'Date', 'Description', 'Link')
  s0. <- tolower(s0)
  {
    if(is.null(sort.)) sort. <-  s0
    else {
      s1 <- match.arg(tolower(sort.), s0., TRUE)
      s1. <- c(s1, s0.[!(s0. %in% s1)])
      names(s0) <- s0.
      sort. <- s0[s1.]
    }
  }
#  pkgSort <- sort.[sort. %in%
#                   c('Count', 'MaxScore', 'TotalScore', 'Package')]
#  pkgKey <- with(pkgSum,
#                 data.frame(Package, Count=-Count, MaxScore=-MaxScore,
#                            TotalScore=-TotalScore))
#  o <- do.call('order', pkgKey[pkgSort])
#  packageSum <- pkgSum[o, ]
##
## 4.  Merge(packageSum, ans)
##
  packageSum <- pkgSum
  rownames(pkgSum) <- as.character(pkgSum$Package)
  pkgSum$Package <- NULL
  pkgS2 <- pkgSum[as.character(ans$Package), , drop=FALSE]
  rownames(pkgS2) <- NULL
  Ans <- cbind(as.data.frame(pkgS2), ans)
##
## 5.  Sort Ans by 'sort.'
##
  Ans.num <- Ans[, c('Count', 'MaxScore', 'TotalScore', 'Score')]
  ans.num <- cbind(as.matrix(Ans.num), Date=as.numeric(Ans$Date) )
  Ans.ch <- Ans[, c('Package','Function', 'Description', 'Link')]
  ans.ch <- as.data.frame(as.matrix(Ans.ch))
  ansKey <- cbind(as.data.frame(-ans.num), ans.ch)
#
  oSch <- do.call('order', ansKey[sort.])
  AnSort <- Ans[oSch,]
##
## 6.  attributes
##
  rownames(AnSort) <- NULL
#
  attr(AnSort, "hits") <- hits
  attr(AnSort, 'PackageSummary') <- packageSum
  attr(AnSort, 'string') <- string
  attr(AnSort, "call") <- match.call()
  class(AnSort) <- c("RSiteSearch", "data.frame")
  AnSort
}
