#
# Page: News Feed
#
# Feed of notifications received. Header notifications will link to here.
#

#' Page: News feed ui function
#' @inherit module_docs params
news_feed_ui <- function(id) {
    ns <- shiny::NS(id)
    news_feed <- under_construction_ui(id = ns("under_construction"))

    return(news_feed)
}

#' Page: News feed server function
#' @inherit module_docs params
news_feed_server <- function(id) {

    module <- function(input, output, session) {
        under_construction_server(id = "under_construction")
    }

    return(shiny::moduleServer(id, module))
}
