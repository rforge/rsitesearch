HTML <- function(x, ...) {
  UseMethod("HTML")
}

HTML.RSiteSearch <- function(x, file, title, openBrowser = TRUE,
                             template,  ...) {
  ##
  ## 1.  Get call including search string
  ##
  ocall <- attr(x, "call")
  string <- attr(x, 'string')
  ##
  ## 2.  File, title, Dir?
  ##
  if (missing(file)) {
#    file <- sprintf("%s.html", paste(string, collapse = "_"))
    f0 <- tempfile()
    for(i in 1:111){
      file <- paste(f0, '.html', sep='')
      fInf <- file.info(file)
      if(all(is.na(fInf)))break
#     file exists so try another
      f0 <- paste(f0, '1', sep='')
    }
  }
  File <- file
  if (missing(title)) {
    title <- string
  }
  Dir <- dirname(File)
  if (Dir == '.') {
    Dir <- getwd()
    File <- file.path(Dir, File)
  } else {
    dc0 <- dir.create(Dir, FALSE, TRUE)
  }
  ##
  ## 3.  sorttable.js?
  ##
  ##  Dir <- tools:::file_path_as_absolute( dirname(File) )
  ##  This line is NOT ENOUGH:
  ##           browseURL(File) needs the full path in File
  js <- system.file("js", "sorttable.js", package = "RSiteSearch")
  if (!file.exists(js)) {
    warning("Unable to locate 'sorttable.js' file")
  } else {
    ##*** Future:
    ## Replace 'Dir\js' with a temp file
    ## that does not exist, then delete it on.exit
    file.copy(js, Dir)
  }
  ##
  ## 4.  Modify x$Description
  ##
  ## save 'x' as 'xin' for debugging
  xin <- x
  x$Description <- gsub("(^[ ]+)|([ ]+$)", "",
                        as.character(x$Description))
  x[] <- lapply(x, as.character)
  ##
  ## 5.  template for brew?
  ##
  hasTemplate <- !missing(template)
  if (!hasTemplate) {
    templateFile <- system.file("brew", "default", "results.brew.html",
                                package = "RSiteSearch")
    template <- file(templateFile, encoding = "utf-8", open = "r" )
  }
  ## 'brew( template,  File )' malfunctioned;
  ## try putting what we need in a special environment
  xenv <- new.env()
  assign('ocall', ocall, envir=xenv)
  assign('x', x, envir=xenv)
  ##
  brew(template, File, envir = xenv)
  if (!hasTemplate) {
    close(template)
  }
  ##
  ## 6.  Was File created appropriately?  If no, try Sundar's original code
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
      cat(..., "\n", sep = "", file = con, append = TRUE)
    ## start
    cat("<html>", file = con)
    .cat("<head>")
    .cat("<title>", title, "</title>")
    .cat("<script src=sorttable.js type='text/javascript'></script>")
    ## Set up ??? ... with a multiline quote :(  :(  :(
    .cat("<style>
table.sortable thead {
  font: normal 10pt Tahoma, Verdana, Arial;
  background: #eee;
  color: #666666;
  font-weight: bold;
  cursor: hand;
}
table.sortable th {
  width: 75px;
  color: #800;
  border: 1px solid black;
}
table.sortable th:hover {
  background: #eea;
}
table.sortable td {
  font: normal 10pt Tahoma, Verdana, Arial;
  text-align: center;
  border: 1px solid blue;
}
.link {
  padding: 2px;
  width: 600px;
}
.link:hover {
  background: #eeb;
}
a {
  color: darkblue;
  text-decoration: none;
  border-bottom: 1px dashed darkblue;
}
a:visited {
  color: black;
}
a:hover {
  border-bottom: none;
}
h1 {
  font: normal bold 20pt Tahoma, Verdana, Arial;
  color: #00a;
  text-decoration: underline;
}
h2 {
  font: normal bold 12pt Tahoma, Verdana, Arial;
  color: #00a;
}
table.sortable .empty {
  background: white;
  border: 1px solid white;
  cursor: default;
}
</style>
</head>")
    ##  Search results ... ???
    .cat("<h1>RSiteSearch Results</h1>\n")
    .cat("<h2>call: <font color='#800'>",
         paste(deparse(ocall), collapse = ""), "</font></h2>\n")
    .cat("<table class='sortable'>\n<thead>")
    link <- as.character(x$Link)
    desc <- gsub("(^[ ]+)|([ ]+$)", "", as.character(x$Description))
    x$Link <- sprintf("<a href='%s' target='_blank'>%s</a>", link, desc)
    x$Description <- NULL
    ## change "Link" to "Description and Link"
    ilk <- which(names(x)=='Link')
    names(x)[ilk] <- "Description and Link"
    ##
    .cat("<tr>\n  <th style='width:40px'>Id</th>")
    .cat(sprintf("  <th>%s</th>\n</tr>",
                 paste(names(x), collapse = "</th>\n  <th>")))
    .cat("</thead>\n<tbody>")
    paste.list <- c(list(row.names(x)),
                    lapply(x, as.character), sep = "</td>\n  <td>")
    tbody.list <- do.call("paste", paste.list)
    tbody <- sprintf("<tr>\n  <td>%s</td>\n</tr>", tbody.list)
    tbody <- sub("<td><a", "<td class=link><a", tbody)
    .cat(tbody)
    ## another (shorter) multiline thingy ???
    .cat("</tbody>
</table>
</body>
</html>")
  }
  ##
  ## 7.  Display in a browser?
  ##
  if (openBrowser) {
    FileInf2 <- file.info(File)
    if (is.na(FileInf2$size)) {
      warning("Did not create file ", File,
              ";  nothing to give to a browser.")
    } else {
      if (FileInf2$size <= 0) {
        warning("0 bytes in file ", File,
                ";  nothing to give to a browser.")
      } else {
        browseURL(File)
      }
    }
  }
  invisible(File)
}

