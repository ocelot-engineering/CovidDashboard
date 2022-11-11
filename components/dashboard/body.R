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
            tabItem(tabName = "country_comp" , countryCompUI(ns("country_comp"))),
            tabItem(tabName = "data_explorer", dataExplorerUI(ns("data_explorer"))),
            tabItem(tabName = "world_map"    , worldMapUI(ns("world_map"))),
            tabItem(tabName = "simulations"  , simulationsUI(ns("simulations"))),
            # tabItem(tabName = "resources"    , h2("Resources overview")),
            tabItem(tabName = "vaccines"     , vaccinesUI(ns("vaccines"))),
            tabItem(tabName = "data_sources" , dataSourcesUI(ns("data_sources")))
            ),
        tags$head(
            tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
        )
    )
    
    return(body)
}


bodyServer <- function(id) {
    
    module <- function(input, output, session) {
        ns <- session$ns
        
        overviewServer("page_overview")
        countryCompServer("country_comp")
        dataExplorerServer("country_comp")
        worldMapServer("world_map")
        simulationsServer("simulations")
        vaccinesServer("vaccines")
        dataSourcesServer("data_sources")
    }
    
    return(moduleServer(id, module))
}
