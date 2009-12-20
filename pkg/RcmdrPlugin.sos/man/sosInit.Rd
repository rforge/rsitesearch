\name{sosInit}
\alias{sosInit}
\alias{sosGrep}
\title{
    Rcmdr sos dialogues
}
\description{
    Rcmdr interface to findFn() and grepFn()
}
\usage{
    sosInit()
    sosGrep(recall=NULL, bLabel=gettextRcmdr("Filter by"), 
    eLabel=gettextRcmdr("in"), 
    initialLabel=gettextRcmdr("Filter by"))
}
\arguments{
    \item{recall}{function to call after error.}
    \item{bLabel, eLabel, initialLabel}{strings defining the label of 
      the grep button}
}
\details{
The dialogues provide the user with an interface to perform simple 
and more advanced searches of the R Help pages via the RSiteSearch
functionality. 

It is possible to perform multiple searches. One can specify up to 
9 search terms separated either by "|" (vertical bars, to obtain the 
union of results) or "&" (ampersands, to obtain the intersection). 
One may use only one type of separating operator per search. For example, 
enter in the search box \code{newey west | newey-west | neweywest} or 
\code{newey west & newey-west & neweywest}, but not 
\code{newey west | newey-west & neweywest}.  

Note that \code{findFn()} does not simply search for character strings.  
For example, \code{findFn()} may find less results for 
\code{differential equation} than for \code{differential equations}.  
In such cases you can perform multiple searches as described in the 
previous paragraph (\code{differential equation | differential equations}).  
For more on this issue see \code{vignette("sos", package="sos")}. 

Also note that \code{findFn()} performs the searches on-line, via 
Jonathan Baron's \emph{R Site Search} [1]. Depending on how generic the 
search term is (for example, \code{correlation}) and the quality of the 
internet connection, it may take from a couple of seconds up to several 
minutes to complete the search and display the results. 
}
\value{
    \code{NULL}
}
\author{Liviu Andronic \email{landronimirc@gmail.com}}
\references{
[1]  http://finzi.psych.upenn.edu/nmz.html
}
\seealso{
\code{\link[sos]{findFn}},
\code{\link[sos]{grepFn}},
\code{\link[sos]{unionFindFn}},
}
\keyword{ misc }
