#
# Page: Data exploration
#
# Deep dive the data in table view
#

#' Page: Data exploration ui function
#' @inherit module_docs params
data_explorer_ui <- function(id) {
    ns <- shiny::NS(id)
    data_explorer <- under_construction_ui(id = ns("under_construction"))

    return(data_explorer)
}

#' Page: Data exploration server function
#'
#' @inherit module_docs params
#' @inherit common_docs params
#'
#' @importFrom dplyr slice_head
#'
data_explorer_server <- function(id) {

    module <- function(input, output, session) {
        under_construction_server(id = "under_construction")
    }

    return(shiny::moduleServer(id, module))
}
