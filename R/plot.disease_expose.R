#' @title Plot Data for disease_expose Object
#'
#' @description Create grouped bar charts for each disease-exposure combination on one page
#'
#' @param x an object of class \code{disease_expose}, created with \code{\link{disease_expose}}
#' @param ... additional arguments to be passed to \code{\link{geom_bar}}, such as \code{position}
#'
#' @return A \code{\link{gtable}} object of grouped bar charts on one page
#' @export
#'
#' @importFrom ggplot2 ggplot aes geom_bar xlab ylab labs
#' @importFrom snakecase to_title_case
#' @importFrom gridExtra grid.arrange
#' @importFrom gtable gtable
#'
plot.disease_expose <- function(x, ...) {

  plots <- lapply(seq_along(x[,-1]), function(i){

    curr_col <- names(x[i+1])

    ggplot(data = x, aes(x = x[,curr_col], fill = as.factor(x[,1]))) +
      geom_bar(...) +
      xlab(to_title_case(curr_col)) +
      ylab("Count") +
      labs(fill = "Diseased")

  })

  if(length(plots) <= 12){

    num_plot_cols <- floor(sqrt(length(plots)))

    do.call("grid.arrange", c(plots, ncol = num_plot_cols))

  } else {

    warning("Only the first 12 plots were created. Subset the argument to the function to include the disease column and other exposure columns if wanted. Ex. plot(data[,c(1,13:20), where 1 is the disease column and 13:20 are the other exposures you want to plot. You can also use the character names of the columns to subset instead.")

    do.call("grid.arrange", c(plots[1:12], ncol = 3))

  }

}
