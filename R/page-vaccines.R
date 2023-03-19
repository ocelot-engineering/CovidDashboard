#
# Page: Vaccines
#
# Understand where to find reliable, up-to-date and accurate information about
#  vaccines
#

#' Page: Vaccines ui function
#' @inherit module_docs params
vaccines_ui <- function(id) {
    ns <- shiny::NS(id)
    vaccine <- under_construction_ui(id = ns("under_construction"))

    return(vaccine)
}

#' Page: Vaccines server function
#' @inherit module_docs params
vaccines_server <- function(id) {

    module <- function(input, output, session) {
        under_construction_server(id = "under_construction")
    }

    return(shiny::moduleServer(id, module))
}
