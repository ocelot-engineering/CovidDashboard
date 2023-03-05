#
# Page: World map view
#
# Visualise a heatmap overlaid on the map of the world
#

worldMapUI <- function(id) {
    ns <- NS(id)
    world_map <- underConstructionUI(ns("under_construction"))

    return(world_map)
}

worldMapServer <- function(id) {

    module <- function(input, output, session) {
        ns <- session$ns
        output <- underConstructionServer("under_construction")
        return(output)
    }

    return(moduleServer(id, module))
}
