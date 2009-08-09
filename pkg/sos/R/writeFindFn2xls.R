writeFindFn2xls <- function(x,
           file.=paste(deparse(substitute(x)), 'xls', sep='.')) {
##
## 1.  open connection
##
  if(!require(RODBC))stop('Need the RODBC package.')
  if(!(.Platform$OS.type=="windows"))
    stop('Does not work on non-Windows platform:(')
  xlsFile <- odbcConnectExcel(file., readOnly=FALSE)
##
## 2.  Create the sheets
##
  sum2 <- PackageSum2(x)
  sum2$Date <- as.character(as.Date(sum2$Date))
  sum2. <- sqlSave(xlsFile, sum2, tablename='PackageSum2')
#
  x2 <- lapply(x, function(x)
               if(is.numeric(x)) x else as.character(x))
  x. <- sqlSave(xlsFile, as.data.frame(x2), tablename='findFn')
#
  cl <- data.frame(call=as.character(attr(x, 'call')),
                   stringsAsFactors=FALSE)
  cl. <- sqlSave(xlsFile, cl, tablename='call')
##
## 3.  Done
##
  fileClose <- odbcClose(xlsFile)
#
  file.
}

