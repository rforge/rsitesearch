\name{PackageSum2}
\alias{PackageSum2}
\alias{PackageSum2.RSiteSearch}
\alias{PackageSum2.data.frame}
\alias{PackageSum2.list}
\title{
  Add Info from Installed Packages to PackageSummary
}
\description{
  Add information on installed packages to the \code{PackageSummary} of
  an \code{RSiteSearch} object.
}
\usage{
PackageSum2(x,
        fields=c("Title", "Version", "Author", "Maintainer", "Packaged"),
            lib.loc=NULL, ...)
\method{PackageSum2}{RSiteSearch}(x,
        fields=c("Title", "Version", "Author", "Maintainer", "Packaged"),
            lib.loc=NULL, ...)
\method{PackageSum2}{data.frame}(x,
        fields=c("Title", "Version", "Author", "Maintainer", "Packaged"),
            lib.loc=NULL, ...)
\method{PackageSum2}{list}(x,
        fields=c("Title", "Version", "Author", "Maintainer", "Packaged"),
            lib.loc=NULL, ...)
}
\arguments{
  \item{x}{
    a data.frame with columns \code{Package} and \code{Score}.
  }
  \item{fields}{
    character vector of names to look for in components of
    \code{packageDescription(x$Package[i])} and return as additional
    columns of \code{x} if found.

    Component 'Packaged' receives special treatment.  If present, only
    the portion preceding ';' will be retained.  This seems to be a time
    stamp automatically generated by something like \code{R CMD build}.
    It is absent for packages automatically loaded when R is started.
    In such cases, the third component of \code{strsplit(
    packageDescription( x$Package[i])$Built, ..., ';')} will be stored
    as 'Packaged'.  This seems to be a time stamp automatically
    generated by something like \code{R CMD INSTALL --build}.
  }
  \item{lib.loc}{
    an optional \code{lib.loc} argument passed to
    \code{packageDescription}.
  }
  \item{\dots}{
    additional arguments (currently unused)
  }
}
\details{
  With an object of class \code{RSiteSearch}, extract the
  \code{PackageSummary} attribute and pass it to the \code{data.frame}
  method.

  With an object of class \code{list}, extract the \code{PackageSummary}
  component and pass it to the \code{data.frame} method.

  For a \code{data.frame} that is not an \code{RSiteSearch} object, add
  other columns from \code{attributes} of \code{packageDescription} for
  installed packages named in the column \code{Package}.
}
\value{
  a data.frame with additional \code{fields} columns appended to
  \code{x}.
}
\author{Spencer Graves}
\seealso{
  \code{\link{RSiteSearch.function}}
  \code{\link{PackageSummary}}
}
\examples{
##
## data.frame method
##
tstdf <- data.frame(Package=c('fda', 'base'), stringsAsFactors=FALSE)
tst2 <- PackageSum2(tstdf)

##
## list method
##
tstList <- list(PackageSummary=tstdf)
\dontshow{stopifnot(}
all.equal(tst2, PackageSum2(tstList))
\dontshow{)}

##
## RSiteSearch method
##
tstRSearch <- data.frame(Package=c('fda', 'base')[c(1,1,2)], Score=2:4,
                    Date=LETTERS[1:3], stringsAsFactors=FALSE)
attr(tstRSearch, 'PackageSummary') <- PackageSummary(tstRSearch)
class(tstRSearch) <- c('RSiteSearch', 'data.frame')
tst2. <- PackageSum2(tstRSearch)

# row names are different from tst2, so fix ...
row.names(tst2.) <- row.names(tst2)
\dontshow{stopifnot(}
all.equal(tst2, tst2.[names(tst2)])
\dontshow{)}

}
\keyword{package}
