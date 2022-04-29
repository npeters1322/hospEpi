#' @title Helper Function to Create an Object of Class \code{hosp_network}
#'
#' @description Creates an object of class \code{hosp_network} with the data and columns provided, allowing functions for \code{hosp_network} objects to be used
#'
#' @param x A \code{\link{data.frame}} containing the patient location history data
#' @param fromUnit Optional, unquoted column name from \code{x} containing the from unit data
#' @param toUnit Optional, unquoted column name from \code{x} containing the to unit data
#' @param fromRoom Optional, unquoted column name from \code{x} containing the from room data
#' @param toRoom Optional, unquoted column name from \code{x} containing the to room data
#'
#' @return An object of class \code{hosp_network} and \code{data.frame}
#' @export
#'
#' @examples
#' hn_data <- hosp_network_data # read in example data provided in package
#'
#' cleaned_hn_data <- clean_hosp_network(data = hn_data, uniqueID = UniqueEncountID, startDate = BeginDate, endDate = EndDate, unitName = UnitName, roomNum = RoomNumber) # clean the data using specific columns in the dataset
#'
#' hn_object <- hosp_network(x = cleaned_hn_data, fromUnit = UnitName, toUnit = next_unit, fromRoom = RoomNumber, toRoom = next_room) # create an object of class hosp_network
#'
#' hn_object2 <- hosp_network(x = cleaned_hn_data, fromUnit = UnitName, toUnit = next_unit) # create an object of class hosp_network, but only with unit data
#'
#' \dontrun{
#'
#' hn_object3 <- hosp_network(x = cleaned_hn_data, fromUnit = UnitName, toUnit = next_unit, fromRoom = RoomNumber) # will throw an error because the next room is not given, but the original room is
#'
#' }
hosp_network <- function(x, fromUnit = NULL, toUnit = NULL, fromRoom = NULL, toRoom = NULL) {

  x <- as.data.frame(x)

  from_unit <- deparse(substitute(fromUnit))

  to_unit <- deparse(substitute(toUnit))

  from_room <- deparse(substitute(fromRoom))

  to_room <- deparse(substitute(toRoom))

  new_hosp_network(x, fromUnit = from_unit, toUnit = to_unit, fromRoom = from_room, toRoom = to_room)

}
