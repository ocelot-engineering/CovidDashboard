#
# Page: World map view
#
# Visualise a heatmap overlaid on the map of the world
#

#' Page: World map ui function
#' @inherit module_docs params
world_map_ui <- function(id) {
    ns <- shiny::NS(id)
    world_map <- leaflet::leafletOutput(outputId = ns("world_map"), height = "calc(100vh - 50px)")

    return(world_map)
}

#' Page: World map server function
#' @inherit common_docs params
#' @inherit module_docs params
world_map_server <- function(id, latest_outbreak_rating_by_country) {

    module <- function(input, output, session) {
        output$world_map <- leaflet::renderLeaflet({
            outbreak_ratings <- latest_outbreak_rating_by_country() %>%
                dplyr::select(dplyr::all_of(c(
                    "COUNTRY_CODE",
                    "COUNTRY",
                    "OUTBREAK_RATING",
                    "OUTBREAK_DESC"))
                )

            plot_world_map(outbreak_ratings, zoom = 3)
        })
    }

    return(shiny::moduleServer(id, module))
}
