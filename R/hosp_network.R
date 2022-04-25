#' Create an Object of Class hosp_network
#'
#' @param x A \code{\link{data.frame}} containing the patient location history data
#' @param fromUnit Optional, unquoted column name from \code{x} containing the from unit data
#' @param toUnit Optional, unquoted column name from \code{x} containing the to unit data
#' @param fromRoom Optional, unquoted column name from \code{x} containing the from room data
#' @param toRoom Optional, unquoted column name from \code{x} containing the to room data
#'
#' @return An object of class hosp_network
#' @export
#'
hosp_network <- function(x, fromUnit = NULL, toUnit = NULL, fromRoom = NULL, toRoom = NULL) {

  x <- as.data.frame(x)

  from_unit <- deparse(substitute(fromUnit))

  to_unit <- deparse(substitute(toUnit))

  from_room <- deparse(substitute(fromRoom))

  to_room <- deparse(substitute(toRoom))

  new_hosp_network(x, fromUnit = from_unit, toUnit = to_unit, fromRoom = from_room, toRoom = to_room)

}
