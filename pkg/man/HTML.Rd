\name{HTML}
\alias{HTML}
\alias{HTML.RSiteSearch}
\title{RSiteSearch HTML Tables}
\description{Create and view an HTML table from the result of calling
  \code{\link{RSiteSearch.function}}.
}
\usage{
HTML(x, ...)
\method{HTML}{RSiteSearch}(x, file, title, openBrowser = TRUE, ...)
}
\arguments{
  \item{x}{An object of class \code{RSiteSearch}}
  \item{file}{An optional file name to print the table. Default is to
    use a collapsed version of the original query string.}
  \item{title}{An optional title to give the HTML file. Default is to
    use the original query string.}
  \item{openBrowser}{logical; if \code{TRUE} then launch default browser
    after building table.}
  \item{\dots}{ignored}
}

\details{
  more later
}
\seealso{
  \code{\link{RSiteSearch.function}},
  \code{\link[utils]{RSiteSearch}},
  \code{\link[utils]{browseURL}}
}
\examples{
  splineSearch <- RSiteSearch.function("spline", maxPages = 2)
  HTML(splineSearch)
}
\keyword{print}
\keyword{methods}
