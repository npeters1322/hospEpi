#' @title Calculate Various Statistics for an Epidemiological Analysis
#'
#' @description Calculate various statistics common in an epidemiological analysis, such as incidence, risk ratio, odds ratio, Fisher's exact, and Chi-square, for a single disease-exposure combination
#'
#' @param disease The disease column, made up of 1s and 0s
#' @param exposure The exposure column, made up of 1s and 0s
#'
#' @return A \code{\link{data.frame}} with one row containing various statistics in the columns
#'
#' @section Thanks:
#' Special thanks to Josh Sadowski for providing the bones of this function, which I have added to and edited.
#'
#' @importFrom stats chisq.test fisher.test
#'
epi_stats <- function(disease, exposure) {

  disease <- factor(disease, levels = c(0,1))

  exposure <- factor(exposure, levels = c(0,1))

  tbl_dis_exp <- table(disease, exposure)

  a <- tbl_dis_exp[which(rownames(tbl_dis_exp) == "1"), which(colnames(tbl_dis_exp) == "1")]

  b <- tbl_dis_exp[which(rownames(tbl_dis_exp) == "0"), which(colnames(tbl_dis_exp) == "1")]

  c <- tbl_dis_exp[which(rownames(tbl_dis_exp) == "1"), which(colnames(tbl_dis_exp) == "0")]

  d <- tbl_dis_exp[which(rownames(tbl_dis_exp) == "0"), which(colnames(tbl_dis_exp) == "0")]

  incidence_exposed <- (a / (a + b))

  incidence_unexposed <- (c / (c + d))

  risk_ratio <- incidence_exposed / incidence_unexposed

  log_rr <- log(risk_ratio)

  int_outcome <- sqrt(((b / a) / (a + b)) + ((d / c) / (c + d)))

  rr_upp_ci <- round(exp(log_rr + (1.96 * int_outcome)), 2)

  rr_low_ci <- round(exp(log_rr - (1.96 * int_outcome)), 2)

  rr_ninety_five_ci <- c(rr_low_ci, rr_upp_ci)

  odds_ratio <- ((a * d) / (b * c))

  log_or <- log(odds_ratio)

  or_outcome <- sqrt((1 / a) + (1 / b) + (1 / c) + (1 / d))

  or_upp_ci <- round(exp(log_or + (1.96 * or_outcome)), 2)

  or_low_ci <- round(exp(log_or - (1.96 * or_outcome)), 2)

  two_by_two <- matrix(c(a, b, c, d), nrow = 2, ncol = 2)

  colnames(two_by_two) <- c("Disease", "No Disease")

  rownames(two_by_two) <- c("Exposured", "No Exposure")

  fisher <- fisher.test(tbl_dis_exp)

  chi_square <- chisq.test(tbl_dis_exp)

  output <- data.frame(incidence_exposed, incidence_unexposed, risk_ratio, rr_low_ci, rr_upp_ci, odds_ratio, or_low_ci, or_upp_ci, fisher$p.value, chi_square$p.value)

  names(output) <- c("Incidence in Exposed", "Incidence in Unexposed", "Risk Ratio (RR)", "RR Lower 95% CI", "RR Upper 95% CI", "Odds Ratio (OR)", "OR Lower 95% CI",
                     "OR Upper 95% CI", "Fisher P-Value", "Chi-Square P-Value")

  return(output)

}
