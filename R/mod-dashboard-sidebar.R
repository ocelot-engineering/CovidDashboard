#
# Sidebar component for dashboard
#

#' Dashboard sidebar ui function
#'
#' @inherit module_docs params
#'
#' @importFrom shinydashboardPlus dashboardSidebar
#' @importFrom shinydashboard menuItemOutput
#'
sidebar_ui <- function(id) {
    ns <- shiny::NS(id)

    sidebar <- shinydashboardPlus::dashboardSidebar(
        shinydashboard::menuItemOutput(outputId = ns("menu"))
    )

    return(sidebar)
}

#' Dashboard sidebar server function
#'
#' @inherit module_docs params
#'
#' @importFrom shinydashboard renderMenu sidebarMenu menuItem menuSubItem
#'
sidebar_server <- function(id) {

    module <- function(input, output, session) {
        ns <- session$ns

        output$menu <- shinydashboard::renderMenu({
            shinydashboard::sidebarMenu(
                id = ns("sidebar_menu"),
                shinydashboard::menuItem(text = "World Overview",     tabName = "overview",      icon = shiny::icon("dashboard")),
                shinydashboard::menuItem(text = "News Feed",          tabName = "news_feed",     icon = shiny::icon("message")),
                shinydashboard::menuItem(text = "Country Comparison", tabName = "country_comp",  icon = shiny::icon("chart-column")),
                shinydashboard::menuItem(text = "Raw Data Explorer",  tabName = "data_explorer", icon = shiny::icon("table")),
                shinydashboard::menuItem(text = "World Map",          tabName = "world_map",     icon = shiny::icon("earth-americas")),
                shinydashboard::menuItem(text = "Simulations",        tabName = "simulations",   icon = shiny::icon("circle-nodes")),
                shinydashboard::menuItem(text = "Resources",          tabName = "resources",     icon = shiny::icon("book"),
                        shinydashboard::menuSubItem(text = "Vaccines",     tabName = "vaccines",     icon = shiny::icon("syringe")),
                        shinydashboard::menuSubItem(text = "Data Sources", tabName = "data_sources", icon = shiny::icon("database")),
                        shinydashboard::menuSubItem(text = "Metrics",      tabName = "metrics",      icon = shiny::icon("chart-simple"))
                        )
            )
        })

        return(output)
    }

    return(shiny::moduleServer(id, module))
}
