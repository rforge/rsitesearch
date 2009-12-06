###################################################
### chunk number 1: 
###################################################
options(width = 60, useFancyQuotes = FALSE)


###################################################
### chunk number 2: Petal.Length
###################################################
help.search('Petal.Length')


###################################################
### chunk number 3: Petal.Length.sos
###################################################
library(sos)
PL <- findFn('Petal.Length')


###################################################
### chunk number 4: Petal.Length.sos.2
###################################################
PL <- ???Petal.Length


###################################################
### chunk number 5: summary.PL
###################################################
# the following table has been
# manually edited for clarity
summary(PL)


###################################################
### chunk number 6: summary.PL-print
###################################################
s <- summary(PL)
blank <- data.frame(Package = "<...>",
                    Count = "", MaxScore = "", 
                    TotalScore = "",
                    Date = "")
s$PackageSummary[] <- lapply(s$PackageSummary[], as.character)
row.names(s$PackageSummary) <- 
  as.character(s$PackageSummary$Package)
s$PackageSummary <- rbind(s$PackageSummary['yaImpute', ],
                          blank,
                          s$PackageSummary['datasets', ],
                          blank)
print(s, row.names = FALSE)


###################################################
### chunk number 7: Petal.Length.sos.3
###################################################
PL[PL$Package == 'datasets', 'Function']


###################################################
### chunk number 8: Petal.Length.sos.3-print
###################################################
print(PL[PL$Package == 'datasets', 'Function'], max.levels = 0)


###################################################
### chunk number 9: RSiteSearch-spline
###################################################
RSiteSearch('spline')


###################################################
### chunk number 10: RSiteSearch-spline-numpages
###################################################
getRSiteSearchHits <- function(description) {
  con <- url(description)
  on.exit(close(con))
  lines <- readLines(con)
  pattern <- "^.*<!-- HIT -->([0-9]+)<!-- HIT -->.*$"
  hits <- sub(pattern, "\\1", lines[grep(pattern, lines)])
  today <- format(Sys.time(), "%Y-%m-%d")
  list(hits = hits, date = today)
}
splineHits <- getRSiteSearchHits("http://search.r-project.org/cgi-bin/namazu.cgi?query=spline&max=20&result=normal&sort=score&idxname=Rhelp08&idxname=functions&idxname=views")


###################################################
### chunk number 11: RSiteSearch-spline-fun
###################################################
RSiteSearch('spline', 'fun')


###################################################
### chunk number 12: RSiteSearch-spline-fun-numpages
###################################################
splineFunHits <- getRSiteSearchHits("http://search.r-project.org/cgi-bin/namazu.cgi?query=spline&max=20&result=normal&sort=score&idxname=functions")


###################################################
### chunk number 13: sos-spline
###################################################
splinePacs <- findFn('spline')


###################################################
### chunk number 14: sos-spline-maxPages-999
###################################################
splineAll <- findFn('spline', maxPages = 999)


###################################################
### chunk number 15: sos-spline-subset
###################################################
selSpl <- splineAll[, 'Function'] == 'spline'
splineAll[selSpl, ]


###################################################
### chunk number 16: sos-spline-grep
###################################################
grepFn('spline', splineAll, ignore.case = TRUE)


###################################################
### chunk number 17: sos-spline-grep
###################################################
g <- grepFn('spline', splineAll, ignore.case = TRUE)
gFunc6 <- as.character(g[6, "Function"])
gPac6 <- as.character(g[6, "Package"])
gScore6 <- g[6, "Score"]
gCount6 <- g[6, "Count"]


###################################################
### chunk number 18: writeFindFn2xls-options
###################################################
op <- options(width = 80)


###################################################
### chunk number 19: writeFindFn2xls
###################################################
writeFindFn2xls(splineAll)


###################################################
### chunk number 20: writeFindFn2xls-options
###################################################
options(op)


###################################################
### chunk number 21: install-and-write-options
###################################################
op <- options(width=80)


###################################################
### chunk number 22: install-and-write
###################################################
splineAll <- findFn('spline', maxPages = 999)
installPackages(splineAll)
writeFindFn2xls(splineAll)


###################################################
### chunk number 23: install-and-write-options-undo
###################################################
options(op)


###################################################
### chunk number 24: differntial-equations
###################################################
de <- findFn('differential equation')
des <- findFn('differential equations')
de. <- de | des


