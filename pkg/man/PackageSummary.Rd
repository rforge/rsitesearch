\name{PackageSummary}
\alias{PackageSummary}
\title{Summarize RSiteSearch Results by Package}
\description{
  Returns a matrix with one row for each package and columns Count =
  number of rows in the search results for that package, maxSc and totSc
  = max and total score for help pages found from that package.
}
\usage{
PackageSummary(x)
}
\arguments{
  \item{x}{
    a data.frame with columns \code{Package} and \code{Score}.
  }
}
%\details{}
\value{
  a matrix with one row for each Package identified in the search and
  columns for \code{Count}, \code{MaxScore}, \code{TotalScore}, with
  \code{rownames} = the names of the Packages, sorted as in the
  \code{sort} argument.
}
\seealso{
  \code{\link[utils]{RSiteSearch}},
  \code{\link{RSiteSearch.function}}
}
\examples{
tstdf <- data.frame(Package=letters[c(1,1,2)], Score=2:4)
tstSum <- cbind(Count=c(a=2, b=1), MaxScore=c(3, 4),
                TotalScore=c(5, 4))
\dontshow{stopifnot(}
all.equal(PackageSummary(tstdf), tstSum)
\dontshow{)}
}
\keyword{misc}
