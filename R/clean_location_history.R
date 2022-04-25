#' @title Clean Patient Location History Data
#'
#' @description To use other location history functions in this package, your data must have columns for: patient's first unit and patient's next unit or patient's first room and patient's next room. There might be multiple rows per patient, but each row should always have a beginning and ending room and/or unit for each encounter.
#'
#' @param data A \code{\link{data.frame}} containing patient location history data
#' @param uniqueID A unique identifier for each encounter or patient
#' @param startDate Column name for the column containing the start date for an enounter
#' @param endDate Column name for the column containing the end date for an enounter
#' @param unitName Optional column name for the column containing the unit name data
#' @param roomNum Optional column name for the column containing the room number data
#'
#' @return A \code{\link{data.frame}} containing the cleaned patient location history data
#' @export
#'
#' @importFrom rlang enquo
#' @importFrom dplyr select distinct mutate filter group_by arrange lead
#'
clean_location_history <- function(data, uniqueID, startDate, endDate, unitName = NULL, roomNum = NULL) {

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

  if(is.null(unit_name)) {

    cleaned_data <- cleaned_data

  } else {

    cleaned_data <- cleaned_data %>%
      mutate(next_unit = lead(!!unit_name))

  }

  if(is.null(room_num)) {

    cleaned_data <- cleaned_data

  } else {

    cleaned_data <- cleaned_data %>%
      mutate(next_room = lead(!!room_num))

  }

  return(cleaned_data)

}
