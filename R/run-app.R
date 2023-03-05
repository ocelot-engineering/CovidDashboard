#
# Run application
#

#' Run the shiny application
#' @import shiny
run_app <- function() {
    app_dir <- shinyApp(ui = ui, server = server)
    shiny::runApp(appDir = app_dir)
}