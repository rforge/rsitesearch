\name{summary.findFunction}
\alias{summary.findFunction}
\alias{print.summary.findFunction}
\title{Summary Method for findFunction}
\description{
  Summary Method for objects of class \code{findFunction}
}
\usage{
\method{summary}{findFunction}(object, threshold = 1, ...)
}
\arguments{
  \item{object}{An object of class \code{findFunction}}
  \item{threshold}{
    The minimum number of matches for a package to print. Default of 1
    shows all packages.
  }
  \item{\dots}{ignored}
}
\details{
  1.  Identify all packages with at least \code{threshold} hits.

  2.  Return an object of class c('summary.findFunction', 'list') with
  summary information.
}
\value{
  An object of class c('summary.findFunction', 'list') with the following
  elements:

  \item{PackageSummary}{
    a data.frame with one row for each package and columns
    \code{Package}, \code{Count}, \code{MaxScore}, \code{TotalScore},
    and \code{Date}. This summary is sorted per the \code{sortby}
    argument in the call to \code{findFunction}.
  }
  \item{threshold}{
    the \code{threshold} argument in this call to \code{findFunction}.
  }
  \item{matches}{
    the total number of matches returned by \code{findFunction}.  This
    is an attribute of an \code{findFunction} object;  the number of
    rows of \code{object} will either be \code{matches} or
    maxPages*matchesPerPage, whichever is smaller.
  }
  \item{nrow}{
    the number if matches in this \code{findFunction} object
  }
  \item{nPackages}{
    the number of packages in this \code{findFunction} object
  }
  \item{call}{
    the matched call to \code{findFunction}.
  }
}
\author{
  Spencer Graves
}
\seealso{
  \code{\link{findFunction}},
  \code{\link[utils]{RSiteSearch}}
}
\examples{
  z <- findFunction("spline", maxPages = 2)
  summary(z, 2)
}
\keyword{methods}
\keyword{print}
