\name{hits}
\alias{hits}
\title{
  hits attribute of an RSiteSearch object
}
\description{
  Returns the \code{hits} attribute of an \code{RSiteSearch} object.
  For the output of \code{RSiteSearch.function}, this is the number of
  matches for the search term.  For an \code{RSiteSearch} object
  returned by \code{unionRSiteSearch} or \code{intersectRSiteSearch},
  this is a numeric vector if the \code{hits} attributes of the
  arguments to \code{unionRSiteSearch} or \code{intersectRSiteSearch}.
}
\usage{
hits(x)
}
\arguments{
  \item{x}{
    object of class \code{RSiteSearch}.
  }
}
\details{
  attr(x, 'hits')
}
\value{
  an integer vector
}
\author{Spencer Graves}
\seealso{
  \code{\link{RSiteSearch.function}}
  \code{\link{unionRSiteSearch}}
  \code{\link{intersectRSiteSearch}}
}
%\references{}
\examples{
des1 <- RSiteSearch.function('differential equations', 1)
\dontshow{stopifnot(}
all.equal(hits(des1), attr(des1, 'hits'))
\dontshow{)}
}
\keyword{misc}
