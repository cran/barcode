\name{barcode}
\alias{barcode}
\alias{barcode.panel}
\title{Barcode plots}
\description{
Produce barcode plot(s) of the given (grouped) values.
}
\usage{
barcode(x, outer.margins = list(bottom = unit(2, "lines"),
                                left = unit(2, "lines"), 
                                top = unit(2, "lines"), 
                                right = unit(2, "lines")), 
        horizontal = TRUE, xlim = NULL, nint = 0, main = "", xlab = "", 
        labelloc = TRUE, axisloc = TRUE, labelouter = FALSE, 
        newpage = TRUE, fontsize = 9, ptsize = unit(0.25, "char"), 
        ptpch = 1, bcspace = NULL, use.points = FALSE, buffer = 0.02,
        log = FALSE, outerbox = TRUE)

barcode.panel(x, horizontal = TRUE, xlim = NULL, labelloc = TRUE, axisloc = TRUE, 
              labelouter = FALSE, nint = 0, fontsize = 9, 
              ptsize = unit(0.25, "char"), ptpch = 1, bcspace = NULL, 
              xlab = "", xlaboffset = unit(2.5, "lines"), 
              use.points = FALSE, buffer = 0.02, log = FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{a vector of values for which the barcode is desired, or a list of such vectors for ``side-by-side" barcodes. Matrices are coerced to data frames and treated as lists \code{NA}'s are allowed in the data.}
  \item{outer.margins}{a list of length 4 with units as components named bottom, left, top, and right, giving the outer margins. Defaults to two lines of text.}
  \item{horizontal}{logical indicating the barcode orientation; the default, \code{TRUE}, produces horizontal barcodes.}
  \item{xlim}{the \code{x} limits \code{(xmin, xmax)} of the plot; the default, \code{NULL}, uses the range of the full data, \code{range(unlist(x))}, plus the multiplicative \code{buffer}.}
  \item{nint}{default, 0, uses no ``binning''--- i.e., the barcode presents the exact measurements, to the precision of the data set; \code{nint=100} uses roughly 100 ``bins'' in constructing the barcode; fewer bins give a more histogram-like plot.}
  \item{main}{the plot title.}
  \item{xlab}{the axis label for the quantitative measurements.}
  \item{labelloc}{for the location of the factor labels of the barcodes; default \code{TRUE} may also be specified as \code{'left'} or \code{'top'} (having similar results but relating to the horizontal alignment); values \code{'right'} or \code{'bottom'} are available as alternatives to \code{FALSE}.}
  \item{axisloc}{for the location of the quantitative axis labels; default, \code{TRUE}, may also be specified as \code{'left'} or \code{'top'} (having similar results but relating to the horizontal alignment); values \code{'right'} or \code{'bottom'} are available as alternatives to \code{FALSE}.}
  \item{labelouter}{default, \code{FALSE}, positions all labels within the viewport; \code{TRUE} forces the barcodes to the edge of the viewport, with the labels outside the viewport. May be of use to advanced users.}
  \item{newpage}{default, \code{TRUE}, creates the barcodes in a new graphics device instead of adding the plot to the current viewport.}
  \item{fontsize}{for the size of the axis and factor labels.}
  \item{ptsize}{for the size of the plotted points.}
  \item{ptpch}{for the type of plotted points.}
  \item{bcspace}{indicates the proportion of total available space occupied by the barcode part of the displays. Can range from 0 to 1; reasonable values seem to be between 0.1 and 0.5.}
  \item{use.points}{default FALSE uses segments instead of points in the histogram-style
display.}
  \item{xlaboffset}{used for tuning the position of the label of the quantitative variable; needs to be a \code{unit}.}
  \item{buffer}{an additional proportion of empty space added to the right and left of the barcode, to avoid having the maximum and minimum on the frame of the plot.}
  \item{log}{if \code{TRUE}, use the log scale for the y-axis of the histogram-like part of the barcodes.}
  \item{outerbox}{if \code{TRUE}, plot a box around the display.}
}
\details{
The barcode plot aids in comparing distributions. It shares some of the characteristics of side-by-side histograms or boxplots, and of rugs or stripplots. We have found it particularly useful with clumped data, when other methods obscure detail.
}
\references{Chambers, J. M. and Hastie, T. J. (1992) \emph{Statistical Models in S}. Wadsworth \& Brooks/Cole.}
\author{John W. Emerson and Walton A. Green and John A. Hartigan}
\note{John Hartigan designed and implemented an early version of the barcode plot. The implementation provided here uses \code{grid} graphics, adds some useful options, and is better suited for general distribution.}
\seealso{\code{\link[YaleToolkit]{YaleToolkit}}, \code{\link[gpairs]{gpairs}}, \code{\link{rug}}, \code{\link{stripplot}}}
\examples{
# Simulate some data:
x <- list(Rounded.2=round(rnorm(500, 2, 1),2),
          SmallerLevel=c(rnorm(100), rnorm(100,4,1)),
          LargerBivariateRounded.4=round(c(rnorm(500), rnorm(500,3,1)),4))

barcode(x)
barcode(x, main="Different orientatation", horizontal=FALSE)

data(NewHavenResidential)
barcode(split(NewHavenResidential$dep, NewHavenResidential$zone),
        xlab="Percent Depreciation", 
        main=paste("New Haven Residential Depreciation by Residential Zone",
             "RS = Single Family, RM = Mixed Residential", sep = "\n"))

}
\keyword{multivariate}% __ONLY ONE__ keyword per line
