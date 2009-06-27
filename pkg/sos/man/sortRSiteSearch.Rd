\name{sortRSiteSearch}
\alias{sortRSiteSearch}
\title{Sort an RSiteSearch Object}
\description{
  Sort a data.frame as an RSiteSearch object.
}
\usage{
sortRSiteSearch(x, sort.=NULL)
}
\arguments{
  \item{x}{
    a data.frame to sort and convert to an object of class
    \code{RSiteSearch} (if it does not alreay have this class).
  }
  \item{sort.}{
    sort information as for function \code{RSiteSearch.function}.
  }
}
\details{
  1.  pkgSum <- PackageSummary(x, sort.)

  2.  Order x as required for \code{RSiteSearch.function}

  3.  class = c("RSiteSearch", "data.frame")
}
\value{
  An object of class c('RSiteSearch', 'data.frame') with a
  "PackageSummary" attribute.
}
\author{Spencer Graves}
\seealso{
  \code{\link{RSiteSearch.function}}
  \code{\link{sort}}
  \code{\link{order}}
}
\examples{
tstdf <- data.frame(Package=letters[c(1,1,2)],
                    Function=c('a1', 'a2', 'b3'), Score=2:4,
                    Date=11:13, Description=c('D1', 'D2', 'D3'),
                    Link=c('L1', 'L2', 'L3'), stringsAsFactors=FALSE)
rss <- sortRSiteSearch(tstdf)
}
\keyword{methods}
\keyword{print}
