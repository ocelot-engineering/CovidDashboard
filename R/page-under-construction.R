#
# Under construction page
#
# Used as a placeholder page
#

#' Under construction placeholder ui function
#' @inherit module_docs params
under_construction_ui <- function(id) {
    ns <- shiny::NS(id)

    overview <- shiny::fluidPage(
        shiny::fluidRow(style = "padding-top: 15vh", # pushes it down by 15% of the screen
            shiny::column(width = 12, shiny::h1("Coming Soon", style = "text-align: center; font-size: 100px; opacity: 0.1;"))
        ),
        shiny::fluidRow(
            shiny::column(width = 12, shiny::h1(shiny::icon("screwdriver-wrench"), style = "text-align: center; font-size: 200px; opacity: 0.1;"))
        )
    )

    return(overview)
}

#' Under construction placeholder server function
#' @inherit module_docs params
under_construction_server <- function(id) {

    module <- function(input, output, session) {
        return(invisible(NULL))
    }

    return(shiny::moduleServer(id, module))
}
