\name{writeFindFn2xls}
\alias{writeFindFn2xls}
\title{
  Write a findFn object to an Excel file
}
\description{
  Write a \code{findFn} object to an Excel file with sheets for
  \code{\link{PackageSum2}}, the \code{findFn} table, and the
  \code{call} attribute of the \code{findFn} object.
}
\usage{
writeFindFn2xls(x, file.=paste(deparse(substitute(x)), 'xls', sep='.'))
}
\arguments{
  \item{x}{
    An object of class \code{findFn}
  }
  \item{file.}{
    Name of Excel file to create.
  }
}
\details{
  Uses \code{library(RODBC)} and only works under Windows.
}
\value{
  The name of the file created is returned invisibly.
}
\author{
  Spencer Graves
}
\seealso{
  \code{\link{findFn}},
  \code{\link[RODBC]{odbcConnectExcel}},
  \code{\link[RODBC]{sqlSave}},
  \code{\link[RODBC]{odbcClose}}
}
\examples{
splineSearch <- findFn("spline", maxPages = 1)

if(.Platform$OS.type=="windows")writeFindFn2xls(splineSearch)

}
\keyword{print}

