\name{hits}
\alias{hits}
\alias{matches}
\title{
  matches attribute of a findFunction object
}
\description{
  Returns the \code{matches} attribute of a \code{findFunction} object.
  For the output of \code{findFunction}, this is the number of  matches
  for the search term.  For a \code{findFunction} object returned by
  \code{unionFindFunction} or \code{intersectFindFunction}, this is a
  numeric vector if the \code{matches} attributes of the arguments to
  \code{unionFindFunction} or \code{intersectFindFunction}.
}
\usage{
matches(x)
hits(x)
}
\arguments{
  \item{x}{
    object of class \code{findFunction}.
  }
}
\details{
  attr(x, 'matches')
}
\value{
  an integer vector
}
\author{Spencer Graves}
\seealso{
  \code{\link{findFunction}}
  \code{\link{unionFindFunction}}
  \code{\link{intersectFindFunction}}
}
%\references{}
\examples{
des1 <- findFunction('differential equations', 1)
\dontshow{stopifnot(}
all.equal(matches(des1), attr(des1, 'matches'))
\dontshow{)}
}
\keyword{misc}
