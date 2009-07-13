\name{grepFn}
\alias{grepFn}
\title{
  Find a function matching a pattern in a findFn object
}
\description{
  Search for \code{pattern} in the \code{Function} column of a
  \code{findFn} object.
}
\usage{
grepFn(pattern, x, ignore.case=FALSE, extended=TRUE,
       perl=FALSE, value=TRUE, fixed=FALSE, useBytes=FALSE,
       invert=FALSE)
}
\arguments{
  \item{x}{
    an object of class \code{findFn}
  }
  \item{pattern, ignore.case, extended, perl, fixed, useBytes, invert}{
    as for \code{grep}
  }
  \item{value}{
    logical:  If TRUE, return the selected subset of \code{x}.  If
    FALSE, return the row numbers.
  }
}
\details{
  1.  g <- grep(pattern, x[['Function']]

  2.  if(value)return(x[g, ]) else return(g)
}
\value{
  If(value) return an object of class \code{findFn} being a subset of
  the rows of \code{x} with column \code{Function} matching
  \code{pattern}.

  Else, return an integer vector identifying the rows of \code{x} with
  column \code{Function} matching \code{pattern}.
}
\author{
  Spencer Graves, Sundar Dorai-Raj
}
\seealso{
  \code{\link{findFn}}
  \code{\link[base]{grep}}
}
%\references{}
\examples{
z <- findFn("spline", maxPages = 2)
z. <- grepFn("spline", z)
}
\keyword{misc}
