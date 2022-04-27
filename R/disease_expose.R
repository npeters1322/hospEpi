#' @title Helper to Create a \code{disease_expose} Object
#'
#' @description Creates an object of class \code{disease_expose} with the data provided and selected in the Shiny gadget
#'
#' @param x The \code{\link{data.frame}} containing disease-exposure data, with all disease and exposure columns as binary variables
#'
#' @return An object of class \code{disease_expose} and \code{data.frame} containing binary variables for disease and exposure data
#' @export
#'
#' @importFrom miniUI miniPage gadgetTitleBar miniContentPanel
#' @importFrom shiny radioButtons checkboxGroupInput observe updateCheckboxGroupInput observeEvent stopApp runGadget dialogViewer
#'
#' @examples
#' \dontrun{
#'
#' de_data <- disease_expose_data # use the example data in the package
#'
#' cleaned_de_data <- clean_disease_expose(data = de_data, disease = "disease", noDisease = "No", exposures = c("exposure1", "exposure2", "exposure3")) # clean the data using specific columns in the dataset
#'
#' de_object <- disease_expose(cleaned_de_data) # simply call the function and select specifics in the Shiny gadget that pops up
#' }
disease_expose <- function(x) {

  x <- as.data.frame(x)

  ui <- miniPage(

    gadgetTitleBar("Select Your Data's Disease and Exposure Columns:"),

    miniContentPanel(

      radioButtons("disease_choice", "Choose Your Disease Column:", choices = names(x)),

      checkboxGroupInput("poss_exposures", "Choose Your Exposure Column(s):", choices = names(x))

    )

  )

  server <- function(input, output, session) {

    observe({

      checked_disease <- input$disease_choice

      unchecked <- names(x)[names(x) != checked_disease]

      if(is.null(checked_disease)) {

        unchecked <- character(0)

      }

      updateCheckboxGroupInput(session, "poss_exposures", label = "Choose Your Exposure Column(s):", choices = unchecked)

    })

    observeEvent(input$done, {

      if(length(input$disease_choice) == 0) {

        stopApp(stop("No disease column checked. Please try again.", call. = FALSE))

      }

      if(length(input$poss_exposures) == 0) {

        stopApp(stop("No exposure column(s) checked. Please try again.", call. = FALSE))

      }

      dis_exp <- x[, c(input$disease_choice, input$poss_exposures)]

      new_obj <- new_disease_expose(dis_exp, disease = 1, exposures = 2:ncol(dis_exp))

      stopApp(new_obj)

    })

    observeEvent(input$cancel, {

      stopApp(stop("Selections cancelled.", call. = FALSE))

    })

  }

  runGadget(ui, server, viewer = dialogViewer("Select Disease and Exposure Columns", height = 500))

}
