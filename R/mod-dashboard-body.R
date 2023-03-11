#
# Dashboard body
#
# Displays tabs from sidebar navigation
#

#' Dashboard body ui function
#'
#' @inherit module_docs params
#' @importFrom shinydashboard dashboardBody tabItems tabItem
#'
body_ui <- function(id) {
    ns <- shiny::NS(id)

    body <- shinydashboard::dashboardBody(style = "padding: 0px;",
        shinydashboard::tabItems(
            shinydashboard::tabItem(tabName = "overview"     , overview_ui(ns("page_overview"))),
            shinydashboard::tabItem(tabName = "news_feed"    , news_feed_ui(ns("news_feed"))),
            shinydashboard::tabItem(tabName = "country_comp" , country_comp_ui(ns("country_comp"))),
            shinydashboard::tabItem(tabName = "data_explorer", data_explorer_ui(ns("data_explorer"))),
            shinydashboard::tabItem(tabName = "world_map"    , world_map_ui(ns("world_map"))),
            shinydashboard::tabItem(tabName = "simulations"  , simulations_ui(ns("simulations"))),
            # shinydashboard::tabItem(tabName = "resources"    , h2("Resources overview")),
            shinydashboard::tabItem(tabName = "vaccines"     , vaccines_ui(ns("vaccines"))),
            shinydashboard::tabItem(tabName = "data_sources" , data_sources_ui(ns("data_sources"))),
            shinydashboard::tabItem(tabName = "metrics"      , metrics_ui(ns("metrics")))
            ),
        shiny::tags$head(
            shiny::tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
        ),
        shiny::tags$script(src = "debug.js")
    )

    return(body)
}

#' Dashboard body server function
#'
#' @inherit module_docs params
#' @inherit common_docs params
#'
body_server <- function(id, daily_cases, vax, population) {

    module <- function(input, output, session) {

        overview_server("page_overview", daily_cases = daily_cases, vax = vax, population = population)
        news_feed_server("news_feed")
        country_comp_server("country_comp")
        data_explorer_server("country_comp", daily_cases = daily_cases, vax = vax, population = population)
        world_map_server("world_map")
        simulations_server("simulations")
        vaccines_server("vaccines")
        data_sources_server("data_sources")
        metrics_server("metrics")
    }

    return(shiny::moduleServer(id, module))
}
