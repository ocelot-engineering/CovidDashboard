#
# Page: Country comparison
#
# Compare stats of multiple countries side-by-side
#

#' Page: Country comparison ui function
#' @inherit module_docs params
country_comp_ui <- function(id) {
    ns <- shiny::NS(id)
    country_comp <- under_construction_ui(id = ns("under_construction"))

    return(country_comp)
}

#' Page: Country comparison server function
#' @inherit module_docs params
country_comp_server <- function(id) {

    module <- function(input, output, session) {
        under_construction_server(id = "under_construction")
    }

    return(shiny::moduleServer(id, module))
}
