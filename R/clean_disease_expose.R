#' @title Disease-Exposure Cleaning Function
#'
#' @description Takes disease-exposure data and makes all columns binary, which is needed to use the rest of the package
#'
#' @param data The \code{\link{data.frame}} containing disease-exposure data
#' @param disease Quoted name or unquoted numeric value of the column containing the disease status data
#' @param noDisease Optional, with a default of NULL. A quoted string specifying how disease status equal to not diseased is listed in the disease column.
#' @param exposures The column(s) containing exposure data, either given as a vector of quoted names or unquoted numeric values or a single quoted name or unquoted numeric value (if there is only one exposure)
#'
#' @return A data.frame containing binary variables for disease and exposure data
#' @export
#'
#' @importFrom fastDummies dummy_cols
#'
clean_disease_expose <- function(data, disease, noDisease = NULL, exposures) {

  data <- as.data.frame(data)

  if(is.numeric(disease)) {

    disease <- names(data)[disease]

  } else {

    disease <- disease

  }

  if(is.numeric(exposures)) {

    exposures <- names(data)[exposures]

  } else {

    exposures <- exposures

  }

  disease_exposures <- data[, c(disease, exposures)]

  disease_exposure_dummies <- dummy_cols(disease_exposures)

  numeric_cols <- unlist(lapply(disease_exposure_dummies, is.numeric))

  data_binary <- disease_exposure_dummies[, numeric_cols]

  if(is.null(noDisease) || noDisease == 0) {

    data_binary <- data_binary

  } else {

    no_disease_col_logi <- which(names(data_binary) %in% paste0(names(disease_exposures)[1], "_", noDisease))

    data_binary <- data_binary[, -no_disease_col_logi]

  }

  return(data_binary)

}
