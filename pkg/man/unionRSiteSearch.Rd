\name{unionRSiteSearch}
\alias{unionRSiteSearch}
\alias{intersectRSiteSearch}
\title{
  Combine RSiteSearch Objects
}
\description{
  Combines to \code{RSiteSearch} objects into a new RSiteSearch object
  with only one row for any help page duplicated between the two.
  \code{unionRSiteSearch} removed the duplicate entries.
  \code{intersectRSiteSearch} keeps only the duplicates.
}
\usage{
unionRSiteSearch(x, y, sort.=NULL)
intersectRSiteSearch(x, y, sort.=NULL)
}
\arguments{
  \item{x, y}{
    objects of class \code{RSiteSearch}.
  }
  \item{sort.}{
    Optional \code{sort.} argument used by \code{sortRSiteSearch} and
    \code{RSiteSearch.function}.  Default is the \code{sort.} argument
    in \code{attr(x, 'call')}.
  }
}
\details{
  1.  xy <- rbind(x, y)

  2.  For any (\code{Package}, \code{Function}) appearing in both
  \code{x} and \code{y}, the row with the largest \code{Score} is
  retained and the other is deleted.

  3.  Apply \code{sortRSiteSearch} to the rebuild the summary and sort
  the result as desired.

  4.  attr(xy, 'hits') <- c(attr(x, 'hits'), attr(y, 'hits'))
}
\value{
  an object with class c('RSiteSearch', 'data.frame') as returned by
  \code{sortRSiteSearch} and \code{RSiteSearch.function}.
}
\seealso{
  \code{\link{RSiteSearch.function}}
  \code{\link{sortRSiteSearch}}
}
%\references{}
\examples{
des1 <- RSiteSearch.function('differential equations', 1)
de1 <- RSiteSearch.function('differential equation', 1)
# each retrieves 1 page of 20 hits
# but not the same 20

de.s <- unionRSiteSearch(des1, de1)
# combines the two, eliminating duplicates.

# Keep only the common entries.
de2 <- intersectRSiteSearch(des1, de1)

# summary and HTML still work with the combined object.
summary(de.s)
HTML(de.s)

summary(de2)
HTML(de2)
}
\keyword{misc}
