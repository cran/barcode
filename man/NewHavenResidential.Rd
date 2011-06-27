\name{NewHavenResidential}
\alias{NewHavenResidential}
\docType{data}
\title{New Haven, CT Residential Property Data}
\description{
  Selected characteristics of a set of small residential
properties in New Haven, CT (excluding larger multi-family
properties and apartment buildings).
}
\usage{data(NewHavenResidential)}
\format{
  A data frame with 18221 observations on the following 8 variables.
  \describe{
    \item{\code{totalCurrVal}}{the 2006 assessed value of the property}
    \item{\code{livingArea}}{the living area in square feet}
    \item{\code{dep}}{the amount of depreciation, as a percent}
    \item{\code{size}}{the size of the land, in acres}
    \item{\code{zone}}{the residential zone, a factor with levels \code{Other} \code{RM} \code{RS}}
    \item{\code{acType}}{whether the property has central air conditioning: a factor with levels \code{AC} \code{No AC}}
    \item{\code{bedrms}}{the number of bedrooms}
    \item{\code{bathrms}}{the number of bathrooms}
  }
}
\details{
  The data have been cleaned somewhat, with emphasis on somewhat.  For example,there is a property (a very nice one), which has an extremely low assessed value, given its characteristics.  It happens to straddle the border between New Haven and Hamden, and so it pays only a proportion of it's property taxes to the City of New Haven.
}
\source{
John W. Emerson, from the City of New Haven's property database, which contains more than 27,000 property records (including, for example, the New Haven Airport) and many more variables than included here.
}
\examples{

# This example is excluded from running automatically in the checks
# because it takes a little while to produce.

\dontrun{
  data(NewHavenResidential)
  gpairs(NewHavenResidential)
}

}
\keyword{datasets}
