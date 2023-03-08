#
# Page: Data sources
#
# Explanation of data sources used
#

#' Page: Data sources ui function
#' @inherit module_docs params
data_sources_ui <- function(id) {
    ns <- shiny::NS(id)
    data_sources <- under_construction_ui(id = ns("under_construction"))

    return(data_sources)
}

#' Page: Data sources server function
#' @inherit module_docs params
data_sources_server <- function(id) {

    module <- function(input, output, session) {
        under_construction_server(id = "under_construction")
    }

    return(shiny::moduleServer(id, module))
}
