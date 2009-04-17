HTML <- function(x, ...) {
  UseMethod("HTML")
}

HTML.RSiteSearch <- function(x, file, title, openBrowser = TRUE, ...) {
  .cat <- function(...)
    cat(..., "\n", sep = "", file = con, append = TRUE)
  ocall <- attr(x, "call")
  string <- eval(ocall$string)
  if(missing(file))
    file <- sprintf("%s.html", paste(string, collapse = "_"))
  File <- file
  if(missing(title))
    title <- string
  Dir <- dirname(File)
  {
    if(Dir=='.'){
      Dir <- getwd()
      File <- file.path(Dir, File)
    }
    else {
      dc0 <- dir.create(Dir, FALSE, TRUE)
    }
  }
  con <- file(File, "wt")
  on.exit(close(con))
  js <- system.file("js/sorttable.js", package = "RSiteSearch")
  if(!file.exists(js)) {
    warning("Unable to locate 'sorttable.js' file")
  } else {
#    file.copy(js, Dir)
    file.copy(js, File)
  }
  cat("<html>", file = con)
  .cat("<head>")
  .cat("<title>", title, "</title>")
  .cat("<script src=sorttable.js type='text/javascript'></script>")
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
  .cat("<h1>RSiteSearch Results</h1>\n")
  .cat("<h2>call: <font color='#800'>",
       paste(deparse(ocall), collapse = ""), "</font></h2>\n")
  .cat("<table class='sortable'>\n<thead>")
  link <- as.character(x$Link)
  desc <- gsub("(^[ ]+)|([ ]+$)", "", as.character(x$Description))
  x$Link <- sprintf("<a href='%s' target='_blank'>%s</a>", link, desc)
  x$Description <- NULL
# change "Link" to "Description and Link"
  ilk <- which(names(x)=='Link')
  names(x)[ilk] <- "Description and Link"
#
  .cat("<tr>\n  <th style='width:40px'>Id</th>")
  .cat(sprintf("  <th>%s</th>\n</tr>", paste(names(x), collapse = "</th>\n  <th>")))
  .cat("</thead>\n<tbody>")
  paste.list <- c(list(row.names(x)), lapply(x, as.character), sep = "</td>\n  <td>")
  tbody.list <- do.call("paste", paste.list)
  tbody <- sprintf("<tr>\n  <td>%s</td>\n</tr>", tbody.list)
  tbody <- sub("<td><a", "<td class=link><a", tbody)
  .cat(tbody)
  .cat("</tbody>
</table>
</body>
</html>")
  browseURL(File)
  invisible(File)
}
