#
# Dashboard header
#
# Includes notifications drop down
#

#' Dashboard header ui function
#'
#' @inherit module_docs params
#'
#' @importFrom shinydashboardPlus dashboardHeader
#' @importFrom shinydashboard dropdownMenuOutput
#'
header_ui <- function(id) {
    ns <- shiny::NS(id)

    header <- shinydashboardPlus::dashboardHeader(
        title = "COVID-19 Dashboard",
        shinydashboard::dropdownMenuOutput(ns("notificationsMenu"))
    )

    return(header)
}

#' Dashboard header server function
#'
#' @inherit module_docs params
#'
#' @importFrom shinydashboard renderMenu dropdownMenu
#' @importFrom shinydashboardPlus notificationItem
header_server <- function(id) {

    module <- function(input, output, session) {
        # TODO: connect notifications to real events

        output$notificationsMenu <- shinydashboard::renderMenu({
            shinydashboard::dropdownMenu(type = "notifications",
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

    return(shiny::moduleServer(id, module))
}
