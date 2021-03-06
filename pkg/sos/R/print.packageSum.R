print.packageSum <- function(x,
    where, title,
    openBrowser = TRUE,
    template,  ...) {
##
## 0.  If x has 0 rows, don't go
##    further ...
##
  cl <- deparse(substitute(x)) 
  if(length(grep('\\(', cl))>0)cl <- 'x'
#  print(cl)
  if (nrow(x) < 1) {
    cat("x has zero rows;  ", 
        "nothing to display.\n")
    if (missing(where))
      where <- ""
    return(invisible(where))
  }
##
## 1.  where?
##
  if (missing(where))
    where <- "HTML"
  ##
  if (length(where) == 1 && 
      where == "console")
    where <-  c("Package", "Count", 'MaxScore', 
        'TotalScore', 'Date', "Title", 'Version',
        'Author')
  ##
  if (all(where %in% names(x))) {
    print.data.frame(x[, where])
    return(invisible(""))
  }
  if (length(where)>1)
    stop("if length(where)>1, ", 
      "where must be names of columns of", 
      " x;  they are not.  where = ",
         paste(where, collapse=", "))
  if (toupper(where) == "HTML") {
    f0 <- tempfile()
    for(i in 1:111) {
      File <- paste0(f0, ".html")
      fInf <- file.info(File)
      if(all(is.na(fInf)))
        break
      ## file exists so try another
      f0 <- paste(f0, "1", sep="")
    }
  } else {
    File <- where
  }
##
## 2.  Get call including search
##     string
##
#  cl <- match.call()
  Ocall <- attr(x, "call")
  Oc0 <- deparse(Ocall)
  Oc. <- gsub('\"', "'", Oc0)
  Oc1 <- paste(cl, "<-", paste(Oc., collapse=''))
#  Oc2 <- paste0('For a package summary:  ', 
#  Oc2 <- paste0('installPackages(', cl, 
#    ');  writeFindFn2xls(', cl, ')')
  iPx <- paste0('installPackages(', cl, ',...)')
  w2xls <- paste0('writeFindFn2xls(', cl, ')')
#  ocall <- paste(cl, "<-", Oc1)
#  ocall <- parse(text=Ocx)
  string <- attr(x, "string")
##
## 3.  title, Dir?
##
  if (missing(title)) {
    title <- paste('packageSum for', string)
  }
  Dir <- dirname(File)
  if (Dir == ".") {
    Dir <- getwd()
    File <- file.path(Dir, File)
  } else {
    dc0 <- dir.create(Dir, FALSE, TRUE)
  }
##
## 4.  sorttable.js?
##
##  Dir <- tools:::file_path_as_absolute( dirname(File) )
##  This line is NOT ENOUGH:
##     browseURL(File) needs the full path in File
  js <- system.file("js", "sorttable.js", 
                    package = "sos")
  if (!file.exists(js)) {
    warning("Unable to locate 'sorttable.js' file")
  } else {
    ##*** Future:
    ## Replace "Dir\js" with a temp file
    ## that does not exist, then delete it on.exit
    file.copy(js, Dir)
  }
##
## 5.  Modify x$Title
##
## save "x" as "xin" for debugging
  xin <- x
# Allow x to have a NULL Title 
# to simplify testing of other sos functions   
  Desc <- x$Title 
  if(is.null(Desc))Desc <- ''
  x$Title <- gsub("(^[ ]+)|([ ]+$)", 
      "", as.character(Desc), useBytes = TRUE)
  x[] <- lapply(x, as.character)
##
## 6.  template for brew?
##
  hasTemplate <- !missing(template)
  if (!hasTemplate) {
    templateFile <- system.file("brew",
        "default", "pkgSum.brew.html",
        package = "sos")
    template <- file(templateFile, 
        encoding = "utf-8", open = "r" )
  }
## "brew( template,  File )" malfunctioned;
## try putting what we need in a special environment
  xenv <- new.env()
# str(ocall)
#language findFn(string = "spline", maxPages = 1)
  assign("Oc1", Oc1, envir = xenv)
#  assign("Oc2", cl, envir = xenv)
#  ocall <- paste0(Oc1, '; ', Oc2)
#  ocall <- Oc1
#  assign("ocall", ocall, envir = xenv)
  assign('iPx', iPx, envir=xenv)
  assign('w2xls', w2xls, envir=xenv)
  assign("x", x, envir = xenv)
##
  brew::brew(template, File, envir = xenv)
  if (!hasTemplate) {
    close(template)
  }
##
## 7.  Was File created appropriately?  
##     If no, try Sundar's original code
##
  FileInfo <- file.info(File)
  if (is.na(FileInfo$size) || FileInfo$size <= 0) {
    if (is.na(FileInfo$size)) {
      warning("Brew did not create file ", File)
    } else {
      warning("Brew created a file of size 0")
    }
    cat("Ignoring template.\n")
## Sundar's original construction:
    con <- file(File, "wt")
    on.exit(close(con))
    .cat <- function(...)
      cat(..., "\n", sep = "", file = con, 
          append = TRUE)
    ## start
    cat("<html>", file = con)
    .cat("<head>")
    .cat("<title>", title, "</title>")
    .cat("<script src=sorttable.js type='text/javascript'></script>")
    ## Set up ??? ... with a multiline quote :(  :(  :(
    .cat("<style>\n",
         "table.sortable thead {\n",
         "font: normal 10pt Tahoma, Verdana, Arial;\n",
         "background: #eee;\n",
         "color: #666666;\n",
         "font-weight: bold;\n",
         "cursor: hand;\n",
         "}\n",
         "table.sortable th {\n",
         "width: 75px;\n",
         "color: #800;\n",
         "border: 1px solid black;\n",
         "}\n",
         "table.sortable th:hover {\n",
         "background: #eea;\n",
         "}\n",
         "table.sortable td {\n",
         "font: normal 10pt Tahoma, Verdana, Arial;\n",
         "text-align: center;\n",
         "border: 1px solid blue;\n",
         "}\n",
         ".link {\n",
         "padding: 2px;\n",
         "width: 600px;\n",
         "}\n",
         ".link:hover {\n",
         "background: #eeb;\n",
         "}\n",
         "a {\n",
         "color: darkblue;\n",
         "text-decoration: none;\n",
         "border-bottom: 1px dashed darkblue;\n",
         "}\n",
         "a:visited {\n",
         "color: black;\n",
         "}\n",
         "a:hover {\n",
         "border-bottom: none;\n",
         "}\n",
         "h1 {\n",
         "font: normal bold 20pt Tahoma, Verdana, Arial;\n",
         "color: #00a;\n",
         "text-decoration: underline;\n",
         "}\n",
         "h2 {\n",
         "font: normal bold 12pt Tahoma, Verdana, Arial;\n",
         "color: #00a;\n",
         "}\n",
         "table.sortable .empty {\n",
         "background: white;\n",
         "border: 1px solid white;\n",
         "cursor: default;\n",
         "}\n",
         "</style>\n",
         "</head>")
    ##  Search results ... ???
    .cat("<h1>", title, "</h1>")
# str(ocall)
#language findFn(string = "spline", maxPages = 1)    
    .cat("<h2>call: <font color='#800'>",
         paste(Oc1, collapse = ""), "</font></h2>\n")
    .cat("<h2>Title, etc., are available on ", 
         "installed packages. To get more, use", 
         " <font color='#800'> ", iPx, 
         " </font></h2>")
    .cat("<h2>See also: <font color='#800'>", 
         w2xls, "</font></h2>")
    .cat("<table class='sortable'>\n<thead>")
    link <- as.character(x$pkgLink)
    desc <- gsub("(^[ ]+)|([ ]+$)", "", 
        as.character(x$Title), useBytes = TRUE)
    x$pkgLink <- sprintf("<a href='%s' target='_blank'>%s</a>", 
                      link, desc)
    x$Title <- NULL
    ## change "Link" to "Title and Link"
    ilk <- which(names(x) == "pkgLink")
    names(x)[ilk] <- "Title and Link"
    ##
    .cat("<tr>\n  <th style='width:40px'>Id</th>")
    .cat(sprintf("  <th>%s</th>\n</tr>",
        paste(names(x), collapse = "</th>\n  <th>")))
    .cat("</thead>\n<tbody>")
    paste.list <- c(list(row.names(x)),
        lapply(x, as.character), 
            sep = "</td>\n  <td>")
    tbody.list <- do.call("paste", paste.list)
    tbody <- sprintf("<tr>\n  <td>%s</td>\n</tr>",
                     tbody.list)
    tbody <- sub("<td><a", "<td class=link><a", 
                 tbody, useBytes = TRUE)
    .cat(tbody)
    ## another (shorter) multiline thingy ???
    .cat("</tbody></table></body></html>")
  }
  ##
  ## 8.  Display in a browser?
  ##
  if (openBrowser) {
    FileInf2 <- file.info(File)
    if (is.na(FileInf2$size)) {
      warning("Did not create file ", File,
              ";  nothing to give to a browser.")
    } else {
      if (FileInf2$size <= 0) {
        warning("0 bytes in file ", File, ";  nothing to give to a browser.")
      } else {
        utils::browseURL(File)
      }
    }
  }
  invisible(File)
}
