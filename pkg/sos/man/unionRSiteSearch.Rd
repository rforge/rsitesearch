\name{unionFindFunction}
\alias{unionFindFunction}
\alias{intersectFindFunction}
\alias{Ops.findFunction}
\title{
  Combine findFunction Objects
}
\description{
  Combines to \code{findFunction} objects into a new \code{findFunction}
  object with only one row for any help page duplicated between the
  two.  \code{unionFindFunction} removes duplicate entries.
  \code{intersectFindFunction} keeps only the duplicates.
}
\usage{
unionFindFunction(e1, e2, sortby=NULL)
intersectFindFunction(e1, e2, sortby=NULL)

\S3method{Ops}{findFunction}(e1,e2)
# This supports "|" for "unionFindFunction"
# and "&" for "intersectFindFunction".
}
\arguments{
  \item{e1, e2}{
    objects of class \code{findFunction}.
  }
  \item{sortby}{
    Optional \code{sortby} argument used by \code{sortFindFunction} and
    \code{findFunction}.  Default is the \code{sortby} argument
    in \code{attr(x, 'call')}.
  }
}
\details{
  1.  e12 <- rbind(e1, e2)

  2.  For any (\code{Package}, \code{Function}) appearing in both
  \code{e1} and \code{e2}, the row with the largest \code{Score} is
  retained and the other is deleted.

  3.  Apply \code{sortFindFunction} to the rebuild the summary and sort
  the result as desired.

  4.  attr(e12, 'matches') <- c(attr(e1, 'matches'), attr(e2,
  'matches'))
}
\note{
  Binary operators \samp{&} and \samp{|} are implemented for the S3
  class \samp{findFunction}
}
\value{
  an object with class c('findFunction', 'data.frame') as returned by
  \code{sortFindFunction} and \code{findFunction}.
}
\author{
  Spencer Graves and Romain Francois
}
\seealso{
  \code{\link{findFunction}}
  \code{\link{sortFindFunction}}
}
%\references{}
\examples{
des1 <- findFunction('differential equations', 1)
de1 <- findFunction('differential equation', 1)
# each retrieves 1 page of 20 hits
# but not the same 20

de.s <- unionFindFunction(des1, de1)
# combines the two, eliminating duplicates.

# or the sorter version:
de.s. <- des1 | de1
\dontshow{stopifnot(}
all.equal(de.s, de.s.)
\dontshow{)}

# Keep only the common entries.
de2 <- intersectFindFunction(des1, de1)
de2. <- des1 & de1
\dontshow{stopifnot(}
all.equal(de2, de2.)
\dontshow{)}

# summary and print still work with the combined object.
summary(de.s)
de.s

summary(de2)
de2

\dontshow{
# The following gave an error;  now fixed 2009.05.12
x <- findFunction("spline", maxPages = 1, quiet = TRUE)
y <- findFunction("winbugs", maxPages = 1, quiet = TRUE)
intersectFindFunction( x, y )
}

}
\keyword{misc}
