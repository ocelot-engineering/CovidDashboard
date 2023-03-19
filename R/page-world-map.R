#
# Page: World map view
#
# Visualise a heatmap overlaid on the map of the world
#

#' Page: World map ui function
#' @inherit module_docs params
world_map_ui <- function(id) {
    ns <- shiny::NS(id)
    world_map <- under_construction_ui(id = ns("under_construction"))

    return(world_map)
}

#' Page: World map server function
#' @inherit module_docs params
world_map_server <- function(id) {

    module <- function(input, output, session) {
        under_construction_server(id = "under_construction")
    }

    return(shiny::moduleServer(id, module))
}
