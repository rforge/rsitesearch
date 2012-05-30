\name{back2forwardslash}
\alias{back2forwardslash}
\title{
  Replace backslash with forward slash in a character string
}
\description{
  scan a character string with backslash as the quote character and
  return it with backslashs replaced by forward slash.

  NOTE:  'c:\User' cannot be assigned to a character variable, because
  '\U' must be followed by a hexidecimal number, and 's' is not a legal
  hexidecimal digit.  Therefore, we read the character string of
  interest using scan rather than assigning it to a function argument.
}
\usage{
back2forwardslash(nmax=1, pattern='\\\\', replacement='/')
}
\arguments{
  \item{nmax}{
    nmax argument for scan:  defaults to scanning one line of text
    only.
  }
  \item{pattern, replacement}{
    arguments passed to gsub
  }
}
\details{
  x <- scan(what=character(), quote=pattern, nmax=nmax)
  gsub(pattern, replacement, x, fixed=TRUE)
}
\value{
  character vector with backslashes replaced by forward slashes.
}
\author{
  Spencer Graves
}
\seealso{
  \code{\link{scan}}
  \code{\link{gsub}}
  \code{\link{Quotes}}
}
%\references{}
\examples{
x <- back2forwardslash()
c:\\Users\\
#NOTE:  This function works with this string,
# but R CMD check thinks \U is a control sequence
#    that should be followed by a hexidecimal number and isn't.

\dontshow{stopifnot(}
all.equal(x, 'c:/Users/')
\dontshow{)}

# nmax must be one more than the number of embedded blanks
x3 <- back2forwardslash(3)
c:\\u\\a b\\c d

\dontshow{stopifnot(}
all.equal(x3, 'c:/u/a b/c d')
\dontshow{)}

}
\keyword{manip}
