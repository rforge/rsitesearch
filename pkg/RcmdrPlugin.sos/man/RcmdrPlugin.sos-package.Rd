\name{RcmdrPlugin.sos-package}
\alias{RcmdrPlugin.sos-package}
%\alias{}
\docType{package}
\title{
Efficiently search R Help pages
}
\description{
Rcmdr interface to sos 
}
% Please put two spaces after the end of a sentence in sections with
% running text (\description, \details, ...).
\details{
The plug-in attempts to render the sos searching functionality readily 
accessible for casual use.  It allows to perform simple searches 
(\code{\link[sos]{findFn}}) and more advanced operations such as 
filtering the search results (\code{\link[sos]{grepFn}}) or combining 
the results of multiple searches (\code{\link[sos]{unionFindFn}}, 
\code{\link[sos]{intersectFindFn}}). 

For a good overview of the \code{sos} package see 
\code{vignette("sos", package="sos")}. 
}

\author{
  Liviu Andronic \email{landronimirc@gmail.com}
}
\keyword{ package }
%\references{
%}
\seealso{
\code{\link[Rcmdr]{Rcmdr}}, 
\code{\link[sos]{findFn}},
\code{\link[sos]{grepFn}},
\code{\link[sos]{unionFindFn}},
}

\examples{
\dontrun{
   ## start R
   library(RcmdrPlugin.sos)  ## loads Rcmdr and the plug-in
}
}
