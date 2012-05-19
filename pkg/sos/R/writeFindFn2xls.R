findFn2xls <- function(x,
           file. = paste(deparse(substitute(x)), 'xls', sep = '.'),
           csv, ...) {
  writeFindFn2xls(x, file. = file., csv = csv, ...)
}

writeFindFn2xls <- function(x,
            file. = paste(deparse(substitute(x)), 'xls', sep = '.'),
            csv, ...) {
##
## 1.  x not null?
##
  if(nrow(x) < 1) {
    cat('No matches;  nothing written.\'n')
    return(invisible(''))
  }
##
## 2.  exists(file.)?
##
  if(file.exists(file.)) {
    file.remove(file.)
  }
##
## 3.  Prepare to write
##
  sum2 <- PackageSum2(x)
  sum2$Date <- as.character(as.Date(sum2$Date))
  cl <- data.frame(call=as.character(attr(x, 'call')),
                   stringsAsFactors=FALSE)
  x2 <- lapply(x, function(x)
               if(is.numeric(x)) x else as.character(x))
  x2. <- as.data.frame(x2)
  df2x <- FALSE
  WX <- FALSE
  OB <- FALSE
##
## 4.  Will dataframes2xls work?
##
  if(missing(csv) || !csv){

  # not yet implemented

##
## 5.  Will WriteXLS work?
##
    if(require(WriteXLS)){
      WX <- TRUE
      if(tP <- testPerl()){
        WXo <- try(WriteXLS(c('sum2', 'x2.', 'cl'), ExcelFileName=file.,
                 SheetNames=c('PackageSum2', 'findFn', 'call') ))
        if(class(WXo)!='try-error')return(invisible(file.))
      }
    }
##
## 6.  How about RODBC?
##
    if(require(RODBC)){
      RO <- TRUE
      xlsFile <- try(odbcConnectExcel(file., readOnly=FALSE))
      if(class(xlsFile)!='try-error'){
        on.exit(odbcClose(xlsFile))
#   Create the sheets
        sum2. <- try(sqlSave(xlsFile, sum2, tablename='PackageSum2'))
        if(class(sum2.)!='try-error'){
          x. <- try(sqlSave(xlsFile, as.data.frame(x2), tablename='findFn'))
#
          if(class(x.)!='try-error'){
            cl. <- try(sqlSave(xlsFile, cl, tablename='call'))
            if(class(cl.)!='try=error')return(invisible(file.))
          }
        }
      }
    }
##
## 7.  Write warnings re. can't create xls file
##
    # dataframe2xls error msg
#    if(WX)if(tP)print(WXo)
 #   if(RO){
  #      if(class(xlsFile)!='try-error'){
   #       print(xlsClose)
    #    } else print(xlsFile)
    #}
    warning('\n*** UNABLE TO WRITE xls FILE;  writing 3 csv files instead.')
    xName <- deparse(substitute(x))
    assign(xName, x)
    file0 <- sub('\\.xls$', '', file.)
    saveFile <- paste(file0, 'rda', sep='.')
    do.call(save, list(list=xName, file=saveFile))
    cat('NOTE:  x = ', xName, ' saved to ', saveFile,
        '\nin case you want to try in, e.g., Rgui i386;\n',
        '> load(\"', saveFile, '\"); findFn2xls(', xName, ')\n',
        sep='')
  }
##
## 8.  Write 3 csv files
##
  f.xls <- regexpr('\\.xls', file.)
  if(f.xls>0)file. <- substring(file., 1, f.xls-1)
#
  file3 <- paste(file., c('-sum.csv', '.csv', '-call.csv'), sep='')
  write.csv(sum2, file3[1], ...)
  write.csv(x, file3[2], ...)
  write.csv(cl, file3[3], ...)
  return(invisible(file.))
}
