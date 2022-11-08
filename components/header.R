#
# Dashboard header
#
# Includes notifications drop down
#


headerUI <- function(id) {
    ns <- NS(id)
    
    header <- shinydashboardPlus::dashboardHeader(
        title = "COVID-19 Dashboard"
      , fixed = TRUE
      , dropdownMenuOutput(ns("notificationsMenu"))
    )
    
    return(header)
}

headerServer <- function(id) {
    
    module <- function(input, output, session) {
        # TODO: connect notifications to real events
        
        ns <- session$ns
        
        output$notificationsMenu <- renderMenu({
            dropdownMenu(type = "notifications", 
                         shinydashboardPlus::notificationItem(
                             text = "Possible outbreak starting in X", 
                             icon = shiny::icon("virus-covid"),
                             status = "warning"), 
                         shinydashboardPlus::notificationItem(
                             text = "Mask mandate on public transport in X",
                             icon = shiny::icon("mask-face"),
                             status = "warning"),
                         shinydashboardPlus::notificationItem(
                             text = "Outbreak slowing in X", 
                             shiny::icon("virus-covid-slash")
                             , status = "success"), 
                         shinydashboardPlus::notificationItem(
                             text = "Stay at home orders for X",
                             icon = shiny::icon("exclamation-triangle"),
                             status = "danger"),
                         shinydashboardPlus::notificationItem(
                             text = "ABC vaccine rollout started in X",
                             icon = shiny::icon("syringe"),
                             status = "info")
                         )
        })
    }
    
    return(moduleServer(id, module))
}
