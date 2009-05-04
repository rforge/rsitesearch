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
  a data.frame with one row for each package and columns \code{Package},
  \code{Count}, \code{MaxScore}, \code{TotalScore}, and \code{Date}.
}
\seealso{
  \code{\link[utils]{RSiteSearch}},
  \code{\link{RSiteSearch.function}}
}
\examples{
tstdf <- data.frame(Package=letters[c(1,1,2)], Score=2:4,
                    Date=LETTERS[1:3], stringsAsFactors=FALSE)
tstSum <- PackageSummary(tstdf)
# The answer:
tstSm <- data.frame(Package=letters[1:2], Count=c(a=2, b=1),
            MaxScore=c(3, 4), TotalScore=c(5, 4),
            Date=LETTERS[c(1, 3)], stringsAsFactors=FALSE)
row.names(tstSm) <- 1:2
\dontshow{stopifnot(}
all.equal(tstSum, tstSm)
\dontshow{)}
}
\keyword{misc}
