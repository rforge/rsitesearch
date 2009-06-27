\name{RSiteSearch.function}
\alias{RSiteSearch.function}
\title{Fast RSiteSearch}
\description{
  Returns a data.frame from
  \code{\link[utils]{RSiteSearch}(string, "function")} which can be
  sorted and subsetted by user specifications and viewed in an HTML
  table.
}
\usage{
RSiteSearch.function(string, maxPages = 10, sort.=NULL,
                     quiet = FALSE, ...)
}
\arguments{
  \item{string}{A character string. See
    \code{\link[utils]{RSiteSearch}}.}
  \item{maxPages}{The maximum number of pages to download assuming 20
    links per page.}
  \item{sort.}{
    a character vector specifying how the \code{data.frame} returned
    should be sorted.  Default = c('Count', 'MaxScore', 'TotalScore',
    'Package', 'Score', 'Function') to sort descending on numerics and
    ascending on alphnumerics.  Specifying sort. = c('c', 't', 'm')
    is equivalent to c('Count', 'TotalScore', 'MaxScore', 'Package',
    'Score', 'Function').
  }
  \item{quiet}{
    logical; if \code{TRUE} no output is printed to the console.  The
    default \code{FALSE} displays a progress report with each page of
    matches.
  }
  \item{\dots}{ignored}
}
\details{
  \code{RSiteSearch.function} searchs the help pages of packages covered
  by the \code{RSiteSearch} archives.  To restrict the search to only
  packages installed locally, use \code{help.search}.

  1.  Access the \code{RSitSearch} engine with \code{string},
  restricting to "functions", storing \code{Score}, \code{Package},
  \code{Function}, \code{Date}, \code{Description}, and \code{Link} in a
  \code{data.frame}.

  2.  Compute \code{Count}, \code{MaxScore} and \code{TotalScore} for
  each \code{Package} accessed.  Combine them in a matrix
  \code{PackageSummary}.

  3.  Sort \code{PackageSummary} in the order defined by the occurrance
  of c('Count', 'MaxScore', 'TotalScore', 'Package') in \code{sort.}.

  4.  Merge \code{PackageSummary} with the \code{data.frame} of search
  hits.

  5.  Sort the combined \code{data.frame} as defined by \code{sort.}.

  6.  Make the result have class c("RSiteSearch", "data.frame") and add
  attributes \code{hits}, \code{summary}, and \code{call}.

  7.  Done.
}
\value{
  an object with class c('RSiteSearch', 'data.frame') with columns and
  attributes as follows:

  \item{Columns}{

    \itemize{
      \item{Count}{Total number of hits downloaded in this package}
      \item{MaxScore}{
	maximum of the \code{Score} over all help pages selected within
	each \code{Package}.  See \code{Score} below or the Namazu
	website (link below) for more information on how the score is
	determined.
      }
      \item{TotalScore}{
	sum of the \code{Score} over all help pages selected within
	each \code{Package}.  See \code{Score} below or the Namazu
	website (link below) for more information on how the score is
	determined.
      }
      \item{Package}{
	Name of the package containing a help page meeting the search
	criteria
      }
      \item{Function}{
	Name of the help page found that meets the indicated search
	criterion.
      }
      \item{Date}{Date of the help page}
      \item{Score}{
	Score returned by \code{RSiteSearch}, discussed in the Namazu
	website (link below).
      }
      \item{Description}{Title of the help page}
      \item{Link}{Universal Resource Locator (URL) for the help page}
    }
  }

  \item{Attributes}{

    \itemize{
      \item{hits}{
	an integer = total number of hits found by the search
      }
      \item{PackageSummary}{
	a data.frame with one row for each package and columns
	\code{Package}, \code{Count}, \code{MaxScore}, \code{TotalScore},
	and \code{Date}, sorted as in the \code{sort.} argument.
      }
      \item{string}{
	the \code{string} argument in the \code{call}.
      }
      \item{call}{the matched call}
    }
  }
}
\author{
  Spencer Graves and Sundar Dorai-Raj
}
\seealso{
  \code{\link[base]{help.search}} to search only installed packages.
  \code{\link[utils]{RSiteSearch}},
  \code{\link[utils]{download.file}}
  \url{http://finzi.psych.upenn.edu/search.html} for a web interface to
  this same search capability with more general options.  This function
  searches only "Target:  Functions" from that site, ignoring the R-help
  arcihves.

  \url{http://www.r-project.org/search.html} for a list of alternative R
  search capabilities, each of which may be best for different types of
  inquiries.
}
\references{
  \url{http://www.namazu.org/doc/tips.html.en#weight} - reference on
  determining \code{Score}
}
\examples{
  z <- RSiteSearch.function("spline", maxPages = 2)
  str(z)
# To search for 2 terms, not necessarily together:
  RSS <- RSiteSearch.function('RSiteSearch function', 1)
  str(RSS)
# To search for an exact string, use braces:
  RSS. <- RSiteSearch.function('{RSiteSearch function}', 1)
}
\keyword{misc}
