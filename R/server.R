#
# Main server function for app
#

#' Server function
#' @keywords internal
#' @import shiny
server <- function(input, output) {

    # Data ---------------------------------------------------------------------
    daily_cases <- get_daily_cases()
    vax         <- get_vaccination()
    population  <- get_population()

    # Components ---------------------------------------------------------------
    headerServer(id = "app_header")
    sidebarServer(id = "left_sidebar")
    bodyServer(id = "dashboard_body", daily_cases = daily_cases, vax = vax, population = population)
    controlbarSever(id = "controlbar")

    # Trigger debug from javascript --------------------------------------------
    observeEvent(input$debug, {
        message("browser() triggered by javascript function debug()")
        browser()
    })
}