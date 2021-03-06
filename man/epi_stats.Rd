% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/epi_stats.R
\name{epi_stats}
\alias{epi_stats}
\title{Calculate Various Statistics for an Epidemiological Analysis}
\usage{
epi_stats(disease, exposure)
}
\arguments{
\item{disease}{The disease column, made up of 1s and 0s}

\item{exposure}{The exposure column, made up of 1s and 0s}
}
\value{
A \code{\link{data.frame}} with one row containing various statistics in the columns
}
\description{
Calculate various statistics common in an epidemiological analysis, such as incidence, risk ratio, odds ratio, Fisher's exact, and Chi-square, for a single disease-exposure combination
}
\section{Thanks}{

Special thanks to Josh Sadowski for providing the bones of this function, which I have added to and edited.
}

