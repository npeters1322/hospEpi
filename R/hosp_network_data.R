#' @title Sample Location History/Hospital Network Data
#'
#' @description A simple example of a \code{data.frame} of location history data that could be used with this package and is used in examples
#'
#' @format A \code{data.frame} with 5 columns and 16 rows:
#' \describe{
#' \item{UniqueEncountID}{integer of a unique id for each patient encounter}
#' \item{BeginDate}{character column specifying the start date and time for that encounter}
#' \item{EndDate}{character column specifying the end date and time for that encounter}
#' \item{UnitName}{character column specifying the unit name the patient was in during that encounter}
#' \item{RoomNumber}{character column specifying the room number the patient was in during that encounter}
#' }
"hosp_network_data"
