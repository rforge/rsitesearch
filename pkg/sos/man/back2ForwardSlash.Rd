\name{back2ForwardSlash}
\alias{back2ForwardSlash}
\title{
  Replace backslash with forward slash in a character string
}
\description{
  scan a character string with backslash as the quote character and
  return it with backslashs replaced by forward slash.

  NOTE:  'c:\\User' cannot be assigned to a character variable, because
  '\\U' must be followed by a hexidecimal number, and 's' is not a legal
  hexidecimal digit.  Therefore, we read the character string of
  interest using scan rather than assigning it to a function argument.
}
\usage{
back2ForwardSlash(x = readline("text to convert > "))
}
\arguments{
  \item{x}{
    character string in which each back slash is to be converted into a
    forward slash.
  }
}
\details{
  It's not easy to turn a back slash into a forward slash, because R
  interprets the back slash as an escape character.
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

(x <- back2ForwardSlash("c:\\\\Users\\\\"))

\dontshow{stopifnot(}
all.equal(x, 'c:/Users/')
\dontshow{)}


\dontrun{
# Same again, this time from a file
fname <- system.file("tests", "example_back2ForwardSlash.txt", package = "sos")
lines <- readLines(fname)
(x3 <- back2ForwardSlash(lines))

\dontshow{stopifnot(}
all.equal(x3, c('c:/Users/', 'c:/u/a b/c d'))
\dontshow{)}
}
}
\keyword{manip}
