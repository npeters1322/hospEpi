#' @title Disease-Exposure Cleaning Function
#'
#' @description Takes disease-exposure data and makes all columns binary, which is needed to use other functions in the package
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
#' @examples
#' de_data <- disease_expose_data # read in example data provided in package
#' cleaned_de_data <- clean_disease_expose(data = de_data, disease = "disease", noDisease = "No", exposures = c("exposure1", "exposure2", "exposure3")) # clean the data using specific columns in the dataset
#'
#' cleaned2 <- clean_disease_expose(data = de_data, disease = "disease", noDisease = "No", exposures = c(3,4,5)) # clean the data again, but use the number of each exposure column instead
#'
#' cleaned3 <- clean_disease_expose(data = de_data, disease = 2, exposures = c("exposure1", "exposure2", "exposure3")) # clean the data, but use the number of the disease column instead of the name
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

  binary_cols <- unlist(lapply(disease_exposure_dummies, function(x){

    if(isFALSE(setequal(sort(unique(x)), c(0,1)))) {

      return(FALSE)

    } else {

      return(TRUE)

    }

  }))

  data_binary <- disease_exposure_dummies[, binary_cols]

  if(is.null(noDisease) || noDisease == 0) {

    disease_cols <- which(startsWith(names(data_binary), names(disease_exposures)[1]))

    exposure_cols <- which(!startsWith(names(data_binary), names(disease_exposures)[1]))

    data_binary <- data_binary[,c(disease_cols, exposure_cols)]

  } else {

    disease_cols <- which(startsWith(names(data_binary), names(disease_exposures)[1]))

    exposure_cols <- which(!startsWith(names(data_binary), names(disease_exposures)[1]))

    data_binary <- data_binary[,c(disease_cols, exposure_cols)]

    no_disease_col_logi <- which(names(data_binary) %in% paste0(names(disease_exposures)[1], "_", noDisease))

    if(length(no_disease_col_logi) == 0) {

      data_binary <- data_binary

      warning(paste0("Disease status = ", noDisease, " not found. Please make sure to correctly spell it."))

    } else {

      data_binary <- data_binary[, -no_disease_col_logi]

    }

  }

  return(data_binary)

}
