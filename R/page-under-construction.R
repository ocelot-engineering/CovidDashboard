#
# Under construction page
#
# Used as a placeholder page
#

underConstructionUI <- function(id) {
    ns <- NS(id)

    overview <- fluidPage(
        fluidRow(style = 'padding-top: 15vh', # pushes it down by 15% of the screen
            column(width = 12, h1("Coming Soon", style="text-align: center; font-size: 100px; opacity: 0.1;"))
        ),
        fluidRow(
            column(width = 12, h1(shiny::icon('screwdriver-wrench'), style="text-align: center; font-size: 200px; opacity: 0.1;"))
        )
    )

    return(overview)
}

underConstructionServer <- function(id) {

    module <- function(input, output, session) {
        ns <- session$ns
        output <- NULL
        return(output)
    }

    return(moduleServer(id, module))
}
