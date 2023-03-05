#
# Dashboard body
#
# Displays tabs from sidebar navigation
#

bodyUI <- function(id) {
    ns <- NS(id)
    
    body <- shinydashboard::dashboardBody(style = "padding: 0px;",
        tabItems(
            tabItem(tabName = "overview"     , overviewUI(ns("page_overview"))),
            tabItem(tabName = "news_feed"    , newsFeedUI(ns("news_feed"))),
            tabItem(tabName = "country_comp" , countryCompUI(ns("country_comp"))),
            tabItem(tabName = "data_explorer", dataExplorerUI(ns("data_explorer"))),
            tabItem(tabName = "world_map"    , worldMapUI(ns("world_map"))),
            tabItem(tabName = "simulations"  , simulationsUI(ns("simulations"))),
            # tabItem(tabName = "resources"    , h2("Resources overview")),
            tabItem(tabName = "vaccines"     , vaccinesUI(ns("vaccines"))),
            tabItem(tabName = "data_sources" , dataSourcesUI(ns("data_sources"))),
            tabItem(tabName = "metrics"      , metricsUI(ns("metrics")))
            ),
        tags$head(
            tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
        ),
        tags$script(src = "debug.js")
    )
    
    return(body)
}


bodyServer <- function(id, daily_cases, vax, population) {
    
    module <- function(input, output, session) {
        ns <- session$ns
        
        overviewServer("page_overview", daily_cases = daily_cases, vax = vax, population = population)
        newsFeedServer("news_feed")
        countryCompServer("country_comp")
        dataExplorerServer("country_comp", daily_cases = daily_cases, vax = vax, population = population)
        worldMapServer("world_map")
        simulationsServer("simulations")
        vaccinesServer("vaccines")
        dataSourcesServer("data_sources")
        metricsServer("metrics")
    }
    
    return(moduleServer(id, module))
}
