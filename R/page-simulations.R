#
# Page: Simulations
#
# Simulate impacts given actions such as mask mandates and stay at home orders.
#

#' Page: Simulations ui function
#' @inherit module_docs params
simulations_ui <- function(id) {
    ns <- shiny::NS(id)
    simulations <- under_construction_ui(id = ns("under_construction"))

    return(simulations)
}

#' Page: Simulations server function
#' @inherit module_docs params
simulations_server <- function(id) {

    module <- function(input, output, session) {
        under_construction_server(id = "under_construction")
    }

    return(shiny::moduleServer(id, module))
}
