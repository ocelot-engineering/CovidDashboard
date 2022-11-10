#
# Sidebar component for dashboard
#
# Includes page selection, 
#

sidebarUI <- function(id) {
    ns <- NS(id)
    
    sidebar <- shinydashboardPlus::dashboardSidebar(
        menuItemOutput(ns('menu'))
      , tags$script(src = "sidebar_triggers.js")
    )
    
    return(sidebar)
}

sidebarServer <- function(id) {
    
    module <- function(input, output, session) {
        ns <- session$ns
        
        output$menu <- renderMenu({
            sidebarMenu(
                id = ns("sidebar_menu")
              , menuItem(text = "World Overview"    , tabName = "overview"     , icon = shiny::icon("dashboard"))
              , menuItem(text = "Country Comparison", tabName = "country_comp" , icon = shiny::icon("chart-column"))
              , menuItem(text = "Raw Data Explorer" , tabName = "data_explorer", icon = shiny::icon("table"))
              , menuItem(text = "World Map"         , tabName = "world_map"    , icon = shiny::icon("earth-americas"))
              , menuItem(text = "Simulations"       , tabName = "simulations"  , icon = shiny::icon("circle-nodes"))
              , menuItem(text = "Resources"         , tabName = "resources"    , icon = shiny::icon("book"),
                         menuSubItem(text = 'Vaccines'    , tabName = 'vaccines'    , icon = shiny::icon("syringe")),
                         menuSubItem(text = 'Data Sources', tabName = 'data_sources', icon = shiny::icon("database"))
                         )
            )
        })
        
        return(output)
    }
    
    return(moduleServer(id, module))
}
