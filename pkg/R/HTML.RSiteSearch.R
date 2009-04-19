HTML <- function(x, ...) {
  UseMethod("HTML")
}

HTML.RSiteSearch <- function( x, file, title, openBrowser = TRUE,
             template = system.file( "brew", "results.brew.html",
                                 package = "RSiteSearch" ),
                             ...){
  ocall <- attr(x, "call")
  string <- eval(ocall$string)
  if(missing(file)){
    file <- sprintf("%s.html", paste(string, collapse = "_"))
  }
  File <- file
  if(missing(title)){
    title <- string
  }
  Dir <- tools:::file_path_as_absolute( dirname(File) )
  js <- system.file("js", "sorttable.js", package = "RSiteSearch")
  if(!file.exists(js)) {
    warning("Unable to locate 'sorttable.js' file")
  } else {
    file.copy(js, Dir)
  }
  x$Description <- gsub("(^[ ]+)|([ ]+$)", "", as.character(x$Description))
  for( j in 1:ncol(x) ){
	 x[,j] <- as.character(x[,j])
  }
  brew( template,  File )
  if( openBrowser ) {
	  browseURL(File)
  }
  invisible(File)

}

