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
    header_server(id = "app_header")
    sidebar_server(id = "left_sidebar")
    body_server(id = "dashboard_body", daily_cases = daily_cases, vax = vax, population = population)
    controlbar_sever(id = "controlbar")

    # Trigger debug from javascript --------------------------------------------
    shiny::observeEvent(input$debug, {
        message("browser() triggered by javascript function debug()")
        browser()
    })
}