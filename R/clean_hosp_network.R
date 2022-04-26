#' @title Clean Patient Location History/Hospital Network Data
#'
#' @description To use other hospital network functions in this package, your data must have columns for: patient's first unit and patient's next unit or patient's first room and patient's next room. There might be multiple rows per patient, but each row should always have a beginning and ending room and/or unit for each encounter. This function might be able to help get your data in that format.
#'
#' @param data A \code{\link{data.frame}} containing patient location history data
#' @param uniqueID An unquoted column name for the unique identifier for each encounter or patient
#' @param startDate Unquoted column name for the column containing the start date for an encounter
#' @param endDate Unquoted column name for the column containing the end date for an encounter
#' @param unitName Optional, unquoted column name for the column containing the unit name data
#' @param roomNum Optional, unquoted column name for the column containing the room number data
#'
#' @return A \code{\link{data.frame}} containing the cleaned patient location history data
#' @export
#'
#' @importFrom rlang enquo
#' @importFrom dplyr select distinct mutate filter group_by arrange lead
#'
#' @examples
#' hn_data <- hosp_network_data # read in example data provided in package
#' cleaned_hn_data <- clean_hosp_network(data = hn_data, uniqueID = UniqueEncountID, startDate = BeginDate, endDate = EndDate, unitName = UnitName, roomNum = RoomNumber) # clean the data using specific columns in the dataset
#'
#' cleaned2 <- clean_hosp_network(data = hn_data, uniqueID = UniqueEncountID, startDate = BeginDate, endDate = EndDate, roomNum = RoomNumber) # clean the data again, but omit the unit name data
#'
#' cleaned3 <- clean_hosp_network(data = hn_data, uniqueID = UniqueEncountID, startDate = BeginDate, endDate = EndDate, unitName = UnitName) # clean the data again, but omit the room number data
clean_hosp_network <- function(data, uniqueID, startDate, endDate, unitName = NULL, roomNum = NULL) {

  unique_id <- enquo(uniqueID)

  start_date <- enquo(startDate)

  end_date <- enquo(endDate)

  unit_name <- enquo(unitName)

  room_num <- enquo(roomNum)

  cleaned_data <- data %>%
    select(!!unique_id, !!start_date, !!end_date, !!unit_name, !!room_num) %>%
    distinct(.keep_all = TRUE) %>%
    mutate(start_date = as.POSIXct(!!start_date, format = "%Y-%m-%d %H:%M:%S"),
           end_date = as.POSIXct(!!end_date, format = "%Y-%m-%d %H:%M:%S")) %>%
    filter(end_date <= Sys.time()) %>%
    group_by(!!unique_id) %>%
    arrange(start_date, .by_group = TRUE)

  if(missing(unitName) | deparse(substitute(unitName)) == "NULL") {

    cleaned_data <- cleaned_data

  } else {

    cleaned_data <- cleaned_data %>%
      mutate(next_unit = lead(!!unit_name))

  }

  if(missing(roomNum) | deparse(substitute(roomNum)) == "NULL") {

    cleaned_data <- cleaned_data

  } else {

    cleaned_data <- cleaned_data %>%
      mutate(next_room = lead(!!room_num))

  }

  return(cleaned_data)

}
