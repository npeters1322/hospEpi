#' @title Summarize Disease-Exposure Data
#'
#' @description Summarize disease-exposure data by finding various statistics (incidence, risk ratio, odds ratio, Fisher p-value, Chi-square p-value) for each disease-exposure combination.
#'
#' @param object an object of class \code{disease_expose}, created with \code{\link{disease_expose}}
#' @param ... additional arguments to be passed to \code{\link{rbindlist}}, such as \code{fill}
#'
#' @return A \code{\link{data.table}} object containing statistics for each disease-exposure combination
#' @export
#'
#' @importFrom data.table rbindlist
summary.disease_expose <- function(object, ...) {

  epi_stats_list <- lapply(seq_along(object[,-1]), function(x) {

    current_col <- names(object[x + 1])

    current_epi_stat_obj <- epi_stats(disease = object[,1], exposure = object[,current_col])

  })

  final_epi_stats <- rbindlist(epi_stats_list, ...)

  rownames(final_epi_stats) <- c(names(object[-1]))

  return(final_epi_stats)

}
