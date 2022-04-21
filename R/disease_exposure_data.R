#' @title Sample Disease-Exposure Data
#'
#' @description A simple example of a \code{data.frame} of disease-exposure data that could be used with this package and is used in examples
#'
#' @format A \code{data.frame} with 5 columns and 500 rows:
#' \describe{
#' \item{id}{integer of the row id, could be thought of as the person id}
#' \item{disease}{character column specifying the disease status, with "No" equal to not diseased and "Yes" equal to diseased}
#' \item{exposure1}{binary column specifying if the person has/had the exposure (1) or not (0)}
#' \item{exposure2}{character column specifying if the person has/had the exposure ("Yes") or not ("No")}
#' \item{exposure3}{character column specifying which category of an exposure the person falls into (are they a child, office worker, shop worker, etc.)}
#' }
"disease_exposure_data"
