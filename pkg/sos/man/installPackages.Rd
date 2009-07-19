\name{install.packages}
\alias{install.packages}
\alias{install.packages.default}
\alias{install.packages.findFn}
\title{
  install packages with minimum count
}
\description{
  \code{install.packages} identifed in a \code{findFn} object with
  \code{Count} exceeding \code{minCount}.  (The present package makes
  \code{install.packages} a generic function with the default method
  referring to \code{\link[utils]{install.packages}}.)
}
\usage{
%install.packages(x, ...)
\method{install.packages}{default}(x, ...)
\method{install.packages}{findFn}(x, minCount=sqrt(x[['Count']][1]), ...)
}
\arguments{
  \item{x}{
    either a character vector to be passed to
    \code{utils:::install.package} of a \code{findFn} object
  }
  \item{minCount}{
    Install all packages identified in \code{x[['Packages']]} with
    \code{x[['Count']]} exceeding \code{minCount}.
  }
  \item{\dots}{
    optional arguments passed to other methods; see
    \code{\link[utils]{install.packages}}
  }
}
\details{
  This is useful to prepare for \code{PackageSum2}.
}
\value{
  none
}
\author{
  Spencer Graves
}
\seealso{
  \code{\link[utils]{install.packages}}
  \code{\link{PackageSum2}}
}
%\references{
%  Robert Ferstl and Josef Hayden (2008) "Zero-Coupon Yield Curve
%  Estimation with the Package \code{termstrc}";  available from
%  \url{http://papers.ssrn.com/sol3/papers.cfm?abstract_id=1307149},
%  especially expression (9), sec. 3, p. 7, accessed 2009.05.09.
%}
\examples{
\dontrun{
spl <- findFn("spline", maxPages = 2)
# install all the most frequently cited packages
install.packages(spl)

# install ALL packages found
install.packages(spl, 1)
}

}
\keyword{models}
