#
# Page: Metrics
#
# Explanation of metrics
#

#' Page: Metrics ui function
#' @inherit module_docs params
metrics_ui <- function(id) {
    ns <- shiny::NS(id)
    metrics <- under_construction_ui(id = ns("under_construction"))

    return(metrics)
}

#' Page: Metrics server function
#' @inherit module_docs params
metrics_server <- function(id) {

    module <- function(input, output, session) {
        under_construction_server(id = "under_construction")
    }

    return(shiny::moduleServer(id, module))
}
