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
new_hosp_network <- function(x, fromUnit = NULL, toUnit = NULL, fromRoom = NULL, toRoom = NULL) {

  stopifnot(is.data.frame(x))

  from_unit <- if(fromUnit == "NULL") {

    NULL

  } else {

    if(toUnit == "NULL") {

      stop("You must also specify a to unit if you specified a from unit.", call. = FALSE)

    }

    fromUnit

  }

  to_unit <- if(toUnit == "NULL") {

    NULL

  } else {

    if(fromUnit == "NULL") {

      stop("You must also specify a from unit if you specified a to unit.", call. = FALSE)

    }

    toUnit

  }

  from_room <- if(fromRoom == "NULL") {

    NULL

  } else {

    if(toRoom == "NULL") {

      stop("You must also specify a to room if you specified a from room.", call. = FALSE)

    }

    fromRoom

  }

  to_room <- if(toRoom == "NULL") {

    NULL

  } else {

    if(fromRoom == "NULL") {

      stop("You must also specify a from room if you specified a to room.", call. = FALSE)

    }

    toRoom

  }

  structure(x, class = c("hosp_network", "data.frame"),
            from_unit = x[,from_unit],
            to_unit = x[,to_unit],
            from_room = x[,from_room],
            to_room = x[,to_room])

}
