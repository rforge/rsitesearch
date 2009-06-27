\name{summary.RSiteSearch}
\alias{summary.RSiteSearch}
\title{Summary Method for RSiteSearch}
\description{Summary Method for RSiteSearch}
\usage{
\method{summary}{RSiteSearch}(object, threshold = 1, ...)
}
\arguments{
  \item{object}{An object of class \code{RSiteSearch}}
  \item{threshold}{
    The minimum number of hits for a package to print. Default of 1
    shows all packages.
  }
  \item{\dots}{ignored}
}
\details{
  1.  Identify all packages with at least \code{threshold} hits.

  2.  Return an object of class c('summary.RSiteSearch', 'list') with
  summary information.
}
\value{
  An object of class c('summary.RSiteSearch', 'list') with the following
  elements:

  \item{PackageSummary}{
    a data.frame with one row for each package and columns
    \code{Package}, \code{Count}, \code{MaxScore}, \code{TotalScore},
    and \code{Date}. This summary is sorted per the \code{sort.}
    argument in the call to \code{RSiteSearch.function}.
  }
  \item{threshold}{
    the \code{threshold} argument in this call to
    \code{summary.RSiteSearch}.
  }
  \item{hits}{
    the total number of hits returned by \code{RSiteSearch}.  This is
    an attribute of an \code{RSiteSearch} object;  the number of rows
    of \code{object} will either be \code{hits} or
    maxPages*matchesPerPage, whichever is smaller.
  }
  \item{nrow}{
    the number if hits actually returned by
    \code{RSiteSearch.function}.
  }
  \item{call}{
    the matched call to \code{RSiteSearch.function}.
  }
}
\author{
  Spencer Graves
}
\seealso{
  \code{\link{RSiteSearch.function}},
  \code{\link[utils]{RSiteSearch}}
}
\examples{
  z <- RSiteSearch.function("spline", maxPages = 2)
  summary(z, 2)
}
\keyword{methods}
\keyword{print}
