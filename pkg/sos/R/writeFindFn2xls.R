writeFindFn2xls <- function(x,
           file.=paste(deparse(substitute(x)), 'xls', sep='.'),
           csv, ...) {
##
## 1.  csv?
##
  sum2 <- PackageSum2(x)
  sum2$Date <- as.character(as.Date(sum2$Date))
  cl <- data.frame(call=as.character(attr(x, 'call')),
                   stringsAsFactors=FALSE)
  writeFindFn2csv <- function(x, file., sum2.=sum2, cl.=cl, ...){
    f.xls <- regexpr('\\.xls', file.)
    if(f.xls>0)file. <- substring(file., 1, f.xls-1)
#
    file3 <- paste(file., c('-sum.csv', '.csv', '-call.csv'), sep='')
    write.csv(sum2., file3[1], ...)
    write.csv(x, file3[2], ...)
    write.csv(cl., file3[3], ...)
    'done'
  }
  if((!missing(csv)) && csv){
    writeFindFn2csv(x, file., ...)
    return(invisible(file.))
  }
##
## 2.  open connection
##
  if(!require(RODBC)){
    warning('RODBC not available;  writing csv files')
    writeFindFn2csv(x, file., ...)
    return(invisible(file.))
  }
  if(!(.Platform$OS.type=="windows")){
    warning('Does not work on non-Windows platform;  writing csv files')
    writeFindFn2csv(x, file., ...)
    return(invisible(file.))
  }
  xlsFile <- odbcConnectExcel(file., readOnly=FALSE)
##
## 3.  Create the sheets
##
  sum2. <- sqlSave(xlsFile, sum2, tablename='PackageSum2')
#
  x2 <- lapply(x, function(x)
               if(is.numeric(x)) x else as.character(x))
  x. <- sqlSave(xlsFile, as.data.frame(x2), tablename='findFn')
#
  cl. <- sqlSave(xlsFile, cl, tablename='call')
##
## 4.  Done
##
  fileClose <- odbcClose(xlsFile)
#
  file.
}

