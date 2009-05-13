\name{unionRSiteSearch}
\alias{unionRSiteSearch}
\alias{intersectRSiteSearch}
\alias{Ops.RSiteSearch}
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

\S3method{Ops}{RSiteSearch}(e1,e2)
# This supports "|" for "unionRSiteSearch"
# and "&" for "intersectRSiteSearch".
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
  \item{e1, e2}{
	  objects of class \code{RSiteSearch}.
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
\note{
	Binary operators \samp{&} and \samp{|} are implemented
	for the S3 class \samp{RSiteSearch}
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

# or the sorter version:
de.s <- des1 | de1

# Keep only the common entries.
de2 <- intersectRSiteSearch(des1, de1)
de2 <- des1 & de1

# summary and HTML still work with the combined object.
summary(de.s)
HTML(de.s)

summary(de2)
HTML(de2)

\dontshow{
# The following gave an error;  now fixed 2009.05.12
x <- RSiteSearch.function("spline", maxPages = 1, quiet = TRUE)
y <- RSiteSearch.function("winbugs", maxPages = 1, quiet = TRUE)
intersectRSiteSearch( x, y )
}

}
\keyword{misc}
