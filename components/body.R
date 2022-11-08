#
# Dashboard body
#
# Displays tabs from sidebar navigation
#

bodyUI <- function(id) {
    ns <- NS(id)
    
    body <- shinydashboard::dashboardBody(
        tabItems(
            tabItem(tabName = "overview"     , h2("Overview")),
            tabItem(tabName = "country_comp" , h2("Compare")),
            tabItem(tabName = "data_explorer", h2("Data")),
            tabItem(tabName = "world_map"    , h2("Map")),
            tabItem(tabName = "resources"    , h2("Resources overview")),
            tabItem(tabName = "vaccines"     , h2("Vaccines")),
            tabItem(tabName = "data_sources" , h2("Data sources"))
        )
    )
    
    return(body)
}


bodyServer <- function(id) {
    module <- function(input, output, session) {
        # TODO: body server
    }
    
    return(moduleServer(id, module))
}
