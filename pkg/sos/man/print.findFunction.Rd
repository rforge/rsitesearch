\name{print.findFunction}
\alias{print.findFunction}
\title{
  print a findFunction object
}
\description{
  Print a \code{findFunction} object to a file and pass it to a web
  browser
}
\usage{
\method{print}{findFunction}(x, file, title, openBrowser = TRUE,
	template, ...)
}
\arguments{
  \item{x}{
    An object of class \code{findFunction}
  }
  \item{file}{
    An optional name for the HTML file to be created and then passed to
    a web browser
  }
  \item{title}{
    An optional title to give the HTML file. Default is to use the
    original query string.
  }
  \item{openBrowser}{
    logical; if \code{TRUE} then launch default browser after building
    table.
  }
  \item{template}{
    Template file used by \code{brew}
  }
  \item{\dots}{ignored}
}
%\details{ more later}
\value{
  The full path and name of the file created is returned invisibly.
}
\author{
  Sundar Dorai-Raj, Spencer Graves, Romain Francois, Uwe Ligges
}
\seealso{
  \code{\link{findFunction}},
  \code{\link[utils]{RSiteSearch}},
  \code{\link[utils]{browseURL}}
  \code{\link[brew]{brew}}
}
\examples{
  splineSearch <- findFunction("spline", maxPages = 2)
  splineSearch
}
\keyword{print}
\keyword{methods}

