#
# Control bar
#
# Functions as the right-side sidebar in the dashboard
#

controlbarUI <- function(id) {
    ns <- NS(id)
    
    controlbar <- shinydashboardPlus::dashboardControlbar(
        shinydashboardPlus::controlbarMenu(id = ns("controlbar_menu"),
            shinydashboardPlus::controlbarItem(title = shiny::icon("gear"), "Settings"),
            shinydashboardPlus::controlbarItem(title = shiny::icon("code"), "Contributing")
        )
    )
    
    return(controlbar)
}

controlbarSever <- function(id) {
    module <- function(input, output, session) {
        # TODO: control bar server
    }
    
    return(moduleServer(id, module))
}