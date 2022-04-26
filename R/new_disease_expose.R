#' @title Constructor to Create a 'disease_expose' Object
#'
#' @description Creates an object of class disease_expose with the data provided
#'
#' @param x The \code{\link{data.frame}} containing disease-exposure data
#' @param disease Quoted name or unquoted numeric value of the column containing the disease status data
#' @param exposures The column(s) containing exposure data, either given as a vector of quoted names or unquoted numeric values or a single quoted name or unquoted numeric value (if there is only one exposure)
#'
#' @return An object of class disease_expose and data.frame containing binary variables for disease and exposure data
#' @export
#'
#' @examples
#' de_data <- disease_expose_data
#' cleaned_de_data <- clean_disease_expose(data = de_data, disease = "disease", noDisease = "No", exposures = c("exposure1", "exposure2", "exposure3"))
#' de_object <- new_disease_expose(cleaned_de_data, disease = 1, exposures = 2:8)
new_disease_expose <- function(x, disease, exposures) {

  stopifnot(is.data.frame(x), length(disease) == 1)

  data <- x

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

  dis_exp <- data[,c(disease, exposures)]

  not_binary <- lapply(dis_exp, function(x){

    if(isFALSE(setequal(sort(unique(x)), c(0,1)))) {
      stop("All columns must be binary. The clean_disease_expose function could help with that.",
           call. = FALSE)
    }

  })

  structure(dis_exp, class = c("disease_expose", "data.frame"))

}
