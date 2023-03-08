#
# Control bar
#
# Functions as the right-side sidebar in the dashboard
#

#' Dashboard controlbar ui function
#'
#' @inherit module_docs params
#' @importFrom shinydashboardPlus dashboardControlbar controlbarMenu controlbarItem
#'
controlbar_ui <- function(id) {
    ns <- shiny::NS(id)

    controlbar <- shinydashboardPlus::dashboardControlbar(
        shinydashboardPlus::controlbarMenu(id = ns("controlbar_menu"),
            shinydashboardPlus::controlbarItem(title = shiny::icon("gear"), "Settings"),
            shinydashboardPlus::controlbarItem(title = shiny::icon("code"), "Contributing")
        )
    )

    return(controlbar)
}

#' Dashboard controlbar server function
#'
#' @inherit module_docs params
#'
controlbar_sever <- function(id) {
    module <- function(input, output, session) {
        # TODO: control bar server
    }

    return(shiny::moduleServer(id, module))
}